import sys
import string
import re
import os
from os import path
from collections import defaultdict
import subprocess
import base64
import requests
import json

from f_ExtractCE import *
from f_AttackPhase import *
from f_dataExtractor import *
from f_formHandling import *
import f_Config
# from f_ActionBrowsing import *

sys.path.append(r'F_Instantiation')
from payloads import *



URL = ''
current_URL = ''
Method = ''
Header = {}
cookie = {}
variables = {}
SSL_auth = ()

targetField = ''
CheckThis = []
loginNeeded = ''

f_Config.response = ''


def attackToUse():
	global URL
	global current_URL
	global Method
	global CheckThis
	global targetField
	global loginNeeded
	
	tempGoal = f_Config.goal[0]
	[payload, checkPayload] = attackToUsePayloads(tempGoal)
	
	targetField = f_Config.Attack_targetField
	Method = f_Config.Attack_Method
	
	return payload,checkPayload



def make_request(req_URL):
	global Method
	global Header
	global cookie
	global variables
	global SSL_auth
	requests.packages.urllib3.disable_warnings()

	
	if   Method=='GET' and any(variables) and any(cookie) and SSL_auth is not None:
		response = requests.get(req_URL, params=variables, cookies=cookie, auth=SSL_auth, verify=False)
	elif Method=='GET' and any(variables) and any(cookie):
		response = requests.get(req_URL, params=variables, cookies=cookie)


	elif Method=='GET' and any(variables) and SSL_auth is not None:
		response = requests.get(req_URL, params=variables, auth=SSL_auth, verify=False)
	elif Method=='GET' and any(variables):
		response = requests.get(req_URL, params=variables)

	elif Method=='GET' and any(cookie) and SSL_auth is not None:
		response = requests.get(req_URL, cookies=cookie, auth=SSL_auth, verify=False)
	elif Method=='GET' and any(cookie):
		response = requests.get(req_URL, cookies=cookie)

	elif Method=='GET' and SSL_auth is not None:
		response  = requests.get(req_URL, auth=SSL_auth, verify=False)
	elif Method=='GET':
		response = requests.get(req_URL)

	elif Method=='POST' and any(Header) and any(cookie) and SSL_auth is not None:
		response = requests.post(req_URL, data=variables, cookies=cookie, headers=Header, auth=SSL_auth, verify=False)
	elif Method=='POST' and any(Header) and any(cookie):
		response = requests.post(req_URL, data=variables, cookies=cookie, headers=Header)

	elif Method=='POST' and any(cookie) and SSL_auth is not None:
		response = requests.post(req_URL, data=variables, cookies=cookie, auth=SSL_auth, verify=False)
	elif Method=='POST' and any(cookie):
		response = requests.post(req_URL, data=variables, cookies=cookie)

	elif Method=='POST' and SSL_auth is not None:
		response = requests.post(req_URL, data=variables, auth=SSL_auth, verify=False)
	elif Method=='POST':
		response = requests.post(req_URL, data=variables)

	return response




