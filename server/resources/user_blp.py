
from flask.views import MethodView
from flask_smorest import Blueprint, abort
from sqlalchemy.exc import SQLAlchemyError
from flask import request,Response
from sqlalchemy import DateTime, and_, insert, or_
from sqlalchemy.orm.attributes import flag_modified
import datetime
from flask import jsonify
from db import db
from schema import userSchema,tasksSchema,FriendSchema
from models import Usermod,jamsUsersMod,jamMod,FriendsMod
import os
import boto3
from werkzeug.utils import secure_filename
from models.friends import friendRequest

S3_BUCKET = os.getenv('BUCKET_NAME')
S3_REGION = os.getenv('S3_REGION')
S3_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY_ID')
S3_SECRET_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')

s3_client = boto3.client(
    's3',
    aws_access_key_id=S3_ACCESS_KEY,
    aws_secret_access_key=S3_SECRET_KEY,
    region_name=S3_REGION,
)

blp = Blueprint("users",__name__,description="operation on user")


    
@blp.route("/user",methods =['POST'])
class user(MethodView):
    @blp.response(200,userSchema)
    def post(self):
        data = request.get_json()
        if(data['created_at'] is None):
            abort(400,message="Missing 'created_at' field")
        item_data ={
            "username":data['username'],
            "email":data['email'],
            "password":data['password'],
            "created_at":data['created_at'],
            "country":data["country"],
            "city":data["city"],
            "instrument":data['instrument'],
            "level":data["level"],
            "genre":data["genre"],
            "urls":{},
        }
        user = Usermod(**item_data)
        db.session.add(user)

        try:
            db.session.commit()
            print("commited")
        except Exception as e:
            print(f'an error occured {e} t')
            db.session.rollback()
            abort(500,message = "An error has occured1")
        return user
    

@blp.route("/user/<string:username>",methods = ['GET'])
class userRetrieve(MethodView):
    @blp.response(200,userSchema)
    def get(self,username):
        # user = Usermod.query.get_or_404(username)
        user = Usermod.query.filter(Usermod.username == username).first()
        return user

@blp.route("/user/image/<string:username>",methods = ['POST'])
class userImagePost(MethodView):
    @blp.response(200,userSchema)
    def post(self,username):
        imagename = f'image{username}' 
        if imagename not in request.files:
            return jsonify({"error":"No image file found in request"}), 400
        
        file = request.files[imagename]

        if file.filename == '':
            return jsonify({"error":"No file was selected"}), 400
        
        filename = secure_filename(imagename)
        try:
            s3_client.upload_fileobj(
                file,
                S3_BUCKET,
                filename,
                ExtraArgs={
                    "ContentType": file.content_type
                }
            )
            return jsonify({"message": "File uploaded successfully"}), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 500
        
@blp.route("/user/image/<string:username>",methods = ['GET'])
class userImageGet(MethodView):
    @blp.response(200)
    def get(self,username):
        imagename = f'image{username}'
        Object_Key = imagename
        try:
            response = s3_client.get_object(Bucket = S3_BUCKET,Key = Object_Key)
            image_content = response['Body'].read()
            return Response(image_content, mimetype='image/jpeg')
        
        except s3_client.exceptions.NoSuchKey:
            return jsonify({"error": "Image not found"}), 404
        except Exception as e:
            return jsonify({"error": str(e)}), 500

@blp.route("/friends/sendrequest/<string:name>",methods = ['POST'])
class friendRequestSend(MethodView):
    @blp.response(200,FriendSchema)
    def post(self,name):
        data = request.get_json()
        friendname1 = data['friendname']

        user = Usermod.query.filter_by(username = name).first()
        friend = Usermod.query.filter_by(username = friendname1).first()

        existing_friendship = FriendsMod.query.filter(
            ((FriendsMod.friend_a_id == user.id) & (FriendsMod.friend_b_id == friend.id)) |
            ((FriendsMod.friend_a_id == friend.id) & (FriendsMod.friend_b_id == user.id))
        ).first()

        if existing_friendship:
            return jsonify({"error": "friendship already exists"}), 400

        if not user or not friend:
            return jsonify({"error":"user or friend not found"})
        if friend in user.friends:
            return jsonify({"error":"friend alredy in friends list"})

        # newfriendship = FriendsMod(friend_a_id = user.id,friend_b_id = friend.id)

        # db.session.add(newfriendship)
        user.friends.append(friend)
        db.session.commit()
        return jsonify({"message":"Friends added succesfully"})
    
