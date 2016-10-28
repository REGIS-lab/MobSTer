open util/ordering[State]

//Begin Data Def

abstract sig Action {}
one sig Login, Logout, AddItem,EnterPayment, ConfirmOrder, NoAction extends Action {}


abstract sig Data {}
one sig NoData extends Data {}
abstract sig Credential,Name,Session, Item extends Data {}

one sig ItemA, ItemB extends Item {}
one sig BobSession, AliceSession, AnonSession extends Session {}
one sig AliceCredential, BobCredential, NoCredential extends Credential {}
one sig AliceName,BobName,NoName extends Name {}



//User
abstract sig User{
	name: one Name,
	credential: one Credential,
	session: one Session,
	initialK: set Data
}

one sig Alice extends User{}
{
	name = AliceName
	credential = AliceCredential
	session = AliceSession
	initialK = AliceCredential
}


one sig Bob extends User{}
{
	name = BobName
	credential = BobCredential
	session = BobSession
	initialK = BobCredential
}

one sig Anon extends User{}
{
	name = NoName
	credential = NoCredential
	session = AnonSession
	initialK = NoData
}

//State

sig State {
	//User
	user: one User,
	//Controls' Predicates
	action: one Action,
	grant: set Data,
	checked: set Data,
	PageIncluded: set Data,
	echo: set Data,
	exec: set Data,
	AJAX: set Data,
	//Web applications' Events
	showDB: set Data,
	writeDB: set Data,
	writeSD: set Data,
	showSD: set Data,
	writeFS: set Data,
	showFS: set Data,
	noAttack: set Data,
	edit: set Data,

	gainK: User -> set Data,
	basket: User -> set Data,
	itemPayed: User -> set Data,
	itemShipped: User -> set Data
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
	first.AJAX = NoData
	//Web applications' Events
	first.showDB = NoData
	first.writeDB = NoData
	first.writeSD = NoData
	first.showSD = NoData
	first.writeFS = NoData
	first.showFS = NoData
	first.noAttack = NoData
	first.edit = NoData
	(all u:User | first.gainK[u] = NoData)
	(all u:User | first.basket[u] = NoData)
	(all u:User | first.itemPayed[u] = NoData)
	(all u:User | first.itemShipped[u] = NoData)
}


//End State Def

//---------------------------------------------

//Begin Transition Def

fact {
	all s: State, s': s.next{
		Login[s,s'] or Logout[s,s'] or AddItem[s,s'] or EnterPayment[s,s'] or ConfirmOrder[s,s']
     // or SelecProfile[s,s'] or ViewProfile[s,s'] or EditProfile[s,s'] or UpdateProfile[s,s']
	}
}

//Knowledge Evolution
fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}

//If AddItem then update basket
fact {
	all s: State, s': s.next{
		AddItem in s'.action implies 
		(
		s'.basket[s.user] = (s.basket[s.user] + s'.showDB) &&
				(all u : User | (u != s.user) implies s'.basket[u] = s.basket[u])
		)
	}
}

//If Login then add Anon basket to the logged user
fact {
	all s: State, s': s.next{
		Login in s'.action implies 
		(
		s'.basket[s'.user] = (s'.basket[s.user] + s.basket[Anon]) &&
				(all u : User - s'.user - Anon | s'.basket[u] = s.basket[u]) &&
				(s'.basket[Anon] = NoData)
		)
	}
}

//EnterPayment: remove item from basket and add to 
fact {
	all s: State, s': s.next{
		EnterPayment in s'.action implies 
		(
		s'.basket[s'.user] = (s.basket[s.user] - s'.showDB) &&
		s'.itemPayed[s'.user] = (s.itemPayed[s.user] + s'.showDB) &&
				(all u : User | (u != s'.user) implies s'.basket[u] = s.basket[u]) &&
				(all u : User | (u != s'.user) implies s'.itemPayed[u] = s.itemPayed[u])
		)
	}
}

fact {
	all s: State, s': s.next{
		ConfirmOrder in s'.action implies 
		(
		s'.itemShipped[s'.user] = (s.itemShipped[s.user] + s'.showDB) &&
				(all u : User | (u != s'.user) implies s'.itemShipped[u] = s.itemShipped[u]) 
		)
	}
}


//If not AddItem nor Login nor EnterPayment then do not update basket
fact {
	all s: State, s': s.next{
		all act : Action - Login - AddItem - EnterPayment | act in s'.action implies (
			all u : User |  s'.basket[u] = s.basket[u]
		)
	}
}

//If not ConfirmOrder do not modify itemShipped
fact {
	all s: State, s': s.next{
		ConfirmOrder not in s'.action implies (
			all u : User |  s'.itemShipped[u] = s.itemShipped[u]
		)
	}
}

//If not EnterPayment do not modify itemPayed
fact {
	all s: State, s': s.next{
		EnterPayment not in s'.action implies (
			all u : User |  s'.itemPayed[u] = s.itemPayed[u]
		)
	}
}


// =============== End Basket Handling =============




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
	s'.AJAX = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.noAttack = NoData &&
	s'.edit = NoData
}

pred Logout[s, s' : State]{
	AnonSession not in s.grant &&	
	s'.action = Logout &&
	s'.user = Anon &&
	//Controls' Predicates
	s'.grant = AnonSession &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	s'.AJAX = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.writeDB = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.noAttack = NoData &&
	s'.edit = NoData 
}

pred AddItem[s, s' : State]{
	one i : Item |
	s'.action = AddItem &&
	s'.user = s.user &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	s'.AJAX = NoData &&
	//Web applications' Events
	s'.showDB = i &&
	s'.writeDB = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.noAttack = NoData &&
	s'.edit = NoData
}

pred EnterPayment[s, s' : State]{
	one u : User-Anon | one i : s.basket[u] - NoData |
	s.grant = u.session &&
	s'.action = EnterPayment &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	s'.AJAX = NoData &&
	//Web applications' Events
	s'.showDB = i &&
	s'.writeDB = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.noAttack = NoData &&
	s'.edit = NoData
}

pred ConfirmOrder[s, s' : State]{
	one u : User-Anon | one i : s.itemPayed[u] - NoData |
	s.grant = u.session &&
	s'.action = ConfirmOrder &&
	s'.user = u &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	s'.AJAX = NoData &&
	//Web applications' Events
	s'.showDB = i &&
	s'.writeDB = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.noAttack = NoData &&
	s'.edit = NoData
}


assert OneOrderForOnePayment {
	no s : State |  some s' : State {
	ConfirmOrder in s.action &&
	ConfirmOrder in s'.action &&
	s.user = s'.user &&
	s.showDB in s'.showDB &&
	lt[s, s']
	}
}

//check OneOrderForOnePayment for 6



assert CheckPayment {
	no s : State | some d : Payment | some s' : State| some x : User{
	d not  in s.checked &&
	s.grant = x.session &&
	ConfirmOrder in s'.action &&
	lt[s, s']
	}
}
check CheckPayment for 3 State, 2 User, 15 Data
