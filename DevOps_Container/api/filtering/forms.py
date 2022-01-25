from django import forms
from django.contrib.auth.models import User
from .models import Account


class AccountForm(forms.ModelForm):
    # Input password : Non display
    password = forms.CharField(widget=forms.PasswordInput(), label="パスワード")

    class Meta:
        # User encryption
        model = User
        # Specify field
        fields = ('username', 'email', 'password')
        # Specify field name
        labels = {'username':"ユーザーID", 'email': "メール"}


class AddAccountForm(forms.ModelForm):
    class Meta:
        # Specify model class
        model = Account
        fields = ('last_name', 'first_name', 'account_image',)
        labels = {'last_name': "苗字", 'first_name': "名前", 'account_image': "写真アップロード", }
