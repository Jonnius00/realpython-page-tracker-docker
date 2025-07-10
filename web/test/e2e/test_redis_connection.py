import pytest
import redis

@pytest.fixture
def redis_connection():
    client = redis.StrictRedis(host='localhost', port=6379, db=0)
    yield client
    client.close()

def test_redis_connection(redis_connection):
    assert redis_connection.ping() == True