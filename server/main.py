from app import create_app
from flask import Flask
import os

name = 'mysql+pymysql://'+os.getenv("regionurl")
app = create_app()

if __name__ == '__main__':
    app.run(debug=True,host = '0.0.0.0')