import datetime
from db import db
from sqlalchemy.orm import DeclarativeBase,Mapped,mapped_column,relationship
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String,Text
from typing import List
from db import db
from models import Usermod

class jamMod(db.Model):
    __tablename__ = "jam_Mod"
    id = Column(Integer,primary_key=True)
    jamTitle = Column(String(300))
    jamDescription = Column(String(1000))
    jamStartTime = Column(String(300),nullable=False)
    jamEndTime = Column(String(300),nullable=False)
    created_at = Column(String(100),default=datetime.datetime.now(datetime.timezone.utc).isoformat)
    users = relationship('Usermod',secondary='jams_users',back_populates="jams")
    
