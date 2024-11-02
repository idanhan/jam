from flask.views import MethodView
from sqlalchemy.orm.attributes import flag_modified
from flask_smorest import Blueprint, abort
from sqlalchemy.exc import SQLAlchemyError
from flask import request
from sqlalchemy import DateTime, and_, func
import datetime
from flask import jsonify

from db import db
from schema import userSchema,tasksSchema
from models.user import Usermod
from models.jam import jamMod
# from models.jam_users import jamsUsersMod


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

@blp2.route("/getjamsbyusername/<string:username>",methods = ['GET'])
class getjamsbyusername(MethodView):
    @blp2.response(200)
    def get(self,username):
        relatedjams = jamMod.query.filter(
            func.json_contains(jamMod.friends, f'"{username}"', '$') | 
            (jamMod.public == True)
        ).all()
        jams_list = [{"jamTitle":jam.jamTitle,"jamDescription":jam.jamDescription,"jamStartTime":jam.jamStartTime,"jamEndTime":jam.jamEndTime,"locationdes":jam.locationdes,"public":jam.public,"friends":jam.friends,"user_created":jam.user_created,"created_at":jam.created_at}for jam in relatedjams]
        return jams_list

@blp2.route("/getonlypublicjams",methods = ['GET'])
class get(MethodView):
    @blp2.response(200)
    def get(self):
        publicjams = jamMod.query.filter_by(public = True).all()
        if not publicjams:
            return []
        public_jams_list = []
        for jam in publicjams:
            public_jams_list.append({
                "id": jam.id,
                "jamTitle": jam.jamTitle,
                "jamDescription": jam.jamDescription,
                "jamStartTime": jam.jamStartTime,
                "jamEndTime": jam.jamEndTime,
                "locationdes": jam.locationdes,
                "public": jam.public,
                "friends": jam.friends,
                "user_created": jam.user_created,
                "created_at": jam.created_at
            })

        return jsonify(public_jams_list), 200

@blp2.route("/changejams",methods = ['PUT'])
class jamput(MethodView):
    @blp2.response(200)
    def put(self):
        data = request.get_json()
        jam = jamMod.query.filter(and_(
            jamMod.created_at == data["created_at"], 
            jamMod.user_created == data["user_created"]
        )).update({"jamTitle":data["jamTitle"],"jamDescription":data["jamDescription"],"jamStartTime":data["jamStartTime"],"jamEndTime":data["jamEndTime"],"locationdes":data["locationdes"],"public":data["public"],"friends":data["friends"],"user_created":data["user_created"]},synchronize_session='fetch')
        # jam = jamMod.query.filter(
        #     jamMod.created_at == datetime.strptime(data["created_at"],"%Y-%m-%d %H:%M:%S.%f")
        # ).first()
        if not jam:
            return jsonify({"message": "Record not found"}), 404
        
        # jam.update({"jamTitle":data["jamTitle"],"jamDescription":data["jamDescription"],"jamStartTime":data["jamStartTime"],"jamEndTime":data["jamEndTime"],"locationdes":data["locationdes"],"public":data["public"],"friends":data["friends"],"user_created":data["user_created"]})
        # jam.jamTitle = data["jamTitle"]
        # jam.jamDescription = data["jamDescription"]
        # jam.jamStartTime = data["jamStartTime"]
        # jam.jamEndTime = data["jamEndTime"]
        # jam.locationdes = data["locationdes"]
        # jam.public = data["public"]
        # jam.friends = data["friends"]
        # jam.user_created = data["user_created"]
        db.session.commit()
        return jsonify({"message":"returned succesfuly"}),200

@blp2.route("/deletejam",methods = ['DELETE'])
class jamdelete(MethodView):
    @blp2.response(200)
    
    def delete(self):
        data = request.get_json()
        jam = jamMod.query.filter(and_(
            jamMod.created_at == data["created_at"], 
            jamMod.user_created == data["user_created"]
        ))
        if not jam:
            return jsonify({"error":"jam wasnt found"}),404
        jam.delete()
        db.session.commit()
        return jsonify({"message":"succesfuly deleted"})

@blp2.route("/deleteuserfromjam/<string:usernameusercreatedcreatedat>",methods = ['DELETE'])
class userdelete(MethodView):
    @blp2.response(200)

    def delete(self,usernameusercreatedcreatedat):
        username, usercreated, createdat = usernameusercreatedcreatedat.split(",")
        jam = jamMod.query.filter(
            and_(
                jamMod.user_created == usercreated,
                jamMod.created_at == createdat,
            )
        ).first()

        if not jam:
            return jsonify({"message":"jam was not found"}),400
        if username in jam.friends:
            jam.friends.remove(username)
            flag_modified(jam, "friends")
            db.session.add(jam)
        else:
            return jsonify({"message":"user not in frieds list"})
        db.session.commit()
        return jsonify({"message": "User deleted successfully"}), 200

