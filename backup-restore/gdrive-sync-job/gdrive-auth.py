from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

def authenticate():
	gauth = GoogleAuth()
	gauth.CommandLineAuth()
	drive = GoogleDrive(gauth)
	return drive


authenticate()