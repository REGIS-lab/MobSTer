import sys
import string
import re
import os
from os import path
import collections
from collections import OrderedDict
from collections import defaultdict
import sys
import argparse 
import base64

# sys.path.insert(0, '/F_Modules/')
import f_Config
sys.path.append(r'F_Modules')
from f_ExtractCE import *
from f_AttackPhase import *
from f_formHandling import *
from f_ActionBrowsing import *

sys.path.append(r'F_Instantiation')
from actions_attacks import *

parser = argparse.ArgumentParser()
parser.add_argument('Name', help='indentifies which model or traces-file has to be tested')
args = parser.parse_args()
fileName  = args.Name

execution = None


#Data = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(str))))

#check if the file is an Alloy model
for file in os.listdir("F_AlloyModels"):
	if fileName+'.als' == file:
		execution = "model"
		f_Config.AlloyModel = fileName
		AlloyModel = fileName
if execution != "model":
	#check if the file is in the traces folder 
	for file in os.listdir("F_AlloyTraces"):
		if fileName+'.txt' == file:
			execution = "traces"

if execution == "model":
	AlloyModel = f_Config.AlloyModel
	# call Alloy for the generation oof the CE(S)
	print '** Run Alloy on model ' + AlloyModel
	cmd = ['java', '-cp', 'Alloy4.2/alloyMultipleTraces.jar', 'edu.mit.csail.sdg.alloy4whole.AllTraces', 'F_AlloyModels/'+AlloyModel+'.als']
	proc = subprocess.call(cmd)

	f = open('F_AlloyModels/'+AlloyModel+'.als')
	modelContent = f.readlines()
	f.close()

	modelGoal = []
	for i in range(0,len(modelContent)):
		if 'check' in modelContent[i] and '//check' not in modelContent[i]:
			tempGoal = modelContent[i].partition('check ')[2].partition(' for')[0]
			if tempGoal not in modelGoal:
				modelGoal.append(tempGoal.strip())
	f_Config.goal = modelGoal

	for i in range(0,len(f_Config.goal)-1):
		if f_Config.goal[i]=='' :
			del f_Config.goal[i]
	for i in range(0,len(modelGoal)):
		f_Config.fileName = "F_AlloyTraces/"+AlloyModel+"-"+modelGoal[i]+".txt"


if execution == "traces":
	f_Config.fileName = "F_AlloyTraces/"+fileName+".txt"
	AlloyModel = fileName.partition("-")[0]
	f_Config.AlloyModel = AlloyModel.strip()
	


print '** Exctracting info from the Attack traces'

# Extract information from the CE(s)
extractInfo()

# print f_Config.fileName

	
# preparing the dictionary for the Attack phase
InstVal = defaultdict(list) # InstVal contains the relation between actions and attacks
for key, value in IL:
    InstVal[key].append(value)
f_Config.InstVal = InstVal


skolem = f_Config.skolem

# i_skolem = 0 # counter for C_i
total_skolem = len(skolem) 

for i in range(0,len(f_Config.traces)):
	print 'Trace '+str(i)
	print f_Config.traces[i]
	print skolem[i]


print '** Test of the application'
for i in range(0,len(f_Config.traces)):
	f_Config.shift = 0
	# if f_Config.AlloyModel=='WebGoat' or f_Config.AlloyModel=='ChainedAttack' or f_Config.AlloyModel=='HRUModelv2':
	if len(skolem[i])>3:
		exec_actions(f_Config.traces[i],skolem[i],i,'More','Attack','None')
	else:
		exec_actions(f_Config.traces[i],skolem[i],i,'No','Attack','None')
	# else:	
	# 	if len(skolem[i])>3:
	# 		exec_actions(f_Config.traces[i],skolem[i],i,'More','Attack','None')
	# 	else:
	# 		exec_actions(f_Config.traces[i],skolem[i],i,'No','Attack','None')
