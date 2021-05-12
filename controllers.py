from flask import Blueprint, request
import json

from .services import (get_product_types_service, onboarding_service,
                       login_service, metrics_service, tracking_service)

api = Blueprint('api', __name__)

@api.route('/product_types', methods=['GET'])
def get_product_types():
    return json.dumps(get_product_types_service()), 200

@api.route('/onboarding', methods=['POST'])
def onboarding():
    try:
        # Retrieving body and executing onboarding process using user sign up
        # data, where a response is generated.
        onboarding_body = request.json
        response = onboarding_service(onboarding_body)

        return json.dumps({"success": response}), 200
    except Exception as e:
        print(f"Error during onboarding: {e}")
        error_message = "Unable to complete onboarding process"
        return json.dumps({"error_message": error_message, "success": False}), 500

@api.route('/login', methods=['POST'])
def login():
    pass

@api.route('/tracking', methods=['POST'])
def tracking():
    pass

@api.route('/metrics_service', methods=['GET'])
def user_metrics():
    pass
