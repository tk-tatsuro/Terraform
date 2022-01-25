# health check
from django.http import HttpResponse
import logging

logger = logging.getLogger(__name__)


def health_check(request):
    logger.info("healthy")
    return HttpResponse("health check passed")