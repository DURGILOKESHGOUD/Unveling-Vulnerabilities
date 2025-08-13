# attackapp/models.py

from django.db import models

class User(models.Model):
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=15, default='0000000000')
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=100)
    dob = models.DateField(default='2000-01-01')
    attack_type = models.CharField(max_length=50, default='MITM')
    state = models.CharField(max_length=50, default='Unknown')
    web_attack_type = models.CharField(max_length=100, default='MITM')  # Added default to prevent migration issues
    is_active = models.BooleanField(default=False)

    def __str__(self):
        return self.email

class UploadedSession(models.Model):
    session_id = models.CharField(max_length=50)
    source_ip = models.GenericIPAddressField()
    destination_ip = models.GenericIPAddressField()
    source_port = models.IntegerField()
    destination_port = models.IntegerField()
    protocol = models.CharField(max_length=10)
    packet_size = models.IntegerField()
    tcp_flags = models.CharField(max_length=20)
    duration_sec = models.FloatField()
    is_mitm = models.BooleanField()
    is_session_hijack = models.BooleanField()

class PredictionResult(models.Model):
    user_id = models.IntegerField(default=0)
    session_id = models.CharField(max_length=50, default='S-0000')
    source_ip = models.GenericIPAddressField(default='0.0.0.0')
    destination_ip = models.GenericIPAddressField(default='0.0.0.0')
    source_port = models.IntegerField(default=0)
    destination_port = models.IntegerField(default=0)
    protocol = models.CharField(max_length=10, default='TCP')
    packet_size = models.IntegerField(default=0)
    tcp_flags = models.CharField(max_length=20, default='SYN')
    duration_sec = models.FloatField(default=0.0)
    model_name = models.CharField(max_length=20, default='ANN')
    mitm_prediction = models.CharField(max_length=10, default='Unknown')
    session_hijack_prediction = models.CharField(max_length=10, default='Unknown')
    timestamp = models.DateTimeField(auto_now_add=True)

class Admin(models.Model):
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=50)
