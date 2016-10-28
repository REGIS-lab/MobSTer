starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=46&menu=1100' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'Credential':{
		'Username':'',
		'Password':'whoKnows'
		},
	'Info':{
		'info':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'Login'    : '&SUBMIT=Submit'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'Login' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'Login' : None
}

