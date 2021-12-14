from django.db import models

# Create your models here.
class MyUser(models.Model):
    first_name = models.CharField( max_length=150, blank=False)
    last_name = models.CharField( max_length=150, blank=False)
    email = models.EmailField(max_length=150,unique=True,blank=False)
    password = models.CharField(max_length=150,blank=False)
