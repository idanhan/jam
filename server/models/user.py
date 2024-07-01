import datetime
from db import db
from sqlalchemy.orm import DeclarativeBase,Mapped,mapped_column,relationship
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String,Text,JSON
from typing import List
from db import db
from models import jam_users
from models import FriendsMod


class Usermod(db.Model):
    __tablename__ = "users"

    id = Column(Integer,primary_key=True)
    username = Column(String(50),unique=True,nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password = Column(String(100),nullable=False)
    created_at = Column(String(100),default=datetime.datetime.now(datetime.timezone.utc).isoformat)
    country = Column(String(50),nullable=False)
    city = Column(String(50),nullable=False)
    instrument = Column(JSON,nullable=False)
    level = Column(String(30),nullable=False)
    genre = Column(JSON,nullable=False)
    urls = Column(JSON)
    jams = relationship('jamMod',secondary='jams_users',back_populates= 'users',lazy="dynamic")
    friends = relationship('Usermod',secondary='friends',primaryjoin=id==FriendsMod.friend_a_id,secondaryjoin=id==FriendsMod.friend_b_id,lazy="dynamic",backref="friend_of")
    # friends = relationship('Usermod',secondary='friends',lazy="dynamic",backref="friend_of")
    def __repr__(self) -> str:
        return f"<Username={self.username}>"#this is for printing the username of the userclass 
    
   

# class comment(db.Model):
#     __tablename__ = "comments"

#     # id:Mapped[int] = mapped_column(primary_key=True)
#     # user_id:Mapped[int] = mapped_column(ForeignKey('users.id'),nullable=False)
#     # text:Mapped[str] = mapped_column(Text,nullable=True)
#     # user:Mapped["Usermod"] = relationship(back_populates='comments')
#     id = Column(Integer,primary_key=True)
#     Text = Column(String(50),unique=True,nullable=False)
#     user_id= Column(Integer, unique=True, nullable=False)
#     user = db.relationship("Usermod",back_populates = "store",lazy = "dynamic")

#     def __repr__(self) -> str:
#         return f"<comment text={self.text} Username={self.username}>"
