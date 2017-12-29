from flask import Flask
from flask_restful import Api
from handlerClass import HelloWorld


app = Flask(__name__)

app.config['DEBUG'] = True
api = Api(app)
api.add_resource(HelloWorld, '/techgig/api/hello')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

