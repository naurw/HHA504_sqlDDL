#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 15 18:49:17 2021

@author: William
"""

import pandas as pd 
import sqlalchemy
from sqlalchemy import create_engine


fakeDataset = pd.DataFrame({'colors' : ['blue', 'purple', 'pink']})


MYSQL_HOSTNAME = 'inserthere'
MYSQL_USER = 'inserthere'
MYSQL_PASSWORD = 'inserthere'
MYSQL_DATABASE = 'ahi'

connection_string = f'mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOSTNAME}/{MYSQL_DATABASE}'
engine = create_engine(connection_string)

TABLENAME = MYSQL_USER + 'fakeTableAssignment1'

fakeDataset.to_sql(TABLENAME, con=engine)
