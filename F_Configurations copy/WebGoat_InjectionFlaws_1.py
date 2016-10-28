starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=11&menu=1100' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'FileAddress':{
		'HelpFile':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'FileAccess'    : '&SUBMIT=View'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'FileAccess' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'FileAccess' : None
}

