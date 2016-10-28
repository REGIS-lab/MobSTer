open util/ordering[State]

//Begin Data Def

abstract sig Data {}
abstract sig Credential, Id,FileAddress,Password1, Password2,Text,Ip,Profile,Message,Session extends Data {}
one sig NoData extends Data {}


abstract sig Action {}
one sig Login, Logout, LoginNoAttack, PingBox, ChangePwd, SearchForm, InputEcho, FileUpload, FileAccess, SendMessage, FileInclusion ,NoAction extends Action {}

one sig AdminCredential, NoCredential extends Credential {}
one sig AdminId, NoId extends Id {}
one sig AdminProfile, NoProfile extends Profile {}
one sig AdminSession, AnonSession extends Session {}
one sig AdminFileAddress,NoFileAddress extends FileAddress {}
one sig AdminPassword1,NoPassword1 extends Password1 {}
one sig AdminPassword2,NoPassword2 extends Password2 {}
one sig AdminText,NoText extends Text {}
one sig AdminMessage,NoMessage extends Message {}
one sig AdminIp,NoIp extends Ip {}


abstract sig User{
	credential: one Credential,
	id: one Id,	
	profile: one Profile,
	fileAddress: one FileAddress,
	password1: one Password1, 
	password2: one Password2,
	text: one Text,
	ip: one Ip,
	message: one Message,
	session: one Session,
	initialK: set Data
}

one sig Admin extends User{}
{
	message = AdminMessage
	credential = AdminCredential
	id = AdminId
	profile = AdminProfile
	fileAddress = AdminFileAddress
	password1 = AdminPassword1 
	password2 = AdminPassword2
	text = AdminText
	ip = AdminIp
	session = AdminSession
	initialK = credential + AdminPassword1 
}


one sig Anon extends User{}
{
	credential = NoCredential
	id = NoId
	profile = NoProfile
	fileAddress = NoFileAddress
	password1 = NoPassword1 
	password2 = NoPassword2
	text = NoText
	ip = NoIp
	message =NoMessage
	session = AnonSession
	initialK = NoData
}




//End Data Def

//---------------------------------------------

//Begin State Def
sig State {
	//User
	user: one User,
	//Controls' Predicates
	action: one Action,
	grant: set Data,
	checked: set Data,
	AJAX: set Data,
	PageIncluded: set Data,
	echo: set Data,
	exec: set Data,
	//Web applications' Events
	showDB: set Data,
	writeDB: set Data,
	edit: set Data,
	writeSD: set Data,
	showSD: set Data,
	writeFS: set Data,
	showFS: set Data,
	noAttack: set Data,
	gainK: User -> set Data
}

fact{
	//User
	first.user = Anon
	//Controls' Predicates
	first.action = NoAction
	first.grant = AnonSession
	first.checked = NoData
	first.PageIncluded = NoData
	first.echo = NoData
	first.exec = NoData
	//Web applications' Events
	first.showDB = NoData
	first.writeDB = NoData
	first.edit = NoData
	first.writeSD = NoData
	first.showSD = NoData
	first.writeFS = NoData
	first.showFS = NoData
	first.AJAX = NoData
	first.noAttack = NoData
	(all u:User | first.gainK[u] = NoData)
}

//End State Def

//---------------------------------------------

//Begin Transition Def

