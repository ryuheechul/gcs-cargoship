import cherrypy
import random
import string
import subprocess
import os
#import json

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

class HelloWorld(object):
	@cherrypy.expose
	def index(self):
		return "Hello world!"

	@cherrypy.expose
	def generate(self):
		return ''.join(random.sample(string.hexdigits, 8))

	@cherrypy.expose
	@cherrypy.tools.json_out()
	def upload(self, filename):
		print filename 

		returncode, out = run_cmd('pwd')
		print out

		cmd = 'gsutil cp '+ file_path + filename + ' '+ bucket_url
		
		print 'cmd: ' + cmd

		returncode, out  = run_cmd(cmd)

		if returncode != 0 :
			print "error!"
			print out
			return {"status": "error", "message" : out}

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


if __name__ == '__main__':
	cherrypy.quickstart(HelloWorld())
