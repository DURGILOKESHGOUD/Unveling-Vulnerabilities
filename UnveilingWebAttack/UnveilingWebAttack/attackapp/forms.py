# attackapp/forms.py

from django import forms
from .models import User
WEB_ATTACK_CHOICES = [
    ('MITM', 'Man in the Middle'),
    ('Session Hijack', 'Session Hijack'),
    ('Phishing', 'Phishing'),
    ('XSS', 'Cross Site Scripting'),
    ('SQLi', 'SQL Injection')
]

class RegisterForm(forms.ModelForm):
    confirm_password = forms.CharField(widget=forms.PasswordInput)
    dob = forms.DateField(widget=forms.DateInput(attrs={'type': 'date'}))
    attack_type = forms.ChoiceField(choices=WEB_ATTACK_CHOICES)

    class Meta:
        model = User
        fields = ['name', 'phone', 'email', 'password', 'confirm_password', 'dob', 'attack_type', 'state']
        widgets = {
            'password': forms.PasswordInput(),
        }
        
    def clean(self):
        cleaned_data = super().clean()
        pw = cleaned_data.get("password")
        cpw = cleaned_data.get("confirm_password")
        if pw and cpw and pw != cpw:
            raise ValidationError("Passwords do not match.")
        
        
        
class LoginForm(forms.Form):
    email = forms.EmailField()
    password = forms.CharField(widget=forms.PasswordInput)

class PredictionInputForm(forms.Form):
    source_ip = forms.GenericIPAddressField()
    destination_ip = forms.GenericIPAddressField()
    source_port = forms.IntegerField()
    destination_port = forms.IntegerField()
    protocol = forms.CharField()
    packet_size = forms.IntegerField()
    tcp_flags = forms.CharField()
    duration_sec = forms.FloatField()
    model_choice = forms.ChoiceField(choices=[
        ('ANN', 'Artificial Neural Network'),
        ('RF', 'Random Forest'),
        ('SVM', 'Support Vector Machine'),
        ('LR', 'Logistic Regression'),
        ('KNN', 'K-Nearest Neighbors')
    ])
