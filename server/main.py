from app import create_app
from flask import Flask

name = 'mysql+pymysql://admin:Ihporcu13684@road-db.cfumyciqcaqf.eu-north-1.rds.amazonaws.com:3306/roadsdb'
# 'mysql+pymysql://admin:Ihporcu13684@road-db.cfumyciqcaqf.eu-north-1.rds.amazonaws.com:3306/roadsdb'
# 'mysql+pymysql://admin:Ihporcu13684@road-db.cfumyciqcaqf.eu-north-1.rds.amazonaws.com/roadsdb'
app = create_app()

if __name__ == '__main__':
    app.run(debug=True,host = '0.0.0.0')