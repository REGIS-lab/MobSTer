starting_URL = 'http://127.0.0.1:8008/43481629/' # Where the test starts

views = {}
# views = {
# 
# }

Data = {}

Data['Usr2'] = {
	'FileAddress':{
		'upload_file':''
		},
	'Password1':{
		'oldpw':''
		},
	'Password2':{
		'pw':''
		},
	'Text':{
		'snippet':''
		},
	'Credential':{
		'uid':'caio',
		'pw':'password'
		},
	'Profile':{
		'firstName' :'Tom',
		'lastName'  :'Cat'
		},
	'Id':{
		'employee_id':'105'
		}
}

Data['Usr1']={
	'Credential':{
		'employee_id':'106',
		'password':'jerry'
		},
	'Profile':{	
		'firstName'        :'Jerry',
		'lastName'         :'Mouse'
		},
	'Id':{
		'employee_id':'106'
		}
}

actions = {}
actionsURL = {
	'NoAction': '',
	'Login': 'login',
	'AddMessage':'newsnippet.gtl',
	'ShowMessageAsUser':'snippets.gtl',
	'ShowMessage':'snippets.gtl?uid=caio',
	'ViewProfile': 'editprofile.gtl',
	'UpdateProfile': 'saveprofile',
	'Logout':'logout'
}


actionsLabel = {	
	'NoAction': None,
	'Login': None,
	'GetHome': None,
	'AddMessage':None,
	'ShowMessageAsUser':None,
	'ShowMessage':None,
	'ViewProfile': None,
	'EditProfile': None,
	'UpdateProfile':None,
	'Refresh': None,
	'Logout' : None
}

actionsProp = {	
 	'NoAction': None,
 	'Login': 'GP',
 	'GetHome': 'GP',
 	'AddMessage':'GP',
 	'ShowMessageAsUser':'GP',
	'ShowMessage':'GP',
 	'ViewProfile': 'GP',
	'UpdateProfile':None,
 	'EditProfile': 'GP',
	'Refresh': 'GP',
	'Logout' : None
}

