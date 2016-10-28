starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=36&menu=1100' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'Name':{
		'account_name':''
		},
	'Log':{
		'info':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'Search'    : '&SUBMIT=Go!'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'Search' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'Search' : None
}

