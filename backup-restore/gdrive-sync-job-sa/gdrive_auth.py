from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from pydrive.auth import ServiceAccountCredentials

def authenticate():
	gauth = GoogleAuth()
	scope = ['https://www.googleapis.com/auth/drive']
	gauth.credentials = ServiceAccountCredentials.from_json_keyfile_name('service_account.json', scope)
	drive = GoogleDrive(gauth) 
	return drive

def listFiles(drive):
	fileList = drive.ListFile({'q': "mimeType='application/vnd.google-apps.folder'and trashed=false"}).GetList()
	for file in fileList:
		print('Looking folder title: %s, ID: %s' % (file['title'], file['id']))

def testAuth():
	drive = authenticate()
	listFiles(drive)


