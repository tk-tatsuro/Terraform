from django.shortcuts import render
from django.views.generic import TemplateView
from .forms import AccountForm, AddAccountForm
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect, HttpResponse
from django.urls import reverse
from django.contrib.auth.decorators import login_required


# Login
def Login(request):
    # POST
    if request.method == 'POST':
        # Input form User ID・Get password
        ID = request.POST.get('userid')
        Pass = request.POST.get('password')

        # Encryption of Django
        user = authenticate(username=ID, password=Pass)

        # User Certification
        if user:
            # Judge User activation
            if user.is_active:
                # login
                login(request,user)
                # Move Homepage
                return HttpResponseRedirect(reverse('dashboard'))
            else:
                # Can not use account
                return HttpResponse("アカウントが有効ではありません")
        # Fail user encryption
        else:
            return HttpResponse("ログインIDまたはパスワードが間違っています")
    # GET
    else:
        return render(request, 'api/login.html')


# Logout
@login_required
def Logout(request):
    logout(request)
    # Move login page
    return HttpResponseRedirect(reverse('Login'))


# Home page
@login_required
def home(request):
    params = {"UserID": request.user, }
    return render(request, "api/dashboard.html", context=params)


# Registry new
class AccountRegistration(TemplateView):
    def __init__(self):
        self.params = {
            "AccountCreate": False,
            "account_form": AccountForm(),
            "add_account_form": AddAccountForm(),
        }

    # Get process
    def get(self, request):
        self.params["account_form"] = AccountForm()
        self.params["add_account_form"] = AddAccountForm()
        self.params["AccountCreate"] = False
        return render(request, "api/register.html", context=self.params)

    # Post process
    def post(self, request):
        self.params["account_form"] = AccountForm(data=request.POST)
        self.params["add_account_form"] = AddAccountForm(data=request.POST)

        # Validate form input
        if self.params["account_form"].is_valid() and self.params["add_account_form"].is_valid():
            # Save account to DB
            account = self.params["account_form"].save()
            # change hash password
            account.set_password(account.password)
            # Update hashed password
            account.save()

            add_account = self.params["add_account_form"].save(commit=False)
            # AccountForm & AddAccountForm 1vs1 combine
            add_account.user = account

            # Verification of presence / absence of image upload
            if 'account_image' in request.FILES:
                add_account.account_image = request.FILES['account_image']

            # Save to Model
            add_account.save()

            # Update account data
            self.params["AccountCreate"] = True

        else:
            # if invalid form
            print(self.params["account_form"].errors)

        return render(request, "api/register.html", context=self.params)
