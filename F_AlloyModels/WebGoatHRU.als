open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig Id,Credential,Name,Session,Addr extends Data {}

abstract sig Action {}

one sig Login, Logout, ListId, ViewProfile, GetEdit, UpdateProfile, GetSearch, Search, NoAction extends Action {}

one sig NoData,mmmm extends Data {}

one sig JerryId, TomId, NoId extends Id {}

one sig JerryCredential, TomCredential, NoCredential extends Credential {}

one sig JerryName,TomName,NoName extends Name {}

one sig JerryAddr, TomAddr, NoAddr extends Addr {}

one sig TomSession, JerrySession, AnonSession extends Session {}

abstract sig Profile extends Data {
	name: one Name,
	address: one Addr
}

one sig JerryProfile extends Profile{} {
	name = JerryName
	address = JerryAddr
}

one sig TomProfile extends Profile{} {
	name = TomName
	address = TomAddr
}

one sig NoProfile extends Profile{} {
	name = NoName
	address = NoAddr
}

abstract sig User{
	profile: one Profile,
	id: one Id,
	name: one Name,
	credential: one Credential,
	session: one Session,
	initialK: set Data,
	gainK: set Data
}

one sig Jerry extends User{}
{
	profile = JerryProfile
	id = JerryId
	name = JerryName
	credential = JerryCredential
	session = JerrySession
	initialK = credential + JerryId + TomId + TomName + JerryName
	gainK = NoData
}


one sig Tom extends User{}
{
	profile = TomProfile
	id = TomId
	name = TomName
	credential = TomCredential
	session = TomSession
	initialK = credential + JerryId + TomId +  TomName + JerryName
	gainK = NoData
}

one sig Anon extends User{}
{
	profile = NoProfile
	id = NoId
	name = NoName
	credential = NoCredential
	session = AnonSession
	initialK = NoData
	gainK = NoData
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
	pageInclusions: set Data,
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
	first.pageInclusions = NoData
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
		Login[s,s'] or Logout[s,s'] or ListId[s,s'] or
		ViewProfile[s,s'] or GetEdit[s,s'] or UpdateProfile[s,s'] or
		Search[s,s'] or GetSearch[s,s']
	}
}

fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}

fact {
	all s: State, s': s.next{
		Login in s.action implies ListId in s'.action
	}
}

pred GetSearch[s,s' : State]{
	one u : User-Anon | //one i : s.showDB | i in Id &&
	u.id in s.showDB &&
	s'.action = GetSearch &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = NoData &&
	s'.edit = u.name &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

//
pred Search[s,s' : State]{
	one u : User-Anon | one v : User-Anon |
	u.name in s.edit &&
	s.grant = u.session &&
	s'.action = Search &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = v.name & u.initialK &&
	s'.pageInclusions = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  v.profile &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}


pred Login[s, s' : State]{
	one u : User-Anon |  
	s'.action = Login &&
	s.grant = AnonSession &&
	u.credential in u.initialK &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = u.credential &&
	s'.pageInclusions = NoData &&
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
	s'.user = Anon &&
	//Controls' Predicates
	s'.grant = AnonSession &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
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


pred ListId[s, s' : State]{
	one u : User-Anon |  
	s'.action = ListId &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = Id & u.initialK  &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

pred ViewProfile[s,s' : State]{
	one u : User-Anon | one i : s.showDB | i in Id &&
	s'.action = ViewProfile &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  (i.(~id)).profile&&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}


pred GetEdit[s, s' : State]{
	one u : User-Anon | (s.showDB.(~profile)) = (s.grant.(~session))  &&
	s'.action = GetEdit &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.edit = s.showDB &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}


pred UpdateProfile[s, s' : State]{
	one u : User-Anon | one i : s.edit |	i in Profile &&
	s'.action = UpdateProfile &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.pageInclusions = NoData &&
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


//File Upload without checking phase 
assert FileUpload {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.writeFS 
	}
}

//File Upload with checking phase 
assert FileUpload2 {
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



//Command Execution
assert CommandExec {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.exec  
	}
}

//Bypass Login (SQL-Injection or PwdBruteForce)
assert BypassLogin {
	no s : State | some x : User{
	s.checked = x.credential &&
	NoData in s.noAttack  
	}
}

//Cross site Scripting 
assert StoredXSS {
	no s : State | some d : Data-NoData | some s' : State| some x,y : User{
	d in s.writeDB &&
	s.grant = x.session &&
	d in s'.showDB&& 
	s'.grant = y.session &&
	x != y &&
	lt[s, s']
	}
}


//SQL-Injection
assert SQLInj {
	no s : State |  some d,d' : Data-NoData |  some x : User{
	s.grant = x.session &&
	d in s.checked  && 
	d' in s.showDB 
	}
}


//check SQLInj              for 5 State, 3 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'ListId', 'GetSearch', 'Search']
//['4', 'JerryName', 'JerryProfile', 'Tom']
//Trace 1
//['NoAction', 'Login', 'ListId', 'GetSearch', 'Search']
//['4', 'TomName', 'TomProfile', 'Jerry']
//Trace 2
//['NoAction', 'Login', 'ListId', 'GetSearch', 'Search']
//['4', 'TomName', 'TomProfile', 'Tom']
//Trace 3
//['NoAction', 'Login', 'ListId', 'GetSearch', 'Search']
//['4', 'JerryName', 'JerryProfile', 'Jerry']

check StoredXSS for 10 State, 2 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'ListId', 'ViewProfile', 'GetEdit', 'UpdateProfile', 'Logout', 'Login', 'ListId', 'ViewProfile']
//['5', 'TomProfile', '9', 'Tom', 'Jerry']
//Trace 1
//['NoAction', 'Login', 'ListId', 'ViewProfile', 'GetEdit', 'UpdateProfile', 'Logout', 'Login', 'ListId', 'ViewProfile']
//['5', 'JerryProfile', '9', 'Jerry', 'Tom']


//check BypassLogin      for 2 State, 3 User, 21 Data
//Trace 0
//['NoAction', 'Login']
//['1', 'Jerry']
//Trace 1
//['NoAction', 'Login']
//['1', 'Tom']





// Functionality not present in this model 
//check ChangePwd      for 4 State, 3 User, 21 Data
//check FileUpload        for 3 State, 3 User, 21 Data
//check FileUpload2       for 4 State, 3 User, 21 Data
//check CommandExec  for 4 State, 3 User, 21 Data
//check FileInclusion      for 4 State, 1 User, 1 Data
//check XSS                  for 4 State, 3 User, 21 Data
