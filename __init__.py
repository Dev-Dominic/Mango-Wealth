from flask import Flask
import json
app = Flask(__name__)

@app.route("/")
def mango_wealth():
    return json.dumps({"hello": "Mango Wealth Start!"})


if __name__ == "__main__":
    app.run()
