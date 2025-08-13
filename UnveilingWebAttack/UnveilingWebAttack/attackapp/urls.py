# attackapp/urls.py

from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('admin_login/', views.admin_login, name='admin_login'),
    path('user_login/', views.login_user, name='login_user'),
    path('register/', views.register_user, name='register_user'),
    path('upload_dataset/', views.upload_dataset, name='upload_dataset'),
    path('train_models/', views.train_models, name='train_models'),
    path('predict/', views.predict_attack, name='predict_attack'),
    path('view_users/', views.view_users, name='view_users'),
    path('logout/', views.logout_user, name='logout_user'),
    path('user_profile/', views.user_profile, name='user_profile'),
    path('admin_logout/', views.admin_logout, name='admin_logout'),
    path('admin_dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('user_dashboard/', views.user_dashboard, name='user_dashboard'),
    path('user_profile/', views.user_profile, name='user_profile'),
    path('toggle_user/<int:user_id>/', views.toggle_user_status, name='toggle_user_status'),
    path('view_predictions/', views.view_predictions, name='view_predictions'),
    
]
