starting_URL = 'http://127.0.0.1:8080/WebGoat/attack?Screen=22&menu=400' # Where the test starts

views = {}

Data = {}


Data['Guest']={
	'Item':{
		'QTY1' 	: '1',
		'QTY2' 	: '1',
		'QTY3' 	: '1',
		'QTY4' 	: '1'
		},
	'CC':{
		'field1': '123',
		'field2': '4128 3214 0002 1999'
		}
}

actions = {}
actionsURL = {
	'NoAction'  : '',
	'UpdateCart': '&SUBMIT=Update+Cart',
	'Purchase'	: '&SUBMIT=Purchase'
	}

actionsLabel = {	
	'NoAction' 	: None,
	'UpdateCart': None,
	'Purchase' 	: None
}


actionsProp = {	
	'NoAction'	: None,
	'UpdateCart': None,
	'Purchase'	: None
}

