# Python Packages
from functools import wraps

# Third-Party Packages
from flask import request
import jwt

def auth_guard(endpoint):
    """ Decorator that determines whether user is able to access endpoint """

    @wraps(endpoint)
    def wrap(*args, **kwargs):
        try:
            # Gets user access token from header
            # Throws an exception if token expires
            print(request.headers)
            access_token = request.headers.get('Authorization').split(' ')[1]
            jwt.decode(access_token, 'secret', algorithms=["HS256"])

            return endpoint(*args, **kwargs)
        except jwt.ExpiredSignatureError:
            print('User access JWT has expired')
            return json.dumps({ 'error': 'Token Expired'}), 401

    return wrap
