starting_URL = 'http://157.27.244.25:8080/WebGoat/attack?Screen=509&menu=900&stage=1'
set_cookie = ''
set_cookie = {'JSESSIONID':'974AE35BC95CADBC036C2E3CBE543B1C'}
SSL_authentication = None

Header={}
Header["Authorization"] = 'Basic Z3Vlc3Q6Z3Vlc3Q='

views = {}
views = {
	'Login':'ListId'
}

Data = {}

Data['Tom'] = {
	'employee_id':'105',
	'password':'tom'
}
	
Data['Jerry']={
	'employee_id':'106',
	'password':'jerry'
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
	'Search' 		: 'FindProfile'
	
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



