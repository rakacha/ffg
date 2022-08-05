import gdrive_auth

def findFolderIdByTitle(drive, folderName, parent_dir):
	fileID = None
	fileList = drive.ListFile({'q': "'%s' in parents and mimeType='application/vnd.google-apps.folder'and trashed=false" %parent_dir}).GetList()
	for file in fileList:
		print('Looking folder title: %s, ID: %s' % (file['title'], file['id']))
		if(file['title'] == folderName):
			fileID = file['id']
			print(fileID)
			break;
		# Get the folder ID that you want
		fileID = findFolderIdByTitle(drive, folderName, file['id'])
	print(fileID)
	return fileID;
		
import os	
import shutil

def restoreFiles(drive, folder_id, file_prefix):
	site_config_backup = file_prefix + "-site_config_backup.json"
	private_file_backup = file_prefix + "-private-files.tgz"
	public_file_backup = file_prefix + "-files.tgz"
	database_backup=file_prefix + "-database.sql.gz"
	
	shutil.rmtree('temp', ignore_errors=True)
	os.mkdir("temp")
	file_list = drive.ListFile({'q': "\'" + folder_id + "\'" + " in parents and trashed=false"}).GetList()
	for file in file_list:
		if(file['title'] == site_config_backup):
			print('Downloading title: %s, id: %s' % (file['title'], file['id']))
			file.GetContentFile(file['title'])
			shutil.move("./"+site_config_backup, "./temp/"+site_config_backup)
		if(file['title'] == private_file_backup):
			print('Downloading title: %s, id: %s' % (file['title'], file['id']))
			file.GetContentFile(file['title'])
			shutil.move("./"+private_file_backup, "./temp/"+private_file_backup)
		if(file['title'] == public_file_backup):
			print('Downloading title: %s, id: %s' % (file['title'], file['id']))
			file.GetContentFile(file['title'])
			shutil.move("./"+public_file_backup, "./temp/"+public_file_backup)
		if(file['title'] == database_backup):
			print('Downloading title: %s, id: %s' % (file['title'], file['id']))
			file.GetContentFile(file['title'])
			shutil.move("./"+database_backup, "./temp/"+database_backup)

	
def restore():
	if os.environ.get('RESTORE_FILE_PREFIX') is None:
		print('No RESTORE_FILE_PREFIX environment variable is set.')
		return
	
	if os.environ.get('RESTORE_PATH') is None:
		print('No RESTORE_PATH environment variable is set.')
		return
		
	file_prefix = os.environ.get('RESTORE_FILE_PREFIX')
	drive = gdrive_auth.authenticate()
	folder_id = findFolderIdByTitle(drive, os.environ.get('RESTORE_PATH'), 'root')
	restoreFiles(drive, folder_id, file_prefix)
	
