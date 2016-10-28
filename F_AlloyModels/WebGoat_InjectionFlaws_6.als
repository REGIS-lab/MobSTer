open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig Id,Credential,Name,Session,Addr extends Data {}

abstract sig Action {}

one sig Login, Logout, ListId, ViewProfile, GetEdit, UpdateProfile, GetSearch, Search, NoAction extends Action {}

one sig NoData,mmmm extends Data {}

one sig LarryId, NevilleId, NoId extends Id {}

one sig LarryCredential, NevilleCredential, NoCredential extends Credential {}

one sig LarryName,NevilleName,NoName extends Name {}

one sig LarryAddr, NevilleAddr, NoAddr extends Addr {}

one sig NevilleSession, LarrySession, AnonSession extends Session {}

abstract sig Profile extends Data {
	name: one Name,
	address: one Addr
}

one sig LarryProfile extends Profile{} {
	name = LarryName
	address = LarryAddr
}

one sig NevilleProfile extends Profile{} {
	name = NevilleName
	address = NevilleAddr
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

one sig Larry extends User{}
{
	profile = LarryProfile
	id = LarryId
	name = LarryName
	credential = LarryCredential
	session = LarrySession
	initialK = credential + LarryId + NevilleId + NevilleName + LarryName
	gainK = NoData
}


one sig Neville extends User{}
{
	profile = NevilleProfile
	id = NevilleId
	name = NevilleName
	credential = NevilleCredential
	session = NevilleSession
	initialK = credential + LarryId + NevilleId +  NevilleName + LarryName
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
	s'.checked = i &&
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

assert SQLInj {
	no s : State |  some d : Data-NoData |  some x : User{
	x= Larry
	s.grant = x.session &&
	d in s.checked  && 
	NoData not in s.showDB 
	}
}


check SQLInj for 4 State, 2 User,  6 Data
//Trace 0
//['NoAction', 'Login', 'ListId', 'ViewProfile']
//['3', 'LarryId', 'Neville']
//Trace 1
//['NoAction', 'Login', 'ListId', 'ViewProfile']
//['3', 'NevilleId', 'Neville']
//Trace 2
//['NoAction', 'Login', 'ListId', 'ViewProfile']
//['3', 'LarryId', 'Larry']
//Trace 3
//['NoAction', 'Login', 'ListId', 'ViewProfile']
//['3', 'NevilleId', 'Larry']



//Bypass Login (SQL-Injection or PwdBruteForce)
assert BypassLoginSQL {
	no s : State |  some d : Credential | some x : User{
	x.name = NevilleName &&
	s.grant = x.session &&
	d in s.checked &&
	NoData in s.noAttack  
	}
}

//check BypassLoginSQL for 2 State, 2 User,  6 Data
//Trace 0
//['NoAction', 'Login']
//['1', 'Larry']
//Trace 1
//['NoAction', 'Login']
//['1', 'Neville']
