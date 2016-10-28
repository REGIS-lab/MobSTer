import sys
import string
import re
import os
from os import path
from collections import defaultdict
import f_Config
import subprocess
import httplib2
import urllib
import httplib
import urlparse

sys.path.append(r'F_Instantiation')
from payloads import *




def attackToUsePayloads(modelGoal):
	
	if	modelGoal  == 'StoredXSS':
		if f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = 'snippet'
			f_Config.Attack_URL='newsnippet2?'
			f_Config.Attack_Method='GET'
		elif f_Config.AlloyModel=='ChainedAttackHRU':
			f_Config.Attack_targetField = 'surname'
			f_Config.Attack_URL=''
			f_Config.Attack_Method='POST'
		elif f_Config.AlloyModel=='WebGoat_XSS_1':
			f_Config.Attack_targetField='address1'
			f_Config.Attack_URL=''
			f_Config.Attack_Method='POST'
		elif f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'mtxMessage'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
		return S_XSS,None
	
	elif modelGoal  == 'StoredXSSaimed':
		if f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = 'color'
			f_Config.Attack_URL='saveprofile'
			f_Config.Attack_Method='GET'
		return S_XSS,None
	
	elif modelGoal  == 'urlXSS':
		if f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = ''
			f_Config.Attack_URL=''
			f_Config.Attack_Method='GET'
		return S_XSS,None
				
	elif modelGoal  == 'XSScheck':
		if f_Config.AlloyModel=='WebGoat_XSS_1':
			f_Config.Attack_targetField='search_name'
			f_Config.Attack_URL=''
			f_Config.Attack_Method='POST'
		return S_XSS,None
		

		
	elif modelGoal == 'XSS' :
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'name'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='GET'
		elif f_Config.AlloyModel=='WebGoat_XSS_2':
			f_Config.Attack_targetField = 'field1'
			f_Config.Attack_URL = ''
			f_Config.checkContent = ''
			f_Config.Attack_Method='POST'
		return S_XSS,None

	elif modelGoal == 'FileAccessCommandInjection':
		if f_Config.AlloyModel=='WebGoat_InjectionFlaws_1':
			f_Config.Attack_targetField = 'HelpFile'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
		return S_CommInj,S_WebGoatCongrats
		
	elif modelGoal == 'SQLInj':
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'id'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='GET'
			return S_SQLInj,S_SQLInj_CheckThis
		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_2":
			f_Config.Attack_targetField = 'station'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_SQLInj,S_WebGoatCongrats
 		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_4":
 			f_Config.Attack_targetField = 'Username'
 			f_Config.Attack_URL = ''
 			f_Config.Attack_Method='POST'
 			return S_SQLInj,S_WebGoatCongrats			
		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_5":
			f_Config.Attack_targetField = 'account_name'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_SQLInj,S_WebGoatCongrats
		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_6":
			f_Config.Attack_targetField = 'employee_id'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_SQLInj,S_WebGoatCongrats 

	elif modelGoal == 'BypassLoginSQL':
		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_6":
			f_Config.Attack_targetField = 'password'
			# f_Config.Attack_targetField = 'employee_id'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_SQLInj,S_WebGoatCongrats2 # S_SQLInj_BypassLoginWG
		elif f_Config.AlloyModel=='ChainedAttackHRU':
			f_Config.Attack_targetField = 'password'
			f_Config.Attack_URL=''
			f_Config.Attack_Method='POST'
			return S_SQLInj,P_B_F_CheckThis

	elif modelGoal == 'SQLInjFileSystem':
		if f_Config.AlloyModel=="WebGoat_InjectionFlaws_3":
			f_Config.Attack_targetField = 'username'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return SQLInjFS,S_WebGoatCongrats
				
	elif modelGoal == 'XSS_FileUpload':
		if f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = 'upload_file'
			f_Config.Attack_URL='upload.gtl'
			f_Config.Attack_Method='POST'
			return XSS_FileUpl,XSS_FileUpl_CheckThis
			
	elif modelGoal == 'FileAccess':
		if f_Config.AlloyModel=="WebGoat_AccessControl_1":
			f_Config.Attack_targetField = 'File'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_FileInclusion,S_WebGoatCongrats

	elif modelGoal == 'GuessedId':
		if f_Config.AlloyModel=="WebGoat_AccessControl_2":
			f_Config.Attack_targetField = 'employee_id'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_guesesdID,S_Guessed_Congrats

	elif modelGoal == 'AdminAction':
		if f_Config.AlloyModel=="WebGoat_AccessControl_2":
			f_Config.Attack_targetField = 'employee_id'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_ID_toBeDeleted,S_WebGoatCongrats

	elif modelGoal == 'AJAXdisabled':
		if f_Config.AlloyModel=="WebGoat_AJAXSecurity_1":
			f_Config.Attack_targetField = 'key'
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='POST'
			return S_keys,S_WebGoatCongrats

	elif modelGoal == 'AJAXxss':
		if f_Config.AlloyModel=="WebGoat_AJAXSecurity_2":
			f_Config.Attack_targetField = 'field1'
			f_Config.Attack_URL = ''
			f_Config.checkContent = ''
			f_Config.Attack_Method='POST'
			return S_AJAXxss,S_WebGoatCongrats
		elif f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = ''
			f_Config.Attack_URL='uid='
			f_Config.Attack_Method='GET'
			return S_AJAXxss,None

	elif modelGoal == 'PasswordBruteForce' :
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'password'
			f_Config.Attack_URL = 'vulnerabilities/brute/'
			f_Config.Attack_Method='POST'
		elif f_Config.AlloyModel=='ChainedAttack':
			f_Config.Attack_targetField = 'password'
			f_Config.Attack_URL='http://demeo.eu/tesi/index.php'
			f_Config.Attack_Method='POST'
		elif f_Config.AlloyModel=='Gruyere':
			f_Config.Attack_targetField = 'pw'
			f_Config.Attack_URL='http://127.0.0.1:8008/43481629/login'
			f_Config.Attack_Method='GET'
		######
		# change with correct info
		#####
		elif f_Config.AlloyModel=='WebGoatHRU':
			f_Config.Attack_targetField='password'
			f_Config.Attack_URL='http://127.0.0.1:8080/WebGoat/attack?Screen=20&menu=900&action=Login'
			f_Config.Attack_Method='POST'

		return P_B_F,P_B_F_CheckThis
		
	elif modelGoal == 'CommandExec':
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'ip'
			f_Config.Attack_URL = 'vulnerabilities/exec/#'
			f_Config.Attack_Method='POST'
			return S_CommInj,S_CommInj_CheckThis

	elif modelGoal == 'FileInclusion':
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = ''
			f_Config.Attack_URL = 'vulnerabilities/fi/?page='
			f_Config.Attack_Method='GET'
			return S_FileInclusion,S_FileInclusion_CheckThis
		if f_Config.AlloyModel=='GruyereHRU':
			f_Config.Attack_targetField = ''
			f_Config.Attack_URL=''
			f_Config.Attack_Method='GET'
			return S_FileInclusion,S_FileInclusion_CheckThis
		if f_Config.AlloyModel=="WebGoat_InsecureConfiguration":
			f_Config.Attack_targetField = ''
			f_Config.Attack_URL = ''
			f_Config.Attack_Method='GET'
			return S_FileInclusion,S_WebGoatCongrats
				
	elif modelGoal == 'FileUpload':
		if f_Config.AlloyModel=='DVWAHRU':
			f_Config.Attack_targetField = 'uploaded'
			f_Config.Attack_URL = 'vulnerabilities/upload/#'
			f_Config.Attack_Method='POST'
			return XSS_FileUpl,XSS_FileUpl_CheckThis
							
	return None,None