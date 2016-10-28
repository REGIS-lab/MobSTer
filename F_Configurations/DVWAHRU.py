starting_URL = 'https://157.27.244.25/dvwa/' # Where the test starts
set_cookie = ''
SSL_authentication = ('regis','password')

# set_cookie = {'PHPSESSID':'26ao2kifqvn6er7eed9bpcbp43'}
# SSL_authentication = None


views = {}
# views = {
# 
# }

Data = {}

Data['Admin'] = {
	'username':'admin',
	'password':'password',
	'id':'1',
	'uploaded':'', 
	'MAX_FILE_SIZE':'999999999',
	'password_current':'password',
	'password_new':'password',
	'password_conf':'password',
	'name':'',
	'ip':'192.168.1.42',
	'txtName':'attack',
	'mtxMessage':'',
}

actions = {}
actionsURL = {
		'NoAction': '',
		'Logout': 'logout.php',
		'LoginNoAttack': 'login.php',
		'Login': 'vulnerabilities/brute/',
		'PingBox': 'vulnerabilities/exec/',
		'ChangePwd': 'vulnerabilities/csrf/',
		#'SearchForm': 'vulnerabilities/sqli/',
		'SearchForm': 'vulnerabilities/sqli_blind/',
		'InputEcho': 'vulnerabilities/xss_r/',
		'FileUpload': 'vulnerabilities/upload/',
		'FileAccess': 'hackable/uploads/FileUploadXSS.html',
		'SendMessage': 'vulnerabilities/xss_s/',
		'FileInclusion': 'vulnerabilities/fi/?page=include.php'
		}

actionsLabel  = {	
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
 		'FileInclusion': 'GP',
		'FileAccess':'GP'
		}