import pytest
import redis
import os

# defining a separate own fixture for this test, but
# should use the redis_client fixture from conftest.py
""" @pytest.fixture
def redis_connection():
    redis_url = os.environ.get("REDIS_URL", "redis://redis-service:6379")
    client = redis.from_url(redis_url)
    yield client
    client.close()

def test_redis_connection(redis_connection):
    assert redis_connection.ping() == True
"""

def test_redis_connection(redis_client):
    assert redis_client.ping() == True