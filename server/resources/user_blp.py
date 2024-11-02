
import base64
from flask.views import MethodView
from flask_smorest import Blueprint, abort
from sqlalchemy.exc import SQLAlchemyError
from flask import json, request,Response
from sqlalchemy import DateTime, and_, func, insert, or_
from sqlalchemy.orm.attributes import flag_modified
import datetime
from flask import jsonify
from db import db
from schema import userSchema,tasksSchema,FriendSchema
from models import Usermod,jamMod,FriendsMod
import os
import boto3
from werkzeug.utils import secure_filename
from models.friends import friendRequest
from geoalchemy2.functions import ST_Distance, ST_Point
from sqlalchemy import asc

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
            "location":data["location"], 
        }
        user = Usermod(**item_data)
        db.session.add(user)

        try:
            db.session.commit()
            print("commited")
        except Exception as e:
            print(f'an error occured {e} t')
            db.session.rollback()
            abort(500,message = f"An error has occured1 {e}")
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

@blp.route("/user/friendimages/<string:usernames>",methods = ['GET'])
class userImageGet(MethodView):
    @blp.response(200)
    def get(self,usernames):
        namelist = usernames.split(",")
        images = {}
        for username in namelist:
            imagename = f'image{username}'
            Object_Key = imagename 
            try:
                response = s3_client.get_object(Bucket = S3_BUCKET,Key = Object_Key)
                image_content = response['Body'].read()
                encoded_image = base64.b64encode(image_content).decode('utf-8')
                images[username] = encoded_image
                
            except s3_client.exceptions.NoSuchKey:
                images[username] = None
            except Exception as e:
                images[username] = None
        return jsonify(images)
        


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
    
@blp.route("/friends/searchandpending/<string:usernames>",methods = ["GET"])
class friendsearchpending(MethodView):
    @blp.response(200,userSchema)
    def get(self,usernames):
        username1,friendname = usernames.split(",")

        user = Usermod.query.filter_by(username = username1).first()
        friend = Usermod.query.filter_by(username = friendname).first()
        if (not user) or (not friend):
           abort(404, message = "User not found in database")
        if(username1 == friendname):
            abort(404,message = "")
        friendreturn = {"username":friend.username,"email":friend.email,"password":friend.password,"created_at":friend.created_at,"country":friend.country,"city":friend.city,"instrument":friend.instrument,"genre":friend.genre,"level":friend.level,"urls":friend.urls}
        
        requesters = FriendsMod.query.filter(or_(and_(FriendsMod.friend_a_id == user.id,FriendsMod.friend_b_id == friend.id),and_(FriendsMod.friend_a_id == friend.id,FriendsMod.friend_b_id == user.id))).first()
        if not requesters:
            return jsonify({"friend":friendreturn,"status":"no"})
        return jsonify({"friend":friendreturn,"status":requesters.status.name})
        
@blp.route("/friends/getallfriends/<string:username1>",methods = ["GET"])
class getListFriends(MethodView):
    @blp.response(200,userSchema)
    def get(self,username1):
        currentuser = Usermod.query.filter_by(username = username1).first()
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
    
@blp.route("/friends/userrRequests/<string:name>",methods = ["GET"])
class get(MethodView):
    @blp.response(200,userSchema(many=True))
    def get(self,name):
        user = Usermod.query.filter_by(username = name).first()
        if not user:
            return abort(404,"user not found")
        user_id = user.id
        pending_requests = FriendsMod.query.filter_by(friend_a_id = user_id, status = "pending").all()
        requesters = [Usermod.query.get(request.friend_b_id) for request in pending_requests]
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

# @blp.route("/pendingfriends/<string:useremail>",methods = ["GET"])
# class getpendingfriends(MethodView):
#     @blp.response(200)
#     def get(self,useremail):
#         user = Usermod.query.filter_by(email = useremail).first()
#         if not user:
#             return abort(404,"user not found")
#         user_id = user.id
#         pending_requests = FriendsMod.query.filter(
#             and_(or_(FriendsMod.friend_a_id == user_id,FriendsMod.friend_b_id == user_id),
#             (FriendsMod.status == friendRequest.PENDING))
#         ).all()
#         friend_ids = set()
#         for request in pending_requests:
#             if request.friend_a_id != user_id:
#                 friend_ids.add(request.friend_a_id)
#             if request.friend_b_id != user_id:
#                 friend_ids.add(request.friend_b_id)
#         friends = Usermod.query.filter(Usermod.id.in_(friend_ids)).all()
#         friend_list = [{"username":friend.username,"email":friend.email,"password":friend.password,"created_at":friend.created_at,"country":friend.country,"city":friend.city,"instrument":friend.instrument,"genre":friend.genre,"level":friend.level,"urls":friend.urls} for friend in friends]
#         return friend_list

    
@blp.route("/friends/frienddelete/<string:userandfriendemail>",methods = ["DELETE"])
class deletefriends(MethodView):
    @blp.response(200)
    def delete(self,userandfriendemail):
        userandfriendlist = userandfriendemail.split(",")
        useremail = userandfriendlist[0]
        friendemail  = userandfriendlist[1]
        userclass = Usermod.query.filter_by(email = useremail).first()
        friendclass = Usermod.query.filter_by(email = friendemail).first()
        if not userclass:
            return jsonify({"message":"no user was found"}),400
        if not friendclass:
            return jsonify({"message":"no friend was found"}),400
        accepted_requests = FriendsMod.query.filter(
           and_(or_(and_(FriendsMod.friend_a_id == userclass.id,FriendsMod.friend_b_id == friendclass.id),and_(FriendsMod.friend_b_id == userclass.id,FriendsMod.friend_a_id == friendclass.id)),
            (FriendsMod.status == friendRequest.ACCEPTED))
        ).delete(synchronize_session=False)
        if not accepted_requests:
            return jsonify({"message":"not friends"}),400
        db.session.commit()
        return jsonify({"message":"deleted successfully"}),200
        

