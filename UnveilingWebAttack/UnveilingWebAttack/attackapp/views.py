# attackapp/views.py
from django.contrib.auth.hashers import make_password

import os
import numpy as np
import pandas as pd
import joblib
from .models import User
from django.shortcuts import render, redirect
from django.conf import settings
from django.contrib import messages
from keras.models import Sequential, load_model
from keras.layers import Dense
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from .models import User, PredictionResult
from .forms import RegisterForm, LoginForm
from django.core.files.storage import FileSystemStorage
from sklearn.preprocessing import LabelEncoder 
from django.contrib.auth.hashers import check_password, make_password 

DATA_PATH = os.path.join(settings.BASE_DIR, 'dataset', 'web_attack_dataset.csv')

# ------------------ USER AUTH ------------------

def register_user(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        dob = request.POST.get('dob')
        state = request.POST.get('state')
        attack_type = request.POST.get('attack_type')
        password = request.POST.get('password')
        confirm_password = request.POST.get('confirm_password')

        if password != confirm_password:
            messages.error(request, "Passwords do not match.")
            return render(request, 'register.html')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Email already exists.")
            return render(request, 'register.html')

        hashed_password = make_password(password)
        user = User.objects.create(
            name=name,
            email=email,
            phone=phone,
            password=hashed_password,
            dob=dob,
            state=state,
            web_attack_type=attack_type,
            is_active=False
        )

        messages.success(request, "Registered successfully. Wait for admin activation.")
    return redirect('login_user')

def login_user(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')

        try:
            user = User.objects.get(email=email)

            if not user.is_active:
                messages.error(request, "Account not activated. Please wait for admin approval.")
                return render(request, 'user_login.html')

            if check_password(password, user.password):
                request.session['user_id'] = user.id
                request.session['user_name'] = user.name
                return redirect('user_dashboard')
            else:
                messages.error(request, "Invalid password.")

        except User.DoesNotExist:
            messages.error(request, "User not found.")

    return render(request, 'user_login.html')


def user_dashboard(request):
    if 'user_id' not in request.session:
        return redirect('login_user')
    return render(request, 'user_dashboard.html')


def logout_user(request):
    request.session.flush()
    return redirect('index')

# ------------------ ADMIN AUTH ------------------

def admin_login(request):
    if request.method == 'POST':
        if request.POST['username'] == 'admin' and request.POST['password'] == 'admin123':
            request.session['admin_logged_in'] = True
            return redirect('admin_dashboard')
        else:
            return render(request, 'admin_login.html', {'error': 'Invalid credentials'})
    return render(request, 'admin_login.html')


def admin_dashboard(request):
    if not request.session.get('admin_logged_in'):
        return redirect('login_admin')
    return render(request, 'admin_dashboard.html')


def admin_logout(request):
    request.session.flush()
    return redirect('index')

# ------------------ DATASET UPLOAD ------------------

def upload_dataset(request):
    if not request.session.get('admin_logged_in'):
        return redirect('admin_login')

    if request.method == 'POST' and request.FILES.get('dataset'):
        dataset_file = request.FILES['dataset']
        fs = FileSystemStorage(location=os.path.join(settings.BASE_DIR, 'dataset'))
        fs.save('web_attack_dataset.csv', dataset_file)
        messages.success(request, 'Dataset uploaded successfully!')
        return redirect('train_models')
    return render(request, 'upload_dataset.html')


# ------------------ MODEL TRAINING ------------------

def train_models(request):
    if not request.session.get('admin_logged_in'):
        return redirect('admin_login')

    dataset_path = os.path.join(settings.BASE_DIR, 'dataset', 'web_attack_dataset.csv')
    if not os.path.exists(dataset_path):
        messages.error(request, "Dataset not found. Please upload it first.")
        return redirect('upload_dataset')

    df = pd.read_csv(dataset_path)
    df = df.drop(['session_id', 'source_ip', 'destination_ip', 'protocol', 'tcp_flags'], axis=1)
    X = df.drop(['attack_type'], axis=1)
    y = df['attack_type']

    le = LabelEncoder()
    y_encoded = le.fit_transform(y)
    joblib.dump(le, os.path.join(settings.BASE_DIR, 'label_encoder.pkl'))
    
    X_train, X_test, y_train, y_test = train_test_split(X, y_encoded, test_size=0.2, random_state=42)
    accuracy = {}

    rf = RandomForestClassifier()
    rf.fit(X_train, y_train)
    accuracy['Random Forest'] = accuracy_score(y_test, rf.predict(X_test))
    joblib.dump(rf, os.path.join(settings.BASE_DIR, 'rf_model.pkl'))

    svm = SVC()
    svm.fit(X_train, y_train)
    accuracy['SVM'] = accuracy_score(y_test, svm.predict(X_test))
    joblib.dump(svm, os.path.join(settings.BASE_DIR, 'svm_model.pkl'))

    lr = LogisticRegression(max_iter=1000)
    lr.fit(X_train, y_train)
    accuracy['Logistic Regression'] = accuracy_score(y_test, lr.predict(X_test))
    joblib.dump(lr, os.path.join(settings.BASE_DIR, 'lr_model.pkl'))

    knn = KNeighborsClassifier()
    knn.fit(X_train, y_train)
    accuracy['KNN'] = accuracy_score(y_test, knn.predict(X_test))
    joblib.dump(knn, os.path.join(settings.BASE_DIR, 'knn_model.pkl'))

    ann = Sequential()
    ann.add(Dense(64, input_shape=(X.shape[1],), activation='relu'))
    ann.add(Dense(64, activation='relu'))
    ann.add(Dense(len(le.classes_), activation='softmax'))
    ann.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
    ann.fit(X_train, y_train, epochs=20, batch_size=16, verbose=0)
    loss, acc = ann.evaluate(X_test, y_test, verbose=0)
    accuracy['ANN'] = acc
    ann.save(os.path.join(settings.BASE_DIR, 'ann_model.h5'))

    messages.success(request, "All models trained and saved successfully.")
    return render(request, 'train_model.html', {'accuracy': accuracy})

# ------------------ LOAD MODELS ------------------

def load_all_models():
    base = settings.BASE_DIR
    models = {
        'ANN': load_model(os.path.join(base, 'ann_model.h5')),
        'RF': joblib.load(os.path.join(base, 'rf_model.pkl')),
        'SVM': joblib.load(os.path.join(base, 'svm_model.pkl')),
        'LR': joblib.load(os.path.join(base, 'lr_model.pkl')),
        'KNN': joblib.load(os.path.join(base, 'knn_model.pkl')),
    }
    return models

# ------------------ PREDICTION ------------------

from collections import Counter

def predict_attack(request):
    if 'user_id' not in request.session:
        return redirect('login_user')

    if request.method == 'POST':
        try:
            src_ip = request.POST.get('source_ip')
            dst_ip = request.POST.get('destination_ip')
            protocol = request.POST.get('protocol')
            tcp_flags = request.POST.get('tcp_flags')
            src_port = int(request.POST.get('source_port'))
            dst_port = int(request.POST.get('destination_port'))
            pkt_size = int(request.POST.get('packet_size'))
            duration = float(request.POST.get('duration_sec'))

            input_data = np.array([[src_port, dst_port, pkt_size, duration]])
            base = settings.BASE_DIR
            le = joblib.load(os.path.join(base, 'label_encoder.pkl'))

            rf = joblib.load(os.path.join(base, 'rf_model.pkl'))
            svm = joblib.load(os.path.join(base, 'svm_model.pkl'))
            lr = joblib.load(os.path.join(base, 'lr_model.pkl'))
            knn = joblib.load(os.path.join(base, 'knn_model.pkl'))
            ann = load_model(os.path.join(base, 'ann_model.h5'))

            # Get individual predictions
            preds = [
                le.inverse_transform([rf.predict(input_data)[0]])[0],
                le.inverse_transform([svm.predict(input_data)[0]])[0],
                le.inverse_transform([lr.predict(input_data)[0]])[0],
                le.inverse_transform([knn.predict(input_data)[0]])[0],
                le.inverse_transform([np.argmax(ann.predict(input_data))])[0],
            ]

            # Find most common prediction (majority vote)
            final_prediction = Counter(preds).most_common(1)[0][0]

            # Optional: save to PredictionResult
            PredictionResult.objects.create(
                user_id=request.session['user_id'],
                session_id=f"S-{np.random.randint(1000, 9999)}",
                source_ip=src_ip,
                destination_ip=dst_ip,
                protocol=protocol,
                tcp_flags=tcp_flags,
                source_port=src_port,
                destination_port=dst_port,
                packet_size=pkt_size,
                duration_sec=duration,
                model_name="Consensus",
                mitm_prediction=final_prediction,
                session_hijack_prediction="Unknown"
            )

            return render(request, 'predict.html', {
                'prediction': final_prediction,
                'input': request.POST
            })

        except Exception as e:
            return render(request, 'predict.html', {'error': str(e)})

    return render(request, 'predict.html')




def index(request):
    return render(request, 'index.html')



def user_profile(request):
    if 'user_id' not in request.session:
        return redirect('login_user')
    
    user = User.objects.get(id=request.session['user_id'])
    return render(request, 'user_profile.html', {'user': user})
    
    
def admin_dashboard(request):
    if not request.session.get('admin_logged_in'):
        return redirect('admin_login')
    return render(request, 'admin_dashboard.html')


def view_users(request):
    if not request.session.get('admin_logged_in'):
        return redirect('login_admin')
    users = User.objects.all()
    return render(request, 'view_users.html', {'users': users})

def toggle_user_status(request, user_id):
    if not request.session.get('admin_logged_in'):
        return redirect('login_admin')
    user = User.objects.get(id=user_id)
    user.is_active = not user.is_active
    user.save()
    return redirect('view_users')


def view_predictions(request):
    if not request.session.get('admin_logged_in'):
        return redirect('login_admin')
    predictions = PredictionResult.objects.all().order_by('-timestamp')
    return render(request, 'view_predictions.html', {'predictions': predictions})


