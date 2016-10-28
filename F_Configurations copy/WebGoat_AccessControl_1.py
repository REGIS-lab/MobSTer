starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=57&menu=200' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'FileAddress':{
		'File':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'FileAccess'    : '&SUBMIT=View+File'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'FileAccess' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'FileAccess' : None
}

