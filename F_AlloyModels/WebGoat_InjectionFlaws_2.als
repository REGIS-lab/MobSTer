open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig Station, Info, Session extends Data {}
one sig GuestStation extends Station {}
one sig GuestInfo extends Info {}
one sig GuestSession extends Session {}
one sig NoData extends Data {}


abstract sig Action {}

one sig SelectStation, NoAction extends Action {}


abstract sig User{
	station: one Station,
	info: one Info,
	session: one Session,
	initialK: set Data,
	gainK: set Data
}

one sig Guest extends User{}
{
	station = GuestStation
	info = GuestInfo
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
		SelectStation[s,s'] or SelectStation[s,s'] 
		// or Search[s,s'] or GetSearch[s,s']
	}
}

fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}

pred SelectStation[s, s' : State]{
	one u : User |  
	s'.action = SelectStation &&
	s.grant = u.session &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = u.station &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.info &&
	s'.writeDB = NoData &&
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
	s.grant = x.session &&
	d in s.checked  && 
	NoData not in s.showDB 
	}
}


check SQLInj              for 2 State, 2 User,  5 Data
//Trace 0
//['NoAction', 'SelectStation']
//['1', 'GuestStation', 'Guest']
