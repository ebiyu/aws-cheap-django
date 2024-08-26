from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Counter

@api_view(['GET'])
def index(request):
    counter, _ = Counter.objects.get_or_create(id=1)
    counter.count += 1
    counter.save()
    return Response({'message': f'Hello, World!, counter: {counter.count}'})

