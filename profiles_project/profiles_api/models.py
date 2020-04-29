from django.db import models
from django.contrib.auth.models import AbstractBaseUser, \
                                       PermissionsMixin, \
                                       BaseUserManager


class UserPorfileManager(BaseUserManager):
    """manager for user profiles"""

    def create_user(self, email, password=None, **extra_fields):
        """creates and save a new user"""
        if not email:
            raise ValueError('users must have email address')
        
        user = self.model(email=self.normalize_email(email), **extra_fields)
        user.set_password(password)
        user.save(using=self._db)

        return user

    def create_superuser(self, email, password):
        """creates and save a new super user"""
        user = self.create_user(email, password)
        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)

        return user


class UserPorfile(AbstractBaseUser, PermissionsMixin):
    """databas model for users in the system"""
    email = models.EmailField(max_length=254, unique=True)
    name = models.CharField(max_length=254)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    objects = UserPorfileManager()

    USERNAME_FIELD = 'email'    

    def get_full_name(self):
        """retrieve full name of user"""
        return self.name

    def get_short_name(self):
        """retrieve short name of the user"""
        return self.name

    def __str__(self):
        """return string representation of our user"""
        return self.email
