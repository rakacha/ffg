import gdrive_auth

def getSharedFolderId(drive, folderName):
	fileList = drive.ListFile({'q': "mimeType='application/vnd.google-apps.folder'and trashed=false"}).GetList()
	for file in fileList:
		print('Looking folder title: %s, ID: %s' % (file['title'], file['id']))
		if(file['title'] == folderName):
			fileID = file['id']
			print(fileID)
			break;
	print(fileID)
	return fileID;
	

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
		
	
	
def uploadFile(drive, folder_id, filePath, fileTitle):
	file1 = drive.CreateFile({'title': fileTitle, 'parents': [{'id': folder_id}]})
	# Read file and set it as a content of this instance.
	file1.SetContentFile(filePath)
	file1.Upload() # Upload the file.
	print('uploaded file title: %s, mimeType: %s' % (file1['title'], file1['mimeType']))

import array

def listFile(drive, folder_id):
	existing_bcups_list = list()
	file_list = drive.ListFile({'q': "\'" + folder_id + "\'" + " in parents and trashed=false"}).GetList()
	for file in file_list:
	   print('title: %s, id: %s' % (file['title'], file['id']))
	   existing_bcups_list.append(file['title'])
	
	return existing_bcups_list

import os

def backupAllFilesFromBackUpDir(drive, existing_bcups_list, folder_id):
	directory = os.environ.get('BACKUP_DIR')
	for filename in os.listdir(directory):
		filePath = os.path.join(directory, filename)
		# checking if it is a file
		if os.path.isfile(filePath):
			if (filename in existing_bcups_list):
				print ('File: %s already exists!' %filename)
				continue;
			uploadFile(drive, folder_id, filePath, filename)
	
def backup():
	if os.environ.get('BACKUP_DIR') is None:
		print('No BACKUP_DIR environment variable is set.')
		return
	
	if os.environ.get('GDRIVE_DIR') is None:
		print('No GDRIVE_DIR environment variable is set.')
		return
	
	shared_dir = 'SA'
	if os.environ.get('GDRIVE_SHARED_DIR') is None:
		shared_dir = 'SA'
	else:
		shared_dir=os.environ.get('GDRIVE_SHARED_DIR')
	
	print('Shared directory set as : %s' % (shared_dir))
	drive = gdrive_auth.authenticate()
	folder_id = findFolderIdByTitle(drive, os.environ.get('GDRIVE_DIR'), getSharedFolderId(drive, shared_dir))
	backupAllFilesFromBackUpDir(drive, listFile(drive, folder_id), folder_id)
	
