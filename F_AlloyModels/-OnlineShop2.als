open util/ordering[State]

//Begin Data Def

abstract sig Action {}
one sig ShowCatalog, ShowItem, AddItem, ShowBasket, FinalizeOrder, EnterPayment, EnterDelivery, ConfirmOrder, NoAction extends Action {}

abstract sig Data {}
abstract sig 	UserId, Name, Surname, BankAccount, Profile, ItemId, Description, ItemName, Text, Session, Payment extends Data {}
one sig NoData extends Data {}

//BankAccount, ItemId, Description, ItemName

one sig UsrUserId extends UserId {}
one sig UsrSession  extends Session {}
one sig UsrName extends Name {}
one sig UsrSurname extends Surname {}
//one sig UsrAddress extends Address {}
one sig UsrItemId extends ItemId {}
one sig UsrBankAccount extends BankAccount {}
one sig UsrDescription extends Description {}
one sig UsrItemName extends ItemName {}
one sig UsrText extends Text {}
one sig UsrProfile extends Profile{}
one sig UserPayment extends Payment{}


abstract sig Catalog extends Data {
	itemId: one ItemId
}
one sig UsrCatalog extends Catalog{} {
	itemId = UsrItemId
}

one sig UserItemId extends ItemId{} { }


abstract sig User{
	catalog: one Catalog,
	userId: one UserId,	
	profile: one Profile,
	payment: one  Payment,
	basket: one ItemId,
	session: one Session,
	initialK: set Data
}

one sig Usr extends User{}
{
	catalog = UsrCatalog
	userId = UsrUserId	
	profile = UsrProfile
	payment = UserPayment
	basket = UserItemId
	session = UsrSession
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
	grant: one Data,
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
	gainK: User -> set Data
}

fact{
	//User
	first.user = Usr
	//Controls' Predicates
	first.action = NoAction
	first.grant = UsrSession
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
	(all u:User | first.gainK[u] = NoData)
}

//End State Def

//-----------------------------------------------------------------
//-----------------------  Begin Transition Def  -----------------------
//-----------------------------------------------------------------



fact {
	all s: State, s': s.next, x:Action{
		x in s.action implies x not in s'.action
	}}

fact {
	all s: State, s': s.next{
		ShowCatalog[s,s'] or ShowItem[s,s'] or AddItem[s,s'] or 
		ShowBasket[s,s'] or FinalizeOrder[s,s'] or EnterPayment[s,s'] or 
		EnterDelivery[s,s'] or ConfirmOrder[s,s']
	}
}


fact {
	all s: State, s': s.next{
		ShowCatalog in s.action implies ShowItem in s'.action
	}}
fact {
	all s: State, s': s.next{
		ShowItem in s.action implies AddItem in s'.action
}}
fact {
	all s: State, s': s.next{
		AddItem in s.action implies ShowBasket in s'.action
}}
fact {
	all s: State, s': s.next{
		ShowBasket in s.action implies FinalizeOrder in s'.action}}
fact {
	all s: State, s': s.next{
		EnterDelivery in s.action implies ConfirmOrder in s'.action}}



fact {
	all s: State, s': s.next{
				s'.gainK[s.user] = (s.gainK[s.user] + s.showDB + s.showSD) &&
				(all u : User | (u != s.user) implies s'.gainK[u] = s.gainK[u])
	}
}


pred ShowCatalog[s, s' : State]{
	one u : User |  
	s'.action = ShowCatalog &&
//	s.grant = u.session &&
//	u.credential in u.initialK &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = s.checked + NoData&&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.catalog &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData 
}

pred ShowItem[s, s' : State]{
	one u : User | 
	s'.action = ShowItem &&
//	s.grant = u.session &&
	//Controls' Predicates
	s'.grant = u.session &&
	s'.checked = s.checked + NoData  &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = u.basket &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData
}



pred AddItem[s,s' : State]{
	one u : User |  
	//one i : s.showDB |
	//i in Id &&
	s.grant = u.session &&
	s'.action = AddItem &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked + NoData &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = u.basket &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData
}


pred ShowBasket[s,s' : State]{
	one u : User |  one i : s.edit |
	i in Profile &&
	s.grant = u.session &&
	s'.action = ShowBasket &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked + NoData&&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData&&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = u.basket &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData 
}


pred FinalizeOrder[s,s' : State]{
	one u : User | 
//	s.grant = u.session &&
	s'.action = FinalizeOrder &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked +  u.basket &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB = NoData &&
	s'.showDB =  NoData&&
	s'.writeDB = NoData &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = u.basket &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData 
}



pred EnterPayment[s,s' : State]{
	one u : User |  
//	s.grant = u.session &&
	s'.action = EnterPayment &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked + u.payment &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = u.payment &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData 
}

pred EnterDelivery[s,s' : State]{
	one u : User | 
	//one u : User |  one v : User |
	s.grant = u.session &&
	s'.action = EnterDelivery &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked +  u.profile &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData  &&
	s'.writeDB = u.profile &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData
}

pred ConfirmOrder[s,s' : State]{
	one u : User |  
	s.grant = u.session &&
	s'.action = ConfirmOrder &&
	//Controls' Predicates
	s'.grant = s.grant &&
	s'.checked = s.checked +  u.basket &&
	s'.PageIncluded = NoData &&
	s'.echo = NoData &&
	s'.exec = NoData &&
	//Web applications' Events
	s'.showDB =  NoData &&
	s'.writeDB = u.basket &&
	s'.edit = NoData &&
	s'.writeSD = NoData &&
	s'.showSD = NoData &&
	s'.writeFS = NoData &&
	s'.showFS = NoData &&
	s'.AJAX = NoData
}



assert CheckPaymentOLD {
	no s : State | some d : Payment | some x : User{
	d not  in s.checked &&
	s.grant = x.session &&
	ConfirmOrder in s.action
	}
}

assert CheckPayment {
	no s : State | some d : Payment | some s' : State{
	d not in last.checked &&
	NoData not in s.grant &&
	ConfirmOrder in last.action &&
	lt[s, s']
	}
}

check CheckPayment for 8 State, 1 User, 20 Data

/*
//Test Goal
run {
	ConfirmOrder in last.action} for 8 State, 3 User, 21 Data
*/
