import os
from functools import cache

from flask import Flask
from redis import Redis, RedisError

app = Flask(__name__)


# controller function
@app.get("/")
def index():
    try:
        page_views = redis().incr("page_views")
    except RedisError:
        app.logger.exception("Redis error")  # pylint: disable=E1101
        # tells pylint to ignore the error E1101 not suppressing it completely
        return "Sorry, something went wrong \N{PENSIVE FACE}", 500
    else:
        return f"This page has been seen {page_views} times."


@cache
def redis():
    # return Redis()
    # return Redis(host="127.0.0.1", port=6379)
    # return Redis.from_url( "redis://localhost:6379/" )
    # return Redis(host="redis-server", port=6379, db=0, decode_responses=True)
    return Redis.from_url(os.getenv("REDIS_URL", "redis://localhost:6379/"))


# This name-main idiom pattern added to let bandit or a similar tool
# test the App against vulnerabilities before deploying the code to production.
# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000, debug=True)
