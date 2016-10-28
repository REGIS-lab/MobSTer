import urllib
import httplib2
import urlparse
import lxml.html
from lxml import etree
from lxml.html import fromstring
from cStringIO import StringIO
import f_Config


tempVariables = {}
	
def fillInputs(inputs,i_traces,i_action,Skolem,actionsLabel):
	inputsToFill = []	
	shift = f_Config.shift
	targetData = ''
	targetUsr = ''
	
	# -------------------- --------------------- -------------------- 
	if f_Config.checked[i_traces][i_action+shift] and f_Config.checked[i_traces][i_action+shift]!='isAdmin':
		targetData = f_Config.checked[i_traces][i_action+shift]
	elif f_Config.edit[i_traces][i_action+shift]:
		targetData = f_Config.edit[i_traces][i_action+shift]
	elif f_Config.wdb[i_traces][i_action+shift]:
		targetData = f_Config.wdb[i_traces][i_action+shift]
	elif f_Config.wsd[i_traces][i_action+shift]:
		targetData = f_Config.wsd[i_traces][i_action+shift]
	elif f_Config.wfs[i_traces][i_action+shift]:
		targetData = f_Config.wfs[i_traces][i_action+shift]
	elif f_Config.pageInc[i_traces][i_action+shift]:
		targetData = f_Config.pageInc[i_traces][i_action+shift]
	elif f_Config.echo[i_traces][i_action+shift]:
		targetData = f_Config.echo[i_traces][i_action+shift]
	elif f_Config.execc[i_traces][i_action+shift]:
		targetData = f_Config.execc[i_traces][i_action+shift]
	elif f_Config.AJAX[i_traces][i_action+shift]:
		targetData = f_Config.AJAX[i_traces][i_action+shift]
	elif f_Config.sdb[i_traces][i_action+shift]:
		targetData = f_Config.sdb[i_traces][i_action+shift]
	elif f_Config.ssd[i_traces][i_action+shift]:
		targetData = f_Config.ssd[i_traces][i_action+shift]
	elif f_Config.sfs[i_traces][i_action+shift]:
		targetData = f_Config.sfs[i_traces][i_action+shift]
	elif f_Config.grant[i_traces][i_action+shift]:
		targetData = f_Config.grant[i_traces][i_action+shift-1]
	else :
		print "[Debug]: No data found to fill the form's fields"


	
	for i_users in range(0,len(f_Config.users[0])): #finding the user inside the data
		if f_Config.users[0][i_users] in targetData:
			targetUsr = f_Config.users[0][i_users]
	
	tempVariables.clear() # delete all the contents of the dictionary 
	print inputs
	# skip the actions and save the them directly
	for i_inputs in range(0,len(inputs)):
		inputType  = inputs[i_inputs][2] 
		inputValue = inputs[i_inputs][1]
		inputName  = inputs[i_inputs][0] 

		labelsToCheck = ['text','TEXT','password','textarea','hidden','select', 'radio', 'checkbox','file']
		labelsToCheck_2 = ['action', 'SUBMIT', 'submit', 'BUTTON', 'button']  #<---- indicators for buttons 
		
		if any(labels in inputType for labels in labelsToCheck):
			inputsToFill.append(inputName)
		else :
			# select the button to use for "check_action"
			check_action = f_Config.traces[i_traces][i_action+shift]

			if any(labels in inputType for labels in labelsToCheck_2) and inputName != 'None':
				if f_Config.actionsURL[check_action] in inputValue:
					tempVariables[inputName] = inputValue
				elif f_Config.actionsURL[check_action] in inputName: 
					tempVariables[inputName] = inputValue
				elif actionsLabel == 'GP':
					tempVariables[inputName] = inputValue
				elif f_Config.checked[i_traces][i_action+shift] == 'isAdmin':
					print '   [Debug] "isAdmin" action'
					tempVariables[inputName] = f_Config.traces[i_traces][i_action+shift]
				#
				# write a better management of GPs functionalities
				#

	#filling the variables
	for i_input in range(0,len(inputsToFill)):
		try:
			tempVariables[inputsToFill[i_input]] = f_Config.Data[targetUsr][inputsToFill[i_input]]
		except (KeyError, IndexError), e:
			print '   [Debug] Missing data "'+str(e)+'" for user "'+str(targetUsr)+'"'
		None
	return tempVariables


def selectForm(dataFromPage,check_action):
	for i_forms in range(0,len(dataFromPage)):
		form_i = dataFromPage[i_forms]
		for index in range(0,len(form_i['inputs'])):
			if form_i['inputs'][index][1] == None :
				continue # NON iterable item				
			if f_Config.actionsURL[check_action] in form_i['inputs'][index][1] :
				correctForm = form_i
	try: 
		if any(correctForm):
			None
	except (UnboundLocalError),e:	
		correctForm = form_i

	return correctForm
