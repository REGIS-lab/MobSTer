import sys
import urllib
import httplib2
import urlparse
import lxml.html
from lxml import etree
from lxml.html import fromstring
from cStringIO import StringIO

import f_Config

# Defined in this module:
# 	def extractData(content)
# 	def saveDataValues(rawDataFromPage,i_traces,i_action)


# def formToString(form):
#   return lxml.html.tostring(form)


def extractData(content):
	toReturn=0
	inputs = []

	# list of forms
	html = lxml.html.fromstring(content)
	forms = html.forms

	formInfo = [dict() for x in range(0,len(forms))]
	
	for i in range(0,len(forms)) :
		temp_form = forms[i]

		formInfo[i]['method'] = str(temp_form.method)
		formInfo[i]['action'] = str(temp_form.action)

		# print 'method: ' + str(temp_form.method)
		# print 'action: ' + str(temp_form.action)
		# print 'form_values: ' + str(temp_form.form_values()) # extracted later on
		
		# Alternative method for fields extraction 
		# prova = temp_form.fields
		# print "---- fields"
		# for name, value in sorted(prova.items()):
		# 	print('%s = %r' % (name, value))


		broken_html = lxml.html.tostring(temp_form) #formToString
		
		parser = etree.HTMLParser()
		tree   = etree.parse(StringIO(broken_html), parser)
		
			
		inputs = []
		checkbox_options = {} # dict for the checkbox values
		radio_options = {}	  # dict for the radio values
		
		for child in tree.iter():
						
		 	if child.tag == "input":
				
				if str(child.get('type')) == "radio":
					if str(child.get('name')) in radio_options : # check if the key is already in the dict
						radio_options[str(child.get('name'))].append(child.get('value'))
					else :
						radio_options[str(child.get('name'))] = [child.get('value')]
				

				if str(child.get('type')) == "text" or str(child.get('type')) == "TEXT":
						inputs.append((str(child.get('name')), str(child.get('value')), str(child.get('type'))))
						

				elif child.get('type') == "checkbox":
					if str(child.get('name')) in radio_options :# check if the key is already in the dict
						checkbox_options[str(child.get('name'))].append(child.get('value'))
					else :
						checkbox_options[str(child.get('name'))] = [child.get('value')]
			
				elif True:	
					inputs.append((str(child.get('name')), str(child.get('value')), str(child.get('type'))))
			





			elif child.tag == "select":
				select_options = {}	  # dict for the select values 
				
				for opt in child:
					select_options[opt.text] = opt.get('value')
				inputs.append((str(child.get('name')), select_options, 'select'))


			elif child.tag == "textarea":
				inputs.append((str(child.get('name')), child.text, 'textarea'))


		if checkbox_options.keys():
			inputs.append((checkbox_options.keys(), checkbox_options, 'checkbox'))
		if radio_options.keys():
			inputs.append((radio_options.keys(), radio_options, 'radio'))

		# formInfo[i] = [(Name,Values,Type)]	
		formInfo[i]['inputs'] = inputs
		
	return formInfo




def saveDataValues(rawDataFromPage,i_traces,i_action,Skolem):
	shift = f_Config.shift
	targetUser = ''
	targetData = ''
	try: 
		if f_Config.wdb[i_traces][i_action+shift]:
			targetData = f_Config.wdb[i_traces][i_action+shift]	
		elif f_Config.checked[i_traces][i_action+shift]:
			targetData = f_Config.checked[i_traces][i_action+shift]
		elif f_Config.edit[i_traces][i_action+shift]:
			targetData = f_Config.edit[i_traces][i_action+shift]
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

		for i_users in range(0,len(f_Config.users[i_traces])): #finding the user inside the data
			if f_Config.users[i_traces][i_users] in targetData:
				targetUser = f_Config.users[i_traces][i_users]
		
		for i_data in range(0,len(rawDataFromPage)):
			rawDataType  = rawDataFromPage[i_data][2] 
			rawDataValue = rawDataFromPage[i_data][1]
			rawDataName  = rawDataFromPage[i_data][0]
			
			if (rawDataValue == None or rawDataValue == 'None'):
				continue
			
			
			typesToCheck_1 = ['text','TEXT','textarea','hidden','password','file']
			typesToCheck_2 = ['select', 'radio', 'checkbox']
			
			if (any(types in rawDataType for types in typesToCheck_1) and rawDataValue != None):
				try :
					if f_Config.Data[targetUser][rawDataName]: 
						None
				except (KeyError), e: 
					f_Config.Data[targetUser][rawDataName] = rawDataValue
			
			elif any(types in rawDataType for types in typesToCheck_2):
				options = rawDataValue.items()# returns[(key,value),...] 	
				try :
					if f_Config.Data[targetUser][rawDataName]: 
						None
				#if the value is not in in the dictionary an error is raised
				except (KeyError), e: 
					if len(options) == 1:
						f_Config.Data[targetUser][rawDataName] = options[0][1]
					else :
						print '   [Input Needed] for user "'+str(targetUser)+'". Select options for "'+str(rawDataName)+'":'
						for key_i in range(0,len(options)):
							print '      '+str(key_i)+' -- '+str(options[key_i][0])+' : '+ options[key_i][1]
						choice = raw_input("   Insert choice (numeric):")
					
						f_Config.Data[targetUser][rawDataName] = options[key_i][1]
						
	except (KeyError, IndexError), e:
		#if str(e) != '\'\'':
		print '   [Debug] Key Error '+str(e) + ' in "f_dataExtractor: saveDataValues(...)" on line {}'.format(sys.exc_info()[-1].tb_lineno)

	return True
		
		
		
#Links
# doc = parse('http://java.sun.com').getroot()
# for link in doc.cssselect('div.pad a'):
#     print '%s: %s' % (link.text_content(), link.get('href'))
