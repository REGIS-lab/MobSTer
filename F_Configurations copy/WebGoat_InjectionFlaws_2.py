starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=77&menu=1100' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'Station':{
		'station':''
		},
	'Info':{
		'info':''
		}
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'SelectStation'    : '&SUBMIT=Go!'
	}

actionsLabel = {	
	'NoAction' 	 : None,
	'SelectStation' : None
}


actionsProp = {	
	'NoAction'	 : None,
	'SelectStation' : None
}

