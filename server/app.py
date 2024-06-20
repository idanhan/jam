from flask import Flask
from flask_smorest import Api
import os
from dotenv import load_dotenv

from db import db

from resources.user_blp import blp as userblueprint

import models


name = 'mysql+pymysql://admin:Ihporcu13684@road-db.cfumyciqcaqf.eu-north-1.rds.amazonaws.com:3306/roadsdb'



def create_app():
    app = Flask(__name__)
    app.config["API_TITLE"] = "Stores REST API"
    app.config["API_VERSION"] = "v1"
    app.config["OPENAPI_VERSION"] = "3.0.3"
    app.config["OPENAPI_URL_PREFIX"] = "/"
    app.config["OPENAPI_SWAGGER_UI_PATH"] = "/swagger-ui"
    app.config[
        "OPENAPI_SWAGGER_UI_URL"
    ] = "https://cdn.jsdelivr.net/npm/swagger-ui-dist/"
    app.config["SQLALCHEMY_DATABASE_URI"] = name
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
    app.config["PROPAGATE_EXCEPTIONS"] = True
    db.init_app(app)
    api = Api(app)

    load_dotenv()

    


    with app.app_context():
        db.create_all()
    
    api.register_blueprint(userblueprint)
    return app