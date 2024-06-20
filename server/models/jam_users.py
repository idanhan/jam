from db import db
from sqlalchemy.orm import DeclarativeBase,Mapped,mapped_column,relationship
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String,Text
from typing import List
from db import db

# class jamsUsersMod(db.Model):
#     __tablename__ = "jams_users"
#     id = Column(Integer,primary_key=True)
#     user_id = Column(Integer,ForeignKey("users.id"))
#     jam_id = Column(Integer,ForeignKey("jam_Mod.id"))
#     user = relationship("Usermod",backref='jam_associations')
#     jam = relationship("jamMod",backref='user_associations')

class jamsUsersMod(db.Model):
    __tablename__ = "jams_users"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    jam_id = Column(Integer, ForeignKey("jam_Mod.id"))

    users = relationship

    