@blp.route("/friends/delete/<string:name>",methods = ["DELETE"])
class friendsDelete(MethodView):
    @blp.response(204,userSchema)
    def delete(self,name):
        data = request.get_json()
        friendname = data['friendname']

        user = Usermod.query.filter_by(username = name).first()
        friend = Usermod.query.filter_by(username = friendname).first()
        if not user or not friend:
            return jsonify({"error":"user or friend not found"})
        
        user.friend_of.remove(friend)
        db.session.commit()
        return jsonify({"message":"friend removed succesfully"})
    

@blp.route("/friends/put/<string:name>",methods = ["PUT"])
class updateRequestsFriends(MethodView):
    @blp.response(200,userSchema)
    def put(self,name):
        data = request.get_json()
        friendname = data['friendname']
        user = Usermod.query.filter_by(username = name).first()
        friend = Usermod.query.filter_by(username = friendname).first()
        if not user or not friend:
            return jsonify({"error":"user or friend not found"})
        res = FriendsMod.query.filter(and_(
                FriendsMod.friend_b_id == user.id,
                FriendsMod.friend_a_id == friend.id
            )).update({"status": friendRequest.ACCEPTED},synchronize_session='fetch')
        # friendship = FriendsMod(friend_a_id = user.id,friend_b_id = friend.id,status = friendRequest.ACCEPTED)
        # .update({"status": friendRequest.ACCEPTED},synchronize_session='fetch')
        # db.session.add(friendship)
        db.session.commit()
        return jsonify({"message":""})

    



@blp.route("/friends/search/<string:usernameIn>",methods = ["GET"])
class friendsearch(MethodView):
    @blp.response(200,userSchema)
    def get(self,usernameIn):
        user = Usermod.query.filter_by(username = usernameIn).first()#demand that all username will be unique
        if not user:
           abort(404, message = "User not found in database")
        return user

@blp.route("/friends/getallfriends/<string:username1>",methods = ["GET"])
class getListFriends(MethodView):
    @blp.response(200,userSchema)
    def get(self,username1):
        currentuser = Usermod.query.filter_by( username = username1).first()
        if not currentuser:
            abort(404,message = "User not found in database")
        friends = currentuser.friend_of()
        return friends

@blp.route("/friends/friendsRequsets/<string:name>",methods = ["GET"])
class getListFriendsRequests(MethodView):
    @blp.response(200,userSchema(many=True))
    def get(self,name):
        user = Usermod.query.filter_by(username = name).first()
        if not user:
            return abort(404,"user not found")
        user_id = user.id
        pending_requests = FriendsMod.query.filter_by(friend_b_id = user_id, status = "pending").all()
        requesters = [Usermod.query.get(request.friend_a_id) for request in pending_requests]
        return requesters
            
@blp.route("/friends/friendsList/<string:name>",methods = ["GET"])
class getListFriends(MethodView):
    @blp.response(200)
    def get(self,name):
        user = Usermod.query.filter_by(username = name).first()
        if not user: 
            return abort(404,"user not found")
        user_id = user.id
        accepted_requests = FriendsMod.query.filter(
           and_(or_(FriendsMod.friend_a_id == user_id,FriendsMod.friend_b_id == user_id),
            (FriendsMod.status == friendRequest.ACCEPTED))
        ).all()
        friend_ids = set()
        for request in accepted_requests:
            if request.friend_a_id != user_id:
                friend_ids.add(request.friend_a_id)
            if request.friend_b_id != user_id:
                friend_ids.add(request.friend_b_id)
        friends = Usermod.query.filter(Usermod.id.in_(friend_ids)).all()
        friend_list = [{"username":friend.username,"email":friend.email,"password":friend.password,"created_at":friend.created_at,"country":friend.country,"city":friend.city,"instrument":friend.instrument,"genre":friend.genre,"level":friend.level,"urls":friend.urls} for friend in friends]
        return friend_list

@blp.route("/user/urlList/<string:name>",methods = ["PUT"])
class posturllist(MethodView):
    @blp.response(200,userSchema)
    def put(self,name):
        data = request.get_json()
        url = data["url"]
        description = data["description"]
        if not url or not description:
            return jsonify({"error": "URL and description are required"}), 400
        user = Usermod.query.filter_by(username = name).first()
        if not user:
            return jsonify({"error":"user or friend not found"}),404
        if not user.urls:
            user.urls = {}

        user.urls[description] = url
        flag_modified(user, "urls") 
        db.session.commit()
        return jsonify({"message":"url and urldescription added successfully"}),200
        
    



    

        





        



        






