from flask import Blueprint, request
import json

from .services import (get_product_types_service, onboarding_service,
                       login_service, create_goal_service, metrics_service, tracking_service)

from .utils.auth import auth_guard

api = Blueprint('api', __name__)

@api.route('/product_types', methods=['GET'])
@auth_guard
def get_product_types():
    return json.dumps(get_product_types_service()), 200

@api.route('/onboarding', methods=['POST'])
def onboarding():
    try:
        # Retrieving body and executing onboarding process using user sign up
        # data, where a response is generated.
        onboarding_body = request.json
        success, user_id = onboarding_service(onboarding_body)

        return json.dumps({"success": success, "user_id": user_id}), 200
    except Exception as e:
        print(f"Error during onboarding: {e}")
        error_message = "Unable to complete onboarding process"
        return json.dumps({"error_message": error_message, "success": False}), 500

@api.route('/login', methods=['POST'])
def login():
    try:
        # Retrieving body and executing onboarding process using user sign up
        # data, where a response is generated.
        credentials = request.json
        email, password = credentials['email'], credentials['password']
        access_token, user_id = login_service(email, password)

        response = {
            "access_token": access_token,
            "user_id": user_id
        }
        return json.dumps(response), 200
    except Exception as e:
        print(f"Error during login: {e}")
        error_message = "Unable to authenticate user"

        response = {
            "error_message": error_message,
            "access_token": None,
            "user_id": None
        }
        return json.dumps(response), 500

@api.route('/goal', methods=['POST'])
def create_goal():
    try:
        time_period = request.json.get('time_period')
        value = request.json.get('value')
        user_id = request.json.get('user_id')

        response = create_goal_service(time_period, value, user_id)

        return json.dumps(response), 200
    except Exception as e:
        print(f"Error during goal creation: {e}")
        error_message = "Unable to create new user goal"

        response = {
            "error_message": error_message
        }
        return json.dumps(response), 500

@api.route('/tracking', methods=['POST'])
@auth_guard
def tracking():
    pass

@api.route('/metrics_service', methods=['GET'])
@auth_guard
def user_metrics():
    pass
