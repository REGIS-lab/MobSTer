starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=65&menu=200' # Where the test starts

views = {}

Data = {}

Data['John'] = { ### Warning for the attack we switch the name here!!!
	'Credential':{
		'employee_id':'105',
		'password':'tom'
		},
	'Profile':{
		'firstName'        :'Tom',
		'lastName'         :'Cat',
		'address1'         :'2211 HyperThread Rd.',
		'address2'         :'New York, NY',
		'phoneNumber'      :'443-599-0762',
		'startDate'        :'1011999',
		'ssn'              :'792-14-6364',
		'salary'           :'80000',
		'ccn'              :'5481360857968521',
		'ccnLimit'         :'80000',
		'description'      :'Co-Owner.',
		'manager'          :'105',
		'disciplinaryNotes':'NA',
		'disciplinaryDate' :'0',
		'employee_id'      :'105',
		'title'            :'Engineer'
		},
	'Id':{
		'employee_id':'105'
		}
}

Data['Tom'] = { 
	'Credential':{
		'employee_id':'105',
		'password':'tom'
		},
	'Profile':{
		'firstName'        :'Tom',
		'lastName'         :'Cat',
		'address1'         :'2211 HyperThread Rd.',
		'address2'         :'New York, NY',
		'phoneNumber'      :'443-599-0762',
		'startDate'        :'1011999',
		'ssn'              :'792-14-6364',
		'salary'           :'80000',
		'ccn'              :'5481360857968521',
		'ccnLimit'         :'80000',
		'description'      :'Co-Owner.',
		'manager'          :'105',
		'disciplinaryNotes':'NA',
		'disciplinaryDate' :'0',
		'employee_id'      :'105',
		'title'            :'Engineer'
		},
	'Id':{
		'employee_id':'105'
		}
}
actions = {}
actionsURL = {
	'NoAction'      : '',
	'Login'         : '&action=Login',
	'Logout'        : '$action=Logout',
	'ViewProfile'   : '&action=ViewProfile',
	'ListId'     	: '&action=ListStaff',
	'SearchStaff'   : '&action=SearchStaff',
	'GetEdit'   	: '&action=EditProfile',
	'UpdateProfile' : '&action=UpdateProfile',
	'ListIdGuessed': '&action=ListStaff',
	'ViewProfileGuessed' : '&action=ViewProfile',
	'DeleteProfile' : '&action=DeleteProfile'
	}

actionsLabel = {	
		'NoAction' : None,
		'Login' : 'form1',
		'ListId': 'form1',
		'ViewProfile' : 'form1',
		'GetEdit' : None,
		'UpdateProfile' : None,
		'Logout' : None,
		'ListIdGuessed': 'form1',
		'ViewProfileGuessed' : 'form1',
		'DeleteProfile' : 'form1'
}


actionsProp = {	
		'NoAction' : None,
		'Login' : None,
		'ListId': None,
		'ViewProfile' : None,
		'GetEdit' : None,
		'UpdateProfile' : None,
		'Logout' : None,
		'ListIdGuessed': None,
		'ViewProfileGuessed' : None,
		'DeleteProfile' : None
}







# 	
# Data['Jerry']={
# 	'Credential':{
# 		'employee_id':'106',
# 		'password':'jerry'
# 		},
# 	'Profile':{	
# 		'firstName'        :'Jerry',
# 		'lastName'         :'Mouse',
# 		'address1'         :'3011 Unix Drive',
# 		'address2'         :'New York, NY',
# 		'phoneNumber'      :'443-699-3366',
# 		'startDate'        :'1011999',
# 		'ssn'              :'858-55-4452',
# 		'salary'           :'70000',
# 		'ccn'              :'6981754825013564',
# 		'ccnLimit'         :'20000',
# 		'description'      :'Co-Owner.',
# 		'manager'          :'106',
# 		'disciplinaryNotes':'NA',
# 		'disciplinaryDate' :'0',
# 		'employee_id'      :'106',
# 		'title'            :'Human Resources'
# 		},
# 	'Id':{
# 		'employee_id':'106'
# 		}
# }