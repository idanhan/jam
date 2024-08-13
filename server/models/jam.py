import datetime
from db import db
from sqlalchemy.orm import DeclarativeBase,Mapped,mapped_column,relationship
from sqlalchemy import JSON, Boolean, Column, DateTime, ForeignKey, Integer, String,Text
from typing import List
from db import db
from models import Usermod

class jamMod(db.Model):
    __tablename__ = "jam_Mod"
    id = Column(Integer,primary_key=True)
    jamTitle = Column(String(100))
    jamDescription = Column(String(1000))
    jamStartTime = Column(String(100),nullable=False)
    jamEndTime = Column(String(100),nullable=False)
    locationdes = Column(String(300),nullable=False)
    public = Column(Boolean,nullable=False)
    friends = Column(JSON)
    user_created = Column(String(100))
    created_at = Column(String(100),default=datetime.datetime.now(datetime.timezone.utc).isoformat)
    users = relationship('Usermod',secondary='jams_users',back_populates="jams")
    
