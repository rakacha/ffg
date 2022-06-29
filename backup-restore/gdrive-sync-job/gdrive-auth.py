from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

def authenticate():
	gauth = GoogleAuth()
	gauth.CommandLineAuth()
	drive = GoogleDrive(gauth)
	return drive

def listFiles(drive):
	fileList = drive.ListFile({'q': "'root' in parents and mimeType='application/vnd.google-apps.folder'and trashed=false"}).GetList()
	for file in fileList:
		print('Looking folder title: %s, ID: %s' % (file['title'], file['id']))

def testAuth():
	drive = authenticate()
	listFiles(drive)
	
testAuth()