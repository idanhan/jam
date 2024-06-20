import datetime
from db import db
from sqlalchemy.orm import DeclarativeBase,Mapped,mapped_column,relationship
from sqlalchemy import Column, DateTime, ForeignKey, ForeignKeyConstraint, Integer, PrimaryKeyConstraint, String,Text,JSON,Enum
from typing import List
from models import jam_users
import enum

class friendRequest(enum.Enum):
    PENDING = "pending",
    ACCEPTED = "accepted",
    DECLINED  = "declined"


class FriendsMod(db.Model):
    __tablename__ = "friends"

    friend_a_id = Column(Integer,ForeignKey("users.id"),primary_key=True)
    friend_b_id = Column(Integer,ForeignKey("users.id"),primary_key=True)
    status = Column(Enum(friendRequest),name='Status_enum',default=friendRequest.PENDING,nullable=False)
    created_at = Column(DateTime, default=datetime.datetime.now)

    __table_args__ = (
        PrimaryKeyConstraint('friend_a_id', 'friend_b_id'),
        ForeignKeyConstraint([friend_a_id,friend_b_id],["users.id","users.id"])
    )
