open util/ordering[State]

//Begin Data Def

abstract sig Data {}
abstract sig Credential, Id, Ip,FileAddress,Password1, Password2,Title, Message,Text, Session,Name,Addr extends Data {}
one sig NoData extends Data {}


abstract sig Action {}
one sig Login, Logout, AddMessage, ChangePwd, FileUpload, FileAccess, ViewProfile, UpdateProfile, ShowMessage, ShowMessageAsUser, ManageThisServer, Refresh, SignUp, FileInclusion, NoAction extends Action {}

one sig Usr1Credential, Usr2Credential, NoCredential extends Credential {}
one sig Usr1Id, Usr2Id, NoId extends Id {}
one sig Usr1Session, Usr2Session, AnonSession extends Session {}
one sig Usr1FileAddress,Usr2FileAddress,NoFileAddress extends FileAddress {}
one sig Usr1Password1,Usr2Password1,NoPassword1 extends Password1 {}
one sig Usr1Password2,Usr2Password2,NoPassword2 extends Password2 {}
one sig Usr1Text,Usr2Text,NoText extends Text {}

one sig Usr1Name,Usr2Name,NoName extends Name {}

one sig Usr1Addr, Usr2Addr, NoAddr extends Addr {}


abstract sig Profile extends Data {
	name: one Name,
	address: one Addr
}

one sig Usr1Profile extends Profile{} {
	name = Usr1Name
	address = Usr1Addr
}

one sig Usr2Profile extends Profile{} {
	name = Usr2Name
	address = Usr2Addr
}

one sig NoProfile extends Profile{} {
	name = NoName
	address = NoAddr
}



abstract sig User{
	credential: one Credential,
	id: one Id,	
	profile: one Profile,
	fileAddress: one FileAddress,
	password1: one Password1, 
	password2: one Password2,
	text: one Text,
	session: one Session,
	initialK: set Data
}

one sig Usr1 extends User{}
{
	credential = Usr1Credential
	id = Usr1Id
	profile = Usr1Profile
	fileAddress = Usr1FileAddress
	password1 = Usr1Password1 
	password2 = Usr1Password2
	text = Usr1Text
	session = Usr1Session
	initialK = credential + Usr1Password1 + Usr1Password2
}

one sig Usr2 extends User{}
{
	credential = Usr2Credential
	id = Usr2Id
	profile = Usr2Profile
	fileAddress = Usr2FileAddress
	password1 = Usr2Password1 
	password2 = Usr2Password2
	text = Usr2Text
	session = Usr2Session
	initialK = credential + Usr2Password1 + Usr2Password2
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
	session = AnonSession
	initialK = NoData
}

//End Data Def

//---------------------------------------------

