import sys
import string
import re
import os
from os import path
from collections import defaultdict
import f_Config


def extractInfo():
	fileName = f_Config.fileName
	filePath = path.relpath(fileName)
	if(os.path.exists(filePath)==False):
	   sys.exit("File does not exist: " + filePath)
		
	solutions = [] # will contain the solutions blocks


	
	grantLocal = []
	goalLocal = []
	tracesLocal = []
	statesNumLocal = []
	skolemLocal = []

	wdbLocal = []
	sdbLocal = []
	checkedLocal = []
	editLocal = []
	wsdLocal = []
	ssdLocal = []
	wfsLocal = []
	sfsLocal = []
	pageIncLocal = []
	echoLocal    = []
	execcLocal   = []
	AJAXLocal	 = []
	
	m_action_id = ""
	m_block_id = "---INSTANCE---" # delimiter for each trace block
	m_state_id = 'this/State='
	m_grant_id = 'this/State<:grant=' 
	m_goal_id = "Command Check "
	m_traces_id = "this/State<:action"  
	m_skolem_id = "skolem $"
	m_wdb_id = 'this/State<:writeDB=' 
	m_sdb_id = 'this/State<:showDB' 
	m_checked_id = 'this/State<:checked=' 
	m_edit_id = 'this/State<:edit=' 
	m_wsd_id = 'this/State<:writeSD=' 
	m_ssd_id = 'this/State<:showSD=' 
	m_wfs_id = 'this/State<:writeFS=' 
	m_sfs_id = 'this/State<:showFS=' 
	m_pageInc_id = 'this/State<:PageIncluded=' 
	m_echo_id =  'this/State<:echo='    
	m_execc_id = 'this/State<:exec='   
	m_AJAX_id = 'this/State<:AJAX='

	m_users_id = 'this/User={'
	
	
	
	sep = ","
	
	f = open(filePath)
	file = f.readlines()
	f.close()
	
	# find the starting line of the blocks and the goal 
	blocks = []
	end = len(file)
	for i in range(0,end):
		if m_block_id in file[i]:
	   		blocks.append(i)
		if m_goal_id in file[i]:
		 	   		goal = file[i].partition(m_goal_id)[2].partition("for")[0]
	blocks.append(end) # add the final line (for the last solution block)

	sol_num = len(blocks) #number of solutions in the file
	
	if sol_num == 1:
		sys.exit("Error: no attack trace found")

	for i in range(0,blocks[1]):
	 	if m_action_id in file[i]:
	 		s = file[i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
	 		components = re.split("[."+sep+"!]", s) # split fields with commas as separators 
	 		for p in range(0,len(components)):  # correct component output
	 			components[p] = components[p].partition("$")[0]
	 			if p != 0 :
	 				components[p] = components[p].strip() #deletes the space at the beginning of the string

	# single blocks
	for j in range(0,sol_num-1):
		solutions.append(file[blocks[j]:blocks[j+1]])
	
	statNum = 0
	tempStat = 0
	tempSolution =[]
	
	for x in range(0,sol_num-1):

		for i in range(0,len(solutions[x])):
			if m_state_id   in solutions[x][i]:
				temp = solutions[x][i].partition("{")[2].partition("}")[0]
				res = re.split("[."+sep+"!]", temp) # split fields with commas as separators 
				statNum = len(res)
				f_Config.statesNum.append(statNum)

		for i in range(0,len(solutions[x])):
			# ---> Traces <---
			if m_traces_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					res[p] = res[p].partition("->")[2].partition("$")[0]
				f_Config.traces.append(res)
				
			grantLocal = [None]*int(statNum)
			if m_grant_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]

					if grantLocal[int(tempStat)] :
						tempData = [grantLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							grantLocal[int(tempStat)] = tempData
						else :
							grantLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							grantLocal[int(tempStat)] = tempData
						else :
							grantLocal[int(tempStat)] = ''
				f_Config.grant.append(grantLocal)

	
			checkedLocal = [None]*int(statNum)
			if m_checked_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if checkedLocal[int(tempStat)] :
						tempData = [checkedLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							checkedLocal[int(tempStat)] = tempData
						else :
							checkedLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							checkedLocal[int(tempStat)] = tempData
						else :
							checkedLocal[int(tempStat)] = ''
				f_Config.checked.append(checkedLocal)
		   
			editLocal = [None]*int(statNum)
			if m_edit_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if editLocal[int(tempStat)] :
						tempData = [editLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							editLocal[int(tempStat)] = tempData
						else :
							editLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							editLocal[int(tempStat)] = tempData
						else :
							editLocal[int(tempStat)] = ''
				f_Config.edit.append(editLocal)

			wdbLocal = [None]*int(statNum)
			if m_wdb_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if wdbLocal[int(tempStat)] :
						tempData = [wdbLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							wdbLocal[int(tempStat)] = tempData
						else :
							wdbLocal[int(tempStat)] = ''
		   			else:
		   				tempData = res[p].partition("->")[2].partition("$")[0]
		   				if tempData != 'NoData': 
		   					wdbLocal[int(tempStat)] = tempData
		   				else :
		   					wdbLocal[int(tempStat)] = ''
		   		f_Config.wdb.append(wdbLocal)

				
			wsdLocal = [None]*int(statNum)
			if m_wsd_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if wsdLocal[int(tempStat)] :
						tempData = [wsdLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							wsdLocal[int(tempStat)] = tempData
						else :
							wsdLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							wsdLocal[int(tempStat)] = tempData
						else :
							wsdLocal[int(tempStat)] = ''
				f_Config.wsd.append(wsdLocal)

			wfsLocal = [None]*int(statNum)
			if m_wfs_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if wfsLocal[int(tempStat)] :
						tempData = [wfsLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							wfsLocal[int(tempStat)] = tempData
						else :
							wfsLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							wfsLocal[int(tempStat)] = tempData
						else :
							wfsLocal[int(tempStat)] = ''
				f_Config.wfs.append(wfsLocal)
		
			sdbLocal = [None]*int(statNum)
			if m_sdb_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 

				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]

					if sdbLocal[int(tempStat)] :
						tempData = [sdbLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							sdbLocal[int(tempStat)] = tempData
						else :
							sdbLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							sdbLocal[int(tempStat)] = tempData
						else :
							sdbLocal[int(tempStat)] = ''
				f_Config.sdb.append(sdbLocal)
				
			ssdLocal = [None]*int(statNum)
			if m_ssd_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if ssdLocal[int(tempStat)] :
						tempData = [ssdLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							ssdLocal[int(tempStat)] = tempData
						else :
							ssdLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							ssdLocal[int(tempStat)] = tempData
						else :
							ssdLocal[int(tempStat)] = ''
				f_Config.ssd.append(ssdLocal)			
			
			sfsLocal = [None]*int(statNum)
			if m_sfs_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 

				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]

					if sfsLocal[int(tempStat)] :
						tempData = [sfsLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							sfsLocal[int(tempStat)] = tempData
						else :
							sfsLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							sfsLocal[int(tempStat)] = tempData
						else :
							sfsLocal[int(tempStat)] = ''
				f_Config.sfs.append(sfsLocal)

			pageIncLocal = [None]*int(statNum)
			if m_pageInc_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if pageIncLocal[int(tempStat)] :
						tempData = [pageIncLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							pageIncLocal[int(tempStat)] = tempData
						else :
							pageIncLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							pageIncLocal[int(tempStat)] = tempData
						else :
							pageIncLocal[int(tempStat)] = ''
				f_Config.pageInc.append(pageIncLocal)

			echoLocal = [None]*int(statNum)
			if m_echo_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if echoLocal[int(tempStat)] :
						tempData = [echoLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							echoLocal[int(tempStat)] = tempData
						else :
							echoLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							echoLocal[int(tempStat)] = tempData
						else :
							echoLocal[int(tempStat)] = ''
				f_Config.echo.append(echoLocal)

			execcLocal = [None]*int(statNum)
			if m_execc_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if execcLocal[int(tempStat)] :
						tempData = [execcLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							execcLocal[int(tempStat)] = tempData
						else :
							execcLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							execcLocal[int(tempStat)] = tempData
						else :
							execcLocal[int(tempStat)] = ''
				f_Config.execc.append(execcLocal)	

			AJAXLocal = [None]*int(statNum)
			if m_AJAX_id in solutions[x][i]:
				s = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				res = re.split("[."+sep+"!]", s) # split fields with commas as separators 
				for p in range(0,len(res)):  # correct component output
					tempStat = res[p].partition("$")[2].partition("->")[0]
					if AJAXLocal[int(tempStat)] :
						tempData = [AJAXLocal[int(tempStat)],res[p].partition("->")[2].partition("$")[0]]
						if tempData != 'NoData': 
							AJAXLocal[int(tempStat)] = tempData
						else :
							AJAXLocal[int(tempStat)] = ''
					else:
						tempData = res[p].partition("->")[2].partition("$")[0]
						if tempData != 'NoData': 
							AJAXLocal[int(tempStat)] = tempData
						else :
							AJAXLocal[int(tempStat)] = ''
				f_Config.AJAX.append(AJAXLocal)

			
			# ---> skolem <---
			if m_skolem_id in solutions[x][i]:
				temp = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				if 'State' in temp:
					temp = temp.partition("$")[2]
				else :
					temp = temp.partition("$")[0]
				try:
					f_Config.skolem[x].append(temp)
				except KeyError:
					f_Config.skolem[x] = [temp]

 			# ---> users <--- this/User={Jerry$0, Tom$0, Anon$0}
 			if m_users_id in solutions[x][i]:
 				temp = solutions[x][i].partition("{")[2].partition("}")[0] # extract the text between the curly brackets
				check = True
				temp2 = []
				while check==True : 
					temp2.append(temp.partition("$")[0])
					temp = temp.partition(" ")[2]
					if '$' in temp:
						check = True
					else :
						check = False

				f_Config.users = [temp2]

	# print '** wdb:'
	# print f_Config.wdb 
	# print '** edit:'
	# print f_Config.edit
	# print '** grant:'
	# print f_Config.grant
	# print '** Goal:'
	# print f_Config.goal 		
	# print '** Traces:'
	# print f_Config.traces 	
	# print '** Skolem:'
	# print f_Config.skolem
	# print '** States number:'
	# print f_Config.statesNum 
	# print '** sdbLocal:'
	# print f_Config.sdb 
	# print '** checked:'
	# print f_Config.checked
	# print '** ssd:'
	# print f_Config.ssd 
	# print '** wsd:'
	# print f_Config.wsd 
	# print '** reloaded:'
	# print f_Config.reloaded


	
	return "OK"