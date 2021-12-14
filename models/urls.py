from django.urls import path

from models import views

urlpatterns = [
    path('api/usersList', views.myUsersList),
]