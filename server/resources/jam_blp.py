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


blp2 = Blueprint("jam_Mod",__name__,description="operation on jams")


@blp2.route("/jam",methods = ['POST'])
class jamPost(MethodView):
    @blp2.response(200,tasksSchema)
    def post(self):
        data = request.get_json()
        item_data = {
            "jamTitle": data["jamTitle"],
            "jamDescription": data["jamDescription"],
            "jamStartTime": data["jamStartTime"],
            "jamEndTime": data["jamEndTime"],
            "locationdes": data["locationdes"],
            "public":data["public"],
            "friends":data["friends"],
            "user_created":data["user_created"],
            "created_at":data["created_at"],
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
    
@blp2.route("/getjams",methods = ['GET'])
class jamsGet(MethodView):
    @blp2.response(200)
    def get(self):
        jams = jamMod.query.all()
        return [{"jamTitle":jam.jamTitle,"jamDescription":jam.jamDescription,"jamStartTime":jam.jamStartTime,"jamEndTime":jam.jamEndTime,"locationdes":jam.locationdes,"public":jam.public,"friends":jam.friends,"user_created":jam.user_created,"created_at":jam.created_at}for jam in jams]