from django.db import models
from django.contrib.auth.models import User


# Model lass on user account
class Account(models.Model):
    def __str__(self):
        return self.user.username

    # Instance of user encryption (1by1)
    user = models.OneToOneField(User, on_delete=models.CASCADE)

    # field add
    last_name = models.CharField(max_length=100)
    first_name = models.CharField(max_length=100)
    account_image = models.ImageField(upload_to="profile", blank=True)
