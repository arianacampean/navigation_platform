from rest_framework import serializers

from models.models import MyUser


class MyUserSerializer(serializers.ModelSerializer):
    class Meta:
        model=MyUser
        fields=('id','first_name','last_name','email','password')