//Begin State Def

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
		Login[s,s'] or Logout[s,s']  or ViewProfile[s,s'] or UpdateProfile[s,s'] or
		AddMessage[s,s'] or ChangePwd[s,s'] or FileUpload[s,s'] or 
		FileAccess[s,s']  or ShowMessage[s,s'] or FileInclusion[s,s'] or
		ShowMessageAsUser[s,s'] or Refresh[s,s']
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
	s.grant = AnonSession &&
	u.credential in u.initialK &&  
	s'.action = Login &&
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

pred ViewProfile[s, s' : State]{
	one u : User-Anon |  
	s'.action = ViewProfile &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.profile &&
	s'.writeDB = NoData &&
	s'.edit = u.profile &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred UpdateProfile[s, s' : State]{
	one u : User-Anon |  one i : s.edit |	i in Profile &&
	s'.action = UpdateProfile &&
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
	s'.writeDB = s.edit &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred ChangePwd[s, s' : State]{
	one u : User-Anon |  one i : s.edit |	i in Profile &&
	s'.action = ChangePwd &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = Password1 & u.initialK &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = Password2 & u.initialK &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}



pred AddMessage[s, s' : State]{
	one u : User-Anon |  
	s'.action = AddMessage &&
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
	s'.writeDB = u.text &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}


pred ShowMessage[s, s' : State]{
	one u : Anon |  one v : User-Anon |
	s'.action = ShowMessage &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = v.text &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred ShowMessageAsUser[s, s' : State]{
	one u : User-Anon |
	s'.action = ShowMessageAsUser &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.text &&
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
	s'.showFS = u.fileAddress &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}



pred Refresh[s, s' : State]{
	one u : User-Anon |  
	s'.action = Refresh &&
	s.grant = u.session &&
	s.showDB = u.text &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = u.text &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.text &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = u.text &&
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
	s'.showFS = u.fileAddress &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

//------------------------------------------------------------------------
//
//pred ManageThisServer[s,s' : State]{
//
//pred SignUp[s,s' : State]{
//
//------------------------------------------------------------------------



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
assert FileUpload {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.writeFS 
	}
}

//XSS_FileUpload
assert XSS_FileUpload {
	no s : State | some d : Data-NoData | some s' : State| some x : User{
	x.id = Usr1Id &&
	x.fileAddress = Usr1FileAddress &&
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
assert BypassLogin {
	no s : State | some x : User{
	s.grant = x.session &&
	s.checked = x.credential &&
	x.credential not in s.noAttack
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


//File Inclusion
assert FileInclusion {
    no s : State | some d : Data-NoData| some x : User{
	x.id = Usr1Id &&
	x.fileAddress = Usr1FileAddress &&
	s.grant = x.session &&
	d in s.PageIncluded 
	}
}




// Base URL for checcking XSS 
assert urlXSS {
no s : State | some d : FileAddress | some x : User{
	s.grant = x.session &&
	d in s.PageIncluded 
	}
}

//Aimed Stored Cross Site Scripting
assert StoredXSSaimed {
	no s : State | some d : Profile | some s' : State| some x,y : User{
	d in s.writeDB &&
	s.grant = x.session &&
	d in s'.showDB&& 
	s'.grant = y.session &&
	//x != y &&
	lt[s, s']
	}
}


//AJAX XSS
assert AJAXxss {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.AJAX &&
	d in s.echo 
	}
}

//check AJAXxss for 4 State, 1 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'ShowMessageAsUser', 'Refresh']
//['3', 'Usr1Text', 'Usr1']
//Trace 1
//['NoAction', 'Login', 'ShowMessageAsUser', 'Refresh']
//['3', 'Usr2Text', 'Usr2']


//check StoredXSSaimed for 5 State, 2 User, 21 Data

//check urlXSS for 3 State, 1 User, 1 Data
//Trace 0
//['NoAction', 'Login', 'FileInclusion']
//['2', 'Usr1FileAddress', 'Usr1']
//Trace 1
//['NoAction', 'Login', 'FileInclusion']
//['2', 'Usr2FileAddress', 'Usr2']

check FileInclusion for 3 State, 1 User, 1 Data
//Trace 0
//['NoAction', 'Login', 'FileInclusion']
//['2', 'Usr1FileAddress', 'Usr1']
//Trace 1
//['NoAction', 'Login', 'FileInclusion']
//['2', 'Usr2FileAddress', 'Usr2']

//check StoredXSS for 4 State, 2 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'AddMessage', 'ShowMessageAsUser']
//['2', 'Usr1Text', '3', 'Usr1', 'Usr1']
//Trace 1
//['NoAction', 'Login', 'AddMessage', 'ShowMessageAsUser']
//['2', 'Usr2Text', '3', 'Usr2', 'Usr2']


////check ChangePwd      for 4 State, 3 User, 21 Data
////Trace 0
////['NoAction', 'Login', 'ViewProfile', 'ChangePwd']
////'3', 'Usr2']
////Trace 1
////['NoAction', 'Login', 'ViewProfile', 'ChangePwd']
////['3', 'Usr1']


//check XSS_FileUpload       for 4 State, 3 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'FileUpload', 'FileAccess']
//['2', 'Usr2FileAddress', '3', 'Usr2']
//Trace 1
//['NoAction', 'Login', 'FileUpload', 'FileAccess']
//['2', 'Usr1FileAddress', '3', 'Usr1']


