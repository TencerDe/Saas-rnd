from django.contrib import admin
from django.urls import path, include

from . views import home_view, about_view

urlpatterns = [
    path('admin/', admin.site.urls),
    path('hello-world/', home_view),
    path('about/', about_view),
    path('hello-world.html/', home_view),
    path('', home_view),
]
