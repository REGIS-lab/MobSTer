open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig Id,Credential,Name,Addr,UserType,Session extends Data {}

abstract sig Action {}

one sig Login, Logout, ListId, ViewProfile, GetEdit, UpdateProfile, GetSearch, Search, DeleteProfile, ViewProfileGuessed, ListIdGuessed, NoAction extends Action {}

one sig NoData,mmmm extends Data {}

one sig JohnId, JerryId, TomId, NoId extends Id {}

one sig JohnCredential, JerryCredential, TomCredential, NoCredential extends Credential {}

one sig JohnName, JerryName, TomName, NoName extends Name {}

one sig JohnAddr, JerryAddr, TomAddr, NoAddr extends Addr {}

one sig JohnSession, JerrySession, TomSession, AnonSession extends Session {}

one sig isAdmin, isUser extends UserType {}


abstract sig Profile extends Data {
	name: one Name,
	address: one Addr
}

one sig JohnProfile extends Profile{} {
	name = JohnName
	address = JohnAddr
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
	gainK: set Data,
	guessedK: set Data,
	userType: one Data
}

one sig John extends User{}
{
	profile = JohnProfile
	id = JohnId
	name = JohnName
	credential = JohnCredential
	session = JohnSession
	userType = isAdmin
	initialK = credential+JohnId+JerryId+TomId+JerryName+TomName+JohnName
	gainK = NoData
	guessedK = NoData
}

one sig Jerry extends User{}
{
	profile = JerryProfile
	id = JerryId
	name = JerryName
	credential = JerryCredential
	session = JerrySession
	userType = isUser 
	initialK = credential+JerryId +TomId+JohnId+TomName+JerryName
	gainK = NoData
	guessedK = NoData
}

one sig Tom extends User{}
{
	profile = TomProfile
	id = TomId
	name = TomName
	credential = TomCredential
	session = TomSession
	userType = isUser 
//	initialK = credential+JerryId+TomId+TomName+JerryName
	initialK = credential+TomId+TomName
	gainK = NoData
	guessedK = NoData
}

one sig Anon extends User{}
{
	profile = NoProfile
	id = NoId
	name = NoName
	credential = NoCredential
	session = AnonSession
	userType = isUser 
	initialK = NoData
	gainK = NoData
	guessedK = NoData
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
	gainK: User -> set Data,
	guessedK: User -> set Data
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
	(all u:User | first.guessedK[u] = NoData)
}

//End State Def

//---------------------------------------------

//Begin Transition Def

fact {
	all s: State, s': s.next{
		Login[s,s'] or Logout[s,s'] or ListId[s,s'] or
		ViewProfile[s,s'] or GetEdit[s,s'] or UpdateProfile[s,s'] or
		Search[s,s'] or GetSearch[s,s'] or 
		DeleteProfile[s,s'] or ListIdGuessed[s,s'] or ViewProfileGuessed[s,s']
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
		ListIdGuessed in s'.action implies 
		(
		s'.guessedK[s.user] = (s.guessedK[s.user] + (Id - s.user.initialK - NoId )) &&
				(all u : User | (u != s.user) implies s'.guessedK[u] = s.guessedK[u])
		)
	}
}

fact {
	all s: State, s': s.next{
		ListIdGuessed not in s'.action implies 
		( 
			all u : User | s'.guessedK[u] = s.guessedK[u]
		)
	}
}


/*
fact {
	all s: State, s': s.next{
		Login in s.action implies ListId in s'.action
	}
}
*/


pred GetSearch[s,s' : State]{
	one u : User-Anon | //one i : s.showDB | i in Id &&
	u.id in s.showDB &&
	s'.action = GetSearch &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
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
	s'.PageIncluded = NoData &&
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
	s'.user = Anon &&
	//Controls' Predicates
	s'.grant = AnonSession &&
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


pred ListId[s, s' : State]{
	one u : User-Anon |  
	s'.action = ListId &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
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
	s'.PageIncluded = NoData &&
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
	s'.PageIncluded = NoData &&
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


pred DeleteProfile[s,s' : State]{
	one u : User-Anon | one i : s.showDB | i in Id &&
	s.user.userType = isAdmin &&
	s'.action = DeleteProfile &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = isAdmin &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = (i.(~id)).profile &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}

//---> guessing data <---
pred ListIdGuessed[s, s' : State]{
	one u : User-Anon | 
	s.user.userType = isUser &&
	s'.action = ListIdGuessed &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
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

pred ViewProfileGuessed[s,s' : State]{
	one u : User-Anon | one i : s.guessedK[u] - NoData - NoId |
	s'.action = ViewProfileGuessed &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = i.(~id).profile &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData &&
	s'.noAttack = NoData
}



//Search for administrative action to be tested
// stage=1 
assert AdminAction { 
	no s : State | some d : Data| some x : User{
	s.grant = x.session &&
	d in s.writeDB &&
	d = TomProfile &&
	s.guessedK[x] = NoData &&
	isAdmin in s.checked
	}
}
// stage=1
//check AdminAction for 4 State, 4 User, 21 Data

//Trace 0
//['NoAction', 'Login', 'ListId', 'DeleteProfile']
//['3', 'TomProfile', 'John']
//Trace 1
//['NoAction', 'Login', 'ListId', 'DeleteProfile']
//['3', 'JohnProfile', 'John']
//Trace 2
//['NoAction', 'Login', 'ListId', 'DeleteProfile']
//['3', 'JerryProfile', 'John']

// stage=3
assert GuessedId {
	no s : State | some d : Data-NoData| some x : User{
	s.grant = x.session &&
	d in s.guessedK[x] &&
	d.(~id).profile in s.showDB 
	}
}
// stage=3
check GuessedId for 4 State, 4 User, 21 Data
//Trace 0
//['NoAction', 'Login', 'ListIdGuessed', 'ViewProfileGuessed']
//['3', 'JerryId', 'Tom']
//Trace 1
//['NoAction', 'Login', 'ListIdGuessed', 'ViewProfileGuessed']
//['3', 'JohnId', 'Tom']






