open util/ordering[State]

//Begin Data Def

abstract sig Data {}

abstract sig Item, CCdata, Session extends Data {}
one sig GuestSession extends Session {}
one sig GuestCC extends CCdata {}
one sig GuestItem extends Item {}
one sig NoData extends Data {}

abstract sig Action {}
one sig UpdateCart, Purchase, NoAction extends Action {}




abstract sig User{
	item: one Item,
	ccData: one CCdata,
	session: one Session,
	initialK: set Data,
	gainK: set Data
}

one sig Guest extends User{}
{
	item = GuestItem
	ccData = GuestCC
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
		UpdateCart[s,s'] or Purchase[s,s'] 
	}
}

fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}


pred UpdateCart[s,s' : State]{
	one u : User |
	s.grant = u.session &&
	s'.action = UpdateCart &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = u.item &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = u.item &&
	s'.showSD = u.item &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = u.item &&
	s'.noAttack = NoData
}


pred Purchase[s,s' : State]{
	one u : User |
	s.grant = u.session &&
	s'.action = Purchase &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = u.ccData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = u.ccData  &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = u.ccData  &&
	s'.noAttack = NoData
}





//Cross Site Scripting
assert XSScheck{
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.checked &&
	NoData not in s.showDB
	}
}

//check XSScheck for 3 State, 3 User, 21 Data




//Cross Site Scripting
assert XSS {
	no s : State | some d : Data-NoData | some x : User{
	s.grant = x.session &&
	d in s.echo 
	// Text in c1.dataTypes 
	}
}


check XSS for 2 State, 2 User, 4 Data
//Trace 0
//['NoAction', 'UpdateCart']
//['1', 'GuestItem', 'Guest']
//Trace 1
//['NoAction', 'Purchase']
//['1', 'GuestCC', 'Guest']

