from flask import Flask, jsonify
from flask_swagger_ui import get_swaggerui_blueprint

app = Flask(__name__)
# Configuração do Swagger UI
SWAGGER_URL = "/docs"
API_URL = "/static/swagger.yml"
SWAGGER_BLUEPRINT = get_swaggerui_blueprint(
    SWAGGER_URL,
    API_URL,
    config={"app_name": "To-do API"},
)

app.register_blueprint(SWAGGER_BLUEPRINT, url_prefix=SWAGGER_URL)


@app.get("/health")
def health_check_route():
    return jsonify(message="Service healthy!"), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3001)
