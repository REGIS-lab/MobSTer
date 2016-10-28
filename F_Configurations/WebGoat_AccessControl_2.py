# starting_URL = 'http://157.27.244.25:8080/WebGoat/attack?Screen=785&menu=200&stage=1'
starting_URL = 'http://157.27.244.25:8080/WebGoat/attack?Screen=785&menu=200&stage=3'

set_cookie = ''
set_cookie = {'JSESSIONID':'974AE35BC95CADBC036C2E3CBE543B1C'}
SSL_authentication = None

views = {}
views = {
	'Login':'ListId'
}

Data = {}
Data['John'] = { ### Warning for the attack we switch the name here!!!
	'employee_id':'105',
	'password':'tom'
}

Data['Tom'] = { 
	'employee_id':'105',
	'password':'tom'
}

Data['Jerry'] = { 
	'employee_id':'106',
	'password':'jerry'
}


actions = {}
actionsURL = {
	'NoAction'      	: '',
	'Login'         	: 'Login',
	'Logout'        	: 'Logout',
	'ViewProfile'   	: 'ViewProfile',
	'ListId'     		: 'ListStaff',
	'SearchStaff'   	: 'SearchStaff',
	'GetEdit'   		: 'EditProfile',
	'UpdateProfile' 	: 'UpdateProfile',
	'ListIdGuessed'		: 'ListStaff',
	'ViewProfileGuessed': 'ViewProfile',
	'DeleteProfile' 	: 'DeleteProfile'
	}

actionsLabel = {	
		'NoAction' : None,
		'Login' : None,
		'ListId': None,
		'ViewProfile' : None,
		'GetEdit' : None,
		'UpdateProfile' : None,
		'Logout' : None,
		'ListIdGuessed': None,
		'ViewProfileGuessed' : None,
		'DeleteProfile' : 'Guessed'
}
