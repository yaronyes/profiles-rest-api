import time
from django.db import connections
from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django command tp pause execution until database is avaliable"""

    def handle(self, *args, **options):
        self.stdout.write('waiting for datbase...')
        db_conn = None
        while not db_conn:
            try:
                db_conn = connections['default']
            except OperationalError:
                self.stdout.write('database unavliable, waiting 1 second...')
                time.sleep(1)
        self.stdout.write(self.style.SUCCESS('database avaliable!'))