@blp.route("/user/urlList/<string:name>",methods = ["PUT"])
class Posturllist(MethodView):
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

        new_dict = {url:description}
        new_dict.update(user.urls)
        user.urls = new_dict
        flag_modified(user, "urls")
        db.session.commit()
        return jsonify({"message":"url and urldescription added successfully"}),200

@blp.route("/user/delete/<string:emailusername>", methods=["DELETE"])    
class delete(MethodView):
    @blp.response(200)
    def delete(self, emailusername):
        # Split the email and username
        emailuser = emailusername.split(",")
        if len(emailuser) != 2:
            return jsonify({"message": "Invalid input format"}), 400
        email, username = emailuser

        # Fetch the user
        user = Usermod.query.filter_by(email=email).first()
        if not user:
            return jsonify({"message": "User was not found"}), 404

        # Try deleting the user's image from S3
        imagename = f'image{username}'
        try:
            s3_client.delete_object(Bucket=S3_BUCKET, Key=imagename)
        except Exception as e:
            return jsonify({"error": f"Failed to delete image from S3: {str(e)}"}), 500

        # Remove user from the friends list in jamMod instances
        jams_with_user = jamMod.query.filter(
            func.json_contains(jamMod.friends, f'"{username}"', '$')==1
        ).all()

        for jam in jams_with_user:
            # Ensure that friends is a list before trying to remove the username
            if isinstance(jam.friends, list):
                if username in jam.friends:
                    jam.friends.remove(username)
                    flag_modified(jam, "friends")
                    db.session.add(jam)  # Mark jam as updated
            else:
                # If friends field is not a list, log or handle the inconsistency
                return jsonify({"error": f"Friends field in jam {jam.jamTitle} is not a list."}), 500

        # Delete the user's jamMod entries
        jamMod.query.filter_by(user_created=email).delete(synchronize_session=False)

        # Delete the user
        db.session.delete(user)
        db.session.commit()

        return jsonify({"message": "User deleted successfully"}), 200
    
@blp.route("/user/checkifnameisindb/<string:name>",methods = ['GET'])
class get(MethodView):
    @blp.response(200)
    def get(self,name):
        user = Usermod.query.filter_by(username = name).first()
        if not user:
            return jsonify({"message":"no user found"}),400
        return jsonify({"message":"userfound"}),200

@blp.route("/user/removeyoutube",methods = ["DELETE"])
class RemoveYouTubeURL(MethodView):
    @blp.response(204)
    def delete(self):
        # try:
        #     usernamein, url = nameurl.split(",")
        # except ValueError:
        #     return jsonify({"error": "Invalid input format. Expected 'username,url'"}), 400
        data = request.get_json()
        usernamein = data["username"]
        url = data["url"]
        user = Usermod.query.filter_by(username = usernamein).first()
        if not user:
            return jsonify({"error":"user not found"}),400
        if url not in user.urls:
            return jsonify({"error": "URL not found in user's list"}), 404
        del user.urls[url]
        flag_modified(user,"urls")
        db.session.add(user)

        db.session.commit()

        return '', 204

@blp.route("/user/gettennearestusers/<string:namelatlong>", methods=['GET'])
class GetTenNearest(MethodView):
    @blp.response(200)
    def get(self, namelatlong):
        try:
            # Split the name, latitude, and longitude
            name, currlat, currlong = namelatlong.split(",")
            currlat = float(currlat)
            currlong = float(currlong)
            
            # Create the current location point with SRID 4326
            current_location = func.ST_Transform(
                func.ST_MakePoint(currlong, currlat), 4326
            )

            user = Usermod.query.filter_by(username = name).first()
            if not user:
                return jsonify({"error":"user was not found"}),404
            
            # Query the 10 nearest users ordered by distance
            nearest_users = (
            Usermod.query
            .with_entities(Usermod.username, func.ST_Distance(Usermod.location, current_location).label('distance'))
            .filter(Usermod.location != None)
            .filter(
                ~Usermod.id.in_(
                db.session.query(FriendsMod.friend_b_id)
                .filter(FriendsMod.friend_a_id == user.id)
                .union(
                    db.session.query(FriendsMod.friend_a_id)
                    .filter(FriendsMod.friend_b_id == user.id)
                )
                )
            )
            .order_by('distance')
            .limit(10)
            .all()
            )
            
            return jsonify([{"username": user.username, "distance": distance} for user, distance in nearest_users])
        except ValueError:
            abort(400, message="Invalid format for latitude/longitude.")


    


        
        
        

        

        
    



    

        





        



        






