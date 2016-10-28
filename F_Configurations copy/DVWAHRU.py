starting_URL = 'http://127.0.0.1/dvwa/' # Where the test starts

views = {}
# views = {
# 
# }

Data = {}

Data['Admin'] = {
	'Credential':{
		'username':'admin',
		'password':'password',
		'Login':'Login'
		},
	'Id':{
		'id':'1',
		'Submit':'Submit'
		},
	'FileAddress':{
		'uploaded':'', 
		'submit':'Upload'
		},
	'Password1':{
		'password_current':'password'
		},
	'Password2':{
		'password_new':'',
		'password_conf':''
		},
	'Text':{
		'name':''
		},
	'Ip':{
		'ip':'192.168.1.1',
		'submit':'submit'
		},
	'Profile':{

		},
	'Message':{
		'txtName':'attack',
		'mtxMessage':'',
		'btnSign':'Sign Guestbook'
		}
}

actions = {}
actionsURL = {
		'NoAction': '',
		'Logout': 'logout.php',
		'LoginNoAttack': 'login.php',
		'Login': 'vulnerabilities/brute/',
		'PingBox': 'vulnerabilities/exec/',
		'ChangePwd': 'vulnerabilities/csrf/',
		'SearchForm': 'vulnerabilities/sqli/',
		'InputEcho': 'vulnerabilities/xss_r/',
		'FileUpload': 'vulnerabilities/upload/',
		'SendMessage': 'vulnerabilities/xss_s/',
		'FileInclusion': 'vulnerabilities/fi/?page=include.php'
		}

actionsLabel = {	
		'NoAction': None,
		'Logout': None,
        'LoginNoAttack': None,
        'Login': None,
        'PingBox': 'ping',
        'ChangePwd': None,
        'SearchForm': None,
        'InputEcho': None,
        'FileUpload': None,
		'SendMessage': None,
        'FileInclusion': None
		}

actionsProp = {	
		'NoAction': None,
        'Logout': 'GP',
        'LoginNoAttack': 'GP',
        'Login': 'GP',
        'PingBox': 'GP',
        'ChangePwd': 'GP',
        'SearchForm': 'GP',
        'InputEcho': 'GP',
        'FileUpload': 'GP',
        'SendMessage': 'GP',
 		'FileInclusion': 'GP'
		}