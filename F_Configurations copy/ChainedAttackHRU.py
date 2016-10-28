starting_URL = 'http://demeo.eu/chained/' # Where the test starts

views = {}
views = {
	'Login':'SelecProfile'
}


Data = {}


Data['Alice'] = {
	'Credential':{
		'username':'Alice',
		'password':'password'
		},
	'Profile':{
		'name'      :'Alice',
		'surname'   :'Wonderland',
		'phone'  	:'987654321',
		'avatar' :  '',
		'user':'alice'
		},
	'Id':{
		'user':'alice'
		}
}


Data['Bob'] = {
	'Credential':{
		'username':'Bob',
		'password':'password'
		},
	'Profile':{
		'name'      :'Bob',
		'surname'   :'Paulson',
		'phone'  	:'1234567890',
		'avatar' 	: '',
		'user'		: 'bob'
		},
	'Id':{
		'user':'bob'
		}
}

actions = {}
actionsURL = {
				'NoAction': '',
				'Login': 'index.php',
				'SelecProfile':'dashboard.php',
				'ViewProfile': 'profile.php',
				'EditProfile': 'profile.php',
				'UpdateProfile': 'profile.php',
				'Logout':'index.php'
				}

actionsLabel = {	
	'NoAction'		: None,
	'Login'			: None,
	'SelecProfile'	: None,
	'ViewProfile'	: None,
	'EditProfile'	: None,
	'UpdateProfile'	: None,
	'Logout'		: None
	}

actionsProp = {	
	'NoAction'		: None,
	'Login'			: None,
	'SelecProfile'	: None,
	'ViewProfile'	: None,
	'EditProfile'	: None,
	'UpdateProfile'	: None,
	'Logout'		: None
	}

