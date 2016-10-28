starting_URL = 'http://157.27.244.25:8080/WebGoat/attack?Screen=666&menu=1200&stage=3'
#starting_URL = 'http://157.27.244.25:8080/WebGoat/attack?Screen=666&menu=1200&stage=1'
set_cookie = ''
set_cookie = {'JSESSIONID':'974AE35BC95CADBC036C2E3CBE543B1C'}
SSL_authentication = None

views = {}
views = {
	'Login':'ListId'
}

Data = {}

Data['Neville'] = {
	'employee_id':'112',
	'password':'neville',
	'search_name' :'Neville'
}



Data['Larry']={
	'employee_id':'101',
	'password':'larry',
	'search_name' :'Larry'
}

actions = {}
actionsURL = {
	'NoAction'      : '',
	'Login'         : 'Login',
	'Logout'        : 'Logout',
	'ViewProfile'   : 'ViewProfile',
	'ListId'     	: 'ListStaff',
	'SearchStaff'   : 'SearchStaff',
	'GetEdit'   	: 'EditProfile',
	'UpdateProfile' : 'UpdateProfile',
	'GetSearch'		: 'SearchStaff',
	'Search' 		: 'FindProfilee'
	
	}

actionsLabel = {	
		'NoAction' : None,
		'Login' : None,
		'ListId': None,
		'ViewProfile' : None,
		'GetEdit' : None,
		'UpdateProfile' : None,
		'Logout' : None,
		'GetSearch': None,
		'Search' : None
}