def exec_actions(Trace, Skolem, TraceNum, MoreSkolem, MustAttack,responseText):
	requests.packages.urllib3.disable_warnings()
	i_action = 0
		
	global URL
	global current_URL
	global Method
	global Header
	global cookie
	global variables
	global SSL_auth

	global targetField
	global CheckThis
	global loginNeeded
	
	omit = 0 #for the actions that have to be skipped

	
	# Loading the configuration file (i.e., the configuration values)  
	# the file must have the same name of the model
	sys.path.append(r'F_Configurations')
	commandString = "from "+f_Config.AlloyModel+" import *"
	exec commandString

	f_Config.Data = Data
	f_Config.actionsURL = actionsURL
	SSL_auth = SSL_authentication
	
	if responseText!='None':
		resp = responseText

	if MustAttack=='Attack':
		print '\n\n--- Trace : \n    '+str(Trace)
		i_AttackCheck = 0

	if MustAttack=='Check':
		i_AttackCheck = 1
		cookie = f_Config.Cookie
		
		# if 'WebGoat' in f_Config.AlloyModel:
		# 	base64string = base64.encodestring('%s:%s' % ('guest','guest')).replace('\n', '')
		# 	Header["Authorization"]  = "Basic %s" % base64string
		# 	f_Config.Header["Authorization"] = Header["Authorization"]
			

	if i_AttackCheck == 0 : # we enter in this branch only for first call 
	#	
	# BEGIN NoAction
	#	
		current_action  = 'NoAction' # Get the first action (i.e., NoAction)
		current_URL = starting_URL # starting_URL is saved in the configuration file 
		
		if MoreSkolem == 'More':
			currentUser = Skolem[3]
		else :
			currentUser = Skolem[2]
		print '-- Starting with user: '+currentUser
		print '   URL: ' + current_URL
		
		# GET of the starting page 
		try:
			if set_cookie != '':
				cookie = set_cookie
				f_Config.Cookie = set_cookie
				f_Config.response = requests.get(current_URL, cookies=cookie)
			else :
				if cookie != '':
					f_Config.response = requests.get(current_URL, cookies=cookie)
				else : 
					f_Config.response = requests.get(current_URL)
		except :
			#
			# for older versions of requests use:
			# $ pip install --force-reinstall requests[security]
			#
			e = sys.exc_info()[0]
			
			if 'SSLError' in str(e):
				print '---- [Debug] SSL connection'
				s = requests.Session()
				f_Config.response  = s.get(current_URL, verify=False, auth=SSL_auth)

			else :	
				print 'First action not reachable. '+str(e) + ' on line {}'.format(sys.exc_info()[-1].tb_lineno)
				exit(0)
		
		resp = f_Config.response
		
		
		try:
			if resp.headers['set-cookie'] :
				newCookie=resp.headers['set-cookie']
				cookie = {newCookie.partition('=')[0]:newCookie.partition('=')[2]}
				print '--- [Debug] New cookie: '+ str(cookie)
		except :
			None
			#print '     [Debug] No cookie received'
			
		try :
			if resp.request.headers['Cookie']: # if a redirect has accured 
				newCookie = resp.request.headers['Cookie']
				splitCookie = newCookie.split(';')
				for i in range(0,len(splitCookie)):
					cookie[splitCookie[i].partition('=')[0]] = splitCookie[i].partition('=')[2]
				#print '--- [Debug] New cookie: '+ str(cookie)
		except :
			None
		
		if 'DVWAHRU' in f_Config.AlloyModel:
			cookie['security']='low'
			f_Config.Cookie=cookie
		
		f_Config.Cookie = cookie
		
		i_action = i_action + 1
	#	
	# END NoAction
	#
	
	Done = 'Continue'
	while Done == 'Continue':   
	#	
	# BEGIN -- Action
	#
		current_action = Trace[i_action]
		current_URL = starting_URL

		# Check if we have reached an action of interest (i.e., a Skolem)
		
		# For every action in the trace (different from "NoAction") untill A_i
		print '-- '+current_action +':'

		# qui le old action avevano le info su "action" in "actionsURL[current_action]"
		#
		#if current_action != Skolem[i_AttackCheck]: 
		# if  actionsURL[current_action] != None :
		# 	current_URL = starting_URL+actionsURL[current_action]
			

		# Test if we have to retrieve the page containing the functionality
		
		for act1, act2 in views.items() :
			if act2 == current_action and act1 == Trace[i_action-1]:
				omit = 1
		if omit :
			print "   [Debug] Action to be omitted"
			# ADD the get of the page ?
			omit = 0
			i_action = i_action + 1
			continue
		
		
		if current_action != Trace[int(Skolem[0])] and int(Skolem[0]) != i_action:
		# Execution of the functionality
		
			if actionsLabel[current_action]=='Link':
				resp = requests.get(current_URL)
				f_Config.response = resp
				i_action = i_action + 1
				continue

			if actionsLabel[current_action]=='GP':
				current_URL = starting_URL+actionsURL[current_action]
				Method = 'GET'
				try:
					f_Config.response = make_request(current_URL)
				except e:
					print 'Action '+current_action+' not reachable. '+str(e) + ' on line {}'.format(sys.exc_info()[-1].tb_lineno)
					exit(0)	
				
				
			
			resp = f_Config.response
			
			dataFromPage = extractData(resp.text)
			inputsFromPage = dataFromPage[0]['inputs']
			
			saveDataValues(inputsFromPage,TraceNum,i_action,Skolem)
			formToUse = selectForm(dataFromPage,current_action)
			variables = fillInputs(formToUse['inputs'],TraceNum,i_action,Skolem,actionsLabel[current_action])
			Method = formToUse['method']
			
			resp = make_request(current_URL)
			variables.clear()
			f_Config.response = resp
			
			try:
				if resp.headers['set-cookie']:
					newCookie=resp.headers['set-cookie']
					splitCookie=newCookie.split(';')
					for i in range(0,len(splitCookie)):
						cookie[splitCookie[i].partition('=')[0]] = splitCookie[i].partition('=')[2]
					f_Config.Cookie = cookie
			except :
				None
			
			i_action = i_action + 1
			
		elif i_AttackCheck == 0 : # functionality used for the attack phase
			print '-- '+current_action+' (Attack Phase)'

			responseWithValues = resp.text
			
			attack_results = []
			InstVal = f_Config.InstVal


			#
			# Here we set the parameter of the attacks
			# the attacks are hard coded but a proper implementation 
			# of of an authomatic engine is possible 
			#
			payloadsToBeUsed,CheckThis = attackToUse()
					
			if payloadsToBeUsed is None:
				print '--- Instantiation library for the specified goal not fount'
				return 1
			
			
			
			
			if actionsLabel[current_action]=='GP':
				current_URL = starting_URL+actionsURL[current_action]
				Method = 'GET'
				try:
					f_Config.response = make_request(current_URL)
				except e:
					print 'Action '+current_action+' not reachable. '+str(e) + ' on line {}'.format(sys.exc_info()[-1].tb_lineno)
					exit(0)
			URL = current_URL
			# ------------------------------------------------------------
			for i in range(0,len(payloadsToBeUsed)):
			# ------------------------------------------------------------
				print '\n\nTrying payload nr ' + str(i)+' : '+payloadsToBeUsed[i][0]
				# print '\n\n\n\n\n '+resp.text
				responseWithValues = f_Config.response.text
				dataFromPage = extractData(responseWithValues)
				
				if targetField != '':
					inputsFromPage = dataFromPage[0]['inputs']
					saveDataValues(inputsFromPage,TraceNum,i_action,Skolem)
					formToUse = selectForm(dataFromPage,current_action)
					variables = fillInputs(formToUse['inputs'],TraceNum,i_action,Skolem,actionsLabel[current_action])
					Method = formToUse['method']
	   				variables[targetField]=payloadsToBeUsed[i][0]
				elif f_Config.Attack_URL != '':
					URL = starting_URL+f_Config.Attack_URL+payloadsToBeUsed[i][0]
					Method = 'GET'
				else :
					URL = starting_URL+payloadsToBeUsed[i][0]
					Method = 'GET'

				
				print 'Attack: '+ str(URL)

				resp = make_request(URL)
				variables.clear()			

				if CheckThis is None:
					f_Config.checkContent = payloadsToBeUsed[i][1]
				else : f_Config.checkContent = ''

				
				try:
					subTrace = Trace[(int(Skolem[0])+1):(int(Skolem[2])+1)]

					newSkolem = [None]*len(Skolem)
					for iSkol in range(0,len(Skolem)):
						newSkolem[iSkol] = Skolem[iSkol]
					newSkolem[0]=str(int(Skolem[2])-int(Skolem[0])-1)
				except :
					None
					
				ok = 0
				if MoreSkolem != 'More' and CheckThis is not None:
					print '-- '+current_action+' (Check Phase 3)'
					if f_Config.checkContent == '' :
						for i in range(0,len(CheckThis)):
							if CheckThis[i] in resp.text:
								ok = 1							
					elif f_Config.checkContent in resp.text:
						ok = 1
					if ok==1 : 
						print '--- Success ' #+ f_Config.checkContent
					else :
						print '--- Fail '#+ f_Config.checkContent
						
				elif MoreSkolem!='More' and CheckThis is None:
					print '-- '+current_action+' (Check Phase 2)'
					if f_Config.checkContent == '' :
						for i in range(0,len(CheckThis)):
							if CheckThis[i] in resp.text:
								ok = 1
					elif f_Config.checkContent in resp.text:
						ok = 1

					if ok==1 : 
						print '--- Success ' #+ f_Config.checkContent
					else :
						print '--- Fail '#+ f_Config.checkContent
				else :
					f_Config.shift = int(Skolem[0])+1
					# f_Config.shift = int(Skolem[TraceNum][0])+1
					print '[Debug] Modifed Skolem'

					f_Config.Cookie = cookie
					exec_actions(subTrace, newSkolem, TraceNum, 'NO', 'Check', resp)
					cookie = f_Config.Cookie

					f_Config.shift = 0

				# raw_input(' Enter your input:')				
 			Done = 'Stop'
			

			
		elif i_AttackCheck == 1:  # functionality used for the check phase
			print '-- '+current_action+' (Check Phase)'

			cookie = f_Config.Cookie
			
			if actionsLabel[current_action]=='GP' or actionsLabel[current_action]=='Link':
				current_URL = starting_URL+actionsURL[current_action]
				print '----- '+str(current_URL)
				try:
					if any(f_Config.Cookie) and i_AttackCheck==1:
						cookie = f_Config.Cookie
						Method = 'GET'
						f_Config.response = make_request(current_URL)
						# f_Config.response = requests.get(current_URL, cookies=cookie)
					elif any(cookie):
						Method = 'GET'
						f_Config.response = make_request(current_URL)
						# f_Config.response = requests.get(current_URL, cookies=cookie)
					else:	
						f_Config.response = requests.get(current_URL)
				except e:
					print 'Action '+current_action+' not reachable. '+str(e) + ' on line {}'.format(sys.exc_info()[-1].tb_lineno)
					exit(0)
				resp = f_Config.response
			else :
				dataFromPage = extractData(resp.text)
				inputsFromPage = dataFromPage[0]['inputs']
				saveDataValues(inputsFromPage,TraceNum,i_action,Skolem)
				formToUse = selectForm(dataFromPage,current_action)
				variables = fillInputs(formToUse['inputs'],TraceNum,i_action,Skolem,actionsLabel[current_action])
				Method = formToUse['method']
				
				resp = make_request(URL)
				variables.clear()
			
			if f_Config.checkContent in resp.text:
				print '--- Success: ' + f_Config.checkContent
			else :
				print '--- Fail '+ f_Config.checkContent
				
				# # driver = webdriver.Firefox()
				# driver = webdriver.Firefox()
				# 
				# # Go to the correct domain
				# driver.get(current_URL+'404PaGeToBeReTrIeVeD')
				# # driver.get(current_URL)
				# driver.delete_all_cookies()
				# driver.add_cookie(cookie)
				# print driver.get_cookies()
				# print current_URL
				# driver.get(current_URL)
				# try:
				#     alert = driver.switch_to_alert()
				#     print alert.text
				#     alert.accept()
				# except:
				#     print "no alert to accept"
				# driver.close()

			return 1
			




			# base64string = base64.encodestring('%s:%s' % ('guest','guest')).replace('\n', '')
			# Header["Authorization"]  = "Basic %s" % base64string
			# f_Config.Header["Authorization"] = Header["Authorization"] 
			#f_Config.response = requests.get(current_URL, headers=Header, cookies=cookie)