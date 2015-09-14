import cherrypy
import random
import string
import subprocess
import os

file_path = '/home/gcs-cargoship/files/'
bucket_name = os.environ['GCS_BUCKET_NAME']
bucket_url = 'gs://' + bucket_name
secret_path = os.environ['GC_SECRET_PATH']
secret_password = os.environ['GC_SECRET_PASSWORD']

def run_cmd(cmd):
	proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	out, err = proc.communicate()

	proc.wait()
	returncode = proc.returncode

	return returncode, out + err

cherrypy.server.socket_host = '0.0.0.0'
cherrypy.server.socket_port = int(os.environ['CHERRYPY_PORT'])

def delete_localfile(filename):
	cmd = 'rm -f ' + file_path + '/' + filename
	returncode, out = run_cmd(cmd)

	if returncode != 0:
		print "error while delete local file ["+file_path+"/"+filename+"]"
		print out

def delete_object(filename):
	# delete object in bucket
	cmd = 'gsutil rm ' + bucket_url +'/'+ filename
	returncode, out = run_cmd(cmd)

	if returncode == 0:
		# delete local file too if it exist in local path
		delete_localfile(filename)

		return {"status": "success"}

	else:
		print "error!"
		print out
		return {"status": "error", "message": out}


def sign_object(filename):
	cmd = 'gsutil signurl -d 1m -p ' + secret_password + ' ' + secret_path +' ' + bucket_url +'/'+ filename

	returncode, out = run_cmd(cmd)

	if returncode != 0 :
		print "error!"
		print out
		return {"status": "error", "message" : out}

	else:
		print out
		chunk = out.split('\t')
		signed_url = chunk[-1].strip()

		return {"status": "success", "signed_url": signed_url}
		# "message": out, "

def upload_file(filename):
	cmd = 'gsutil cp '+ file_path + filename + ' '+ bucket_url

	returncode, out  = run_cmd(cmd)

	if returncode == 0:
		delete_localfile(filename)

	return returncode, out


class Cargoship(object):
	@cherrypy.expose
	def index(self):
		return "Hello world!"

	@cherrypy.expose
	def generate(self):
		return ''.join(random.sample(string.hexdigits, 8))

	@cherrypy.expose
	@cherrypy.tools.json_out()
	def upload(self, filename):
		returncode, out = upload_file(filename)
		if returncode != 0 :
			print "error!"
			print out
			return {"status": "error", "message" : out}

		result = sign_object(filename)
		return result

	@cherrypy.expose
	@cherrypy.tools.json_out()
	def get_url(self, filename):
		result = sign_object(filename)
		return result

	@cherrypy.expose
	@cherrypy.tools.json_out()
	def delete(self, filename):
		result = delete_object(filename)
		return result


if __name__ == '__main__':
	cherrypy.quickstart(Cargoship())
