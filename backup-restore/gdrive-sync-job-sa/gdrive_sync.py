import gdrive_download
import gdrive_upload
import gdrive_auth
import os

def gdrive_sync():
	if os.environ.get('SYNC_MODE') is None:
		print('No SYNC_MODE is defined. Please mention if the sync direction is upload or download.')
		return
	
	if os.environ.get('SYNC_MODE') == "AUTH_ONLY":
		gdrive_auth.testAuth()
		return
		
	if os.environ.get('SYNC_MODE') == "DOWNLOAD":
		gdrive_download.restore()
		return
	
	if os.environ.get('SYNC_MODE') == "UPLOAD":
		gdrive_upload.backup()
		return

gdrive_sync()	

