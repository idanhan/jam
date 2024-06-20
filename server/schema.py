from marshmallow import Schema, fields
from marshmallow_enum import EnumField 
import enum

class friendRequest(enum.Enum):
    PENDING = "pending",
    ACCEPTED = "accepted",
    DECLINED  = "declined"

class plainUserSchema(Schema):
    id = fields.Int(dump_only=True)
    username = fields.Str(required=True)
    email = fields.Str(required=True)
    password = fields.Str(required=True)
    created_at = fields.Str(required = True)
    country = fields.Str(required=True)
    city = fields.Str(required=True)
    instrument = fields.List(fields.Str(),required=True)
    level = fields.Str(required=True)
    genre = fields.List(fields.Str(),required=True)


class PlainJamSchema(Schema):
    id = fields.Int(dump_only=True)
    jamTitle = fields.Str(required = False)
    jamDescription = fields.Str(required=False)
    jamStart = fields.Str(required=True)
    jamEnd = fields.Str(required=True)
    created_at = fields.Str(required = True)

class PlainFriendsSchema(Schema):
    userid = fields.Int(dump_only = True)
    friendid = fields.Int(dump_only = True)
    status = fields.Enum(enum=friendRequest,by_value=True)
    created_at = fields.Str(required = True)
    


class userSchema(plainUserSchema):
    jam = fields.List(fields.Nested(PlainJamSchema()))
class tasksSchema(PlainJamSchema):
    users = fields.List(fields.Nested(plainUserSchema()))
class FriendSchema(PlainFriendsSchema):
    user = fields.Nested(plainUserSchema)
    friend = fields.Nested(plainUserSchema)