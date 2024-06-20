from flask.views import MethodView
from flask_smorest import Blueprint, abort
from sqlalchemy.exc import SQLAlchemyError
from flask import request
from sqlalchemy import DateTime
import datetime
from flask import jsonify

from db import db
from schema import userSchema,tasksSchema
from models.user import Usermod
from models.jam import jamMod
from models.jam_users import jamsUsersMod


blp = Blueprint("jam_Mod",__name__,description="operation on user")
@blp.route("/jam/<string:jamname>",methods = ['GET'])
class user(MethodView):
    @blp.response(200,userSchema)
    def get(self,jamname):
        jam = jamMod.query.filter(jamMod.jamTitle == jamname).first()
        return jam

@blp.route("/jam",methods = ['Post'])
class jamPost(MethodView):
    @blp.response(200,userSchema)
    def post(self):
        data = request.get_json()
        item_data = {
            "jamTitle": data["jamTitle"],
            "jamDescription": data["jamDescription"],
            "jamStartTime": data["jamStartTime"],
            "jamEndTime": data["jamEndTime"],
        }
        jam = jamMod(**item_data)
        db.session.add(jam)
        try:
            db.session.commit()
            print("commited")
        except Exception as e:
            print("an error occured",e)
            db.session.rollback()
            abort(500,message = "An error has occured1")
        return jam 