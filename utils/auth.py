# Python Packages
from functools import wraps
import os
import json

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
            auth = request.headers.get('Authorization')

            if auth is None:
                response = {
                    "error_message": "Access Token Required"
                }
                return json.dumps(response), 500

            access_token = request.headers.get('Authorization').split(' ')[1]
            jwt.decode(access_token, os.getenv('JWT_SECRET'), algorithms=["HS256"])

            return endpoint(*args, **kwargs)
        except jwt.ExpiredSignatureError:
            print('User access JWT has expired')
            return json.dumps({ 'error': 'Token Expired'}), 401

    return wrap
