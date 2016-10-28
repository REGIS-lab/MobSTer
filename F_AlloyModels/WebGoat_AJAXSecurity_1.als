open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig LicenseKey,Session extends Data {}
one sig GuestSession extends Session {}
one sig GuestLicenseKey extends LicenseKey {}
one sig NoData extends Data {}


abstract sig Action {}
one sig SendLicenseKey, NoAction extends Action {}



abstract sig User{
	licenseKey: one LicenseKey,
	session: one Session,
	initialK: set Data,
	gainK: set Data
}

one sig Guest extends User{}
{
	licenseKey = GuestLicenseKey
	session = GuestSession
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
	disabled: set Data,
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
	first.user = Guest
	//Controls' Predicates
	first.action = NoAction
	first.grant = GuestSession
	first.checked = NoData
	first.PageIncluded = NoData
	first.echo = NoData
	first.exec = NoData
	first.disabled = NoData
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
		SendLicenseKey[s,s'] or SendLicenseKey[s,s'] 
	}
}

fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}


pred SendLicenseKey[s,s' : State]{
	one u : User |
	s.grant = u.session &&
	s'.action = SendLicenseKey &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	s'.disabled = u.licenseKey &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = u.licenseKey &&
	s'.noAttack = NoData
}


//AJAXdisabled
assert AJAXdisabled{
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.AJAX &&
	d in s.disabled
	}
}

check AJAXdisabled for 2 State, 1 User, 21 Data
//Trace 0
//['NoAction', 'SendLicenseKey']
//['1', 'GuestLicenseKey', 'Guest']
