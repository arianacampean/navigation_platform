from django.http import JsonResponse
from django.shortcuts import render

# Create your views here.
from rest_framework.decorators import api_view

from models.models import MyUser
from models.serializers import MyUserSerializer


@api_view(['GET', 'POST'])
def myUsersList(request):
    if request.method == "GET":
        users = MyUser.objects.all()
        usersSerailizer = MyUserSerializer(users, many=True)
        return JsonResponse(usersSerailizer.data, safe=False)