fact {
	all s: State, s': s.next{
		Login[s,s'] or Logout[s,s'] or LoginNoAttack[s,s'] or PingBox[s,s'] or 
		ChangePwd[s,s'] or SearchForm[s,s'] or InputEcho[s,s'] or 
		FileUpload[s,s'] or SendMessage[s,s'] or FileInclusion[s,s'] or
		FileAccess[s,s']
		//SignUp[s,s'] or ManageThisServer[s,s']
	}
}

fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}


pred Login[s, s' : State]{
	one u : User-Anon |  
	s'.action = Login &&
	s.grant = u.session &&
	u.credential in u.initialK &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = u.credential &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred LoginNoAttack[s, s' : State]{
	one u : User-Anon |  
	s'.action = LoginNoAttack &&
	s.grant = AnonSession &&
	u.credential in u.initialK &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = u.credential &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = u.credential
}

pred Logout[s, s' : State]{
	one u : User-Anon | 
	s'.action = Logout &&
	s.grant = u.session &&      
	s'.grant = AnonSession &&
	s'.user = Anon &&
	//Controls' Predicates
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred PingBox[s, s' : State]{
	one u : User-Anon |  
	s'.action = PingBox &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = u.ip &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = u.message&&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred ChangePwd[s,s' : State]{
	one u : User-Anon |  
	s.grant = u.session &&
	s'.action = ChangePwd &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = u.password1 & u.initialK &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = u.password2 && //& u.initialK &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred SearchForm[s, s' : State]{
	one u : User-Anon |  
	s'.action = SearchForm &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = u.id &&

	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.profile &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred InputEcho[s, s' : State]{
	one u : User-Anon |  
	s'.action = InputEcho &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&

	s'.PageIncluded = NoData &&
	s'.echo = u.text &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred FileUpload[s, s' : State]{
	one u : User-Anon |  
	s'.action = FileUpload &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&

	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = u.fileAddress &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}


pred FileAccess[s, s' : State]{
	one u : User-Anon |  
	s'.action = FileAccess &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = u.fileAddress&&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}
//--------------------------------------------------------------------------------<<<---
pred SendMessage[s, s' : State]{
	one u : User-Anon |  
	s'.action = SendMessage &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&

	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&

	//Web applications' Events
	s'.showDB = u.message &&
	s'.writeDB = u.message &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}
 
pred FileInclusion[s, s' : State]{
	one u : User-Anon |  
	s'.action = FileInclusion &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&

	s'.PageIncluded = u.fileAddress &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}



//File Inclusion
assert FileInclusion {
no s : State | some d : FileAddress | some x : User{
	s.grant = x.session &&
	d in s.PageIncluded 
	}
}

//Stored Cross Site Scripting
assert StoredXSS {
	no s : State | some d : Data-NoData | some s' : State| some x,y : User{
	d in s.writeDB &&
	s.grant = x.session &&
	d in s'.showDB&& 
	s'.grant = y.session &&
	//x != y &&
	lt[s, s']
	}
}

//File Upload without check-phase 
//assert FileUpload {
//	no s : State | some d : Data-NoData | some x : User{
//	s.grant = x.session &&
//	d in s.writeFS 
//	}
//}

//File Upload with check-phase 
assert FileUpload {
	no s : State | some d : Data-NoData | some s' : State| some x : User{
	s.grant = x.session &&
	d in s.writeFS &&
	s'.grant = x.session &&
	d in s'.showFS &&
	lt[s, s']
	}
}

//Cross Site Scripting
assert XSS {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.echo 
	// Text in c1.dataTypes 
	}
}

//SQL-Injection
assert SQLInj {
	no s : State |  some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.checked  && 
	NoData not in s.showDB
	}
}

//Bypass Login (SQL-Injection or PwdBruteForce)
assert PasswordBruteForce {
	no s : State | some d : Credential | some x : User{
	s.grant = x.session &&
	d in s.checked &&
	d not in s.noAttack
	}
}

//Command Execution
assert CommandExec {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.exec  
	}
}

//Change Password
assert ChangePwd {
	no s : State | some x : User{
	s.grant = x.session &&
	x.password1 in s.checked &&
	x.password2 in s.writeDB 
	//x.credential not in noAttack
	}
}


//check PasswordBruteForce for 3 State, 2 User, 21 Data
//['NoAction', 'LoginNoAttack', 'Login']
//['2', 'Admin']


//check CommandExec  for 3 State, 2 User, 21 Data
//['NoAction', 'LoginNoAttack', 'PingBox']
//['2', 'AdminIp', 'Admin']


//check FileInclusion for 3 State, 2 User, 1 Data
//['NoAction', 'LoginNoAttack', 'FileInclusion']
//['2', 'AdminFileAddress', 'Admin']


//check SQLInj for 3 State, 3 User, 21 Data
//['NoAction', 'LoginNoAttack', 'SearchForm']
//['2', 'AdminId', 'Admin']

//check FileUpload for 4 State, 3 User, 21 Data
//['NoAction', 'LoginNoAttack', 'FileUpload']
//['2', 'AdminFileAddress', 'Admin']

//check XSS for 3 State, 3 User, 21 Data
//['NoAction', 'LoginNoAttack', 'InputEcho']
//['2', 'AdminText', 'Admin']

check StoredXSS for 4 State, 3 User, 21 Data
//['NoAction', 'LoginNoAttack', 'SendMessage', 'SendMessage']
//['2', 'AdminMessage', '3', 'Admin', 'Admin']




//check ChangePwd for 3 State, 3 User, 21 Data
//['NoAction', 'LoginNoAttack', 'ChangePwd']
//['2', 'Admin']




// *** WARNING ***
//check FileUpload2       for 4 State, 3 User, 21 Data
// THE ACTION THAT READS THE FILE IS MISSING 
