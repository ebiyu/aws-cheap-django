import random

from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def index(request):
    return Response({'message': f'Hello, World!, {random.randint(1, 100)}'})

