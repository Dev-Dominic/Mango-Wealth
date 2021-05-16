from flask import Flask
from flask_cors import CORS
import json
import os
from .controllers import api

app = Flask(__name__)
app.register_blueprint(api, url_prefix="/api")

CORS(app)

from dotenv import load_dotenv
load_dotenv()


print(os.getenv('DB_HOST'))
print(os.getenv('DB_USER'))
print(os.getenv('DB_NAME'))
print(os.getenv('JWT_SECRET'))

@app.route("/")
def mango_wealth():
    return json.dumps({"hello": "Mango Wealth Start!"})


if __name__ == "__main__":
    app.run()
