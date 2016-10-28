starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=74&menu=400' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'FileAddress':{
		'key':'',
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'SendLicenseKey'    : '&SUBMIT=Activate!'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'UpdateCart' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'SendLicenseKey' : None
}

