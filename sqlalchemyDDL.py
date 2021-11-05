#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov  5 17:25:04 2021

@author: William
"""

import pandas as pd 
from sqlalchemy import create_engine, Column, Integer, String, Float 
import sqlalchemy
from dotenv import load_dotenv
import os 
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

mysqluser = os.getenv('mysqluser')
mysqlpassword = os.getenv('mysqlpassword')

MYSQL_HOSTNAME = '20.62.193.224:3305'
MYSQL_USER = 'williamruan'
MYSQL_PASSWORD = 'williamruan2021'
MYSQL_DATABASE = 'ahi'

connection_string = f'mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOSTNAME}/{MYSQL_DATABASE}'
engine = create_engine(connection_string)
print (engine.table_names())

Session = sessionmaker(bind=engine) 
session = Session() 

Base = declarative_base()

class MedicalNotesDemo(Base): 
    __tablename__ = 'medicalNotesDemo'
    
    id = Column(Integer, primary_key= True) 
    name = Column(String(100))
    age = Column(Integer())
    med = Column(String(100))
    dosage = Column(Integer())
    cost = Column(Float())
    sex = Column(String(100))
    
Base.metadata.create_all(engine) 

tablesAHI = engine.table_names()

medicalNotesDemo = pd.read_sql('select * from ahi.medicalNotesDemo', engine)

patient1 = MedicalNotesDemo(name= 'Gustaw', age= 34, med= 'Naproxen', dosage= 30, cost= 5.68, sex= 'F')

session.add(patient1)
session.commit()
pd.read_sql('select * from ahi.medicalNotesDemo', engine)
