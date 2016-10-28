starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=76&menu=1100' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'Credential':{
		'username':'',
		'password':''
		},
	'Log':{
		'info':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'Login'    : '&SUBMIT=Login'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'Login' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'Login' : None
}

