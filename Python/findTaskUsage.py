
## Execute Anadonda powershell Promt
## cd D:\Documents\AXI_VIP\dev\tvip-axi\Python
##  python.exe .\findTaskUsage.py

import re

print ("Getting function or task usage in the file")

class ParseFunctionsTasks (object):

	def __init__(self, namesList="namesList"):
		self.namesList=namesList
		
	def readNamesList(self):
		with open(self.namesList) as f:
			self.func_taskNames = f.read().splitlines()	
		#	print (self.func_taskNames)
	
	def getFunctions(self):
		#protected virtual function bit get_write_data_last_value(bit valid);
		resList=[]
		for each in self.func_taskNames:
			#print (each)
			m=re.match(r".+\s+function\s+\w+\s+(\w+)\s*\(.+$", each)
			if m:
#				print ((each), "==>", m.group(1) )
				resList.append(m.group(1))
				
		print ("==> Functions <== \n", resList)		
		return resList
		
	def getTasks(self):
		#protected virtual function bit get_write_data_last_value(bit valid);
		resList=[]
		for each in self.func_taskNames:
			#print (each)
			m=re.match(r".+\s+task\s+(\w+)\s*\(.+$", each)
			if m:
				print ((each), "==>", m.group(1) )
				resList.append(m.group(1))
				
		print ("==> Tasks <== \n", resList)		
		return resList	
	
class getCall :
		
			
		def __init__(self, namesList="namesList"):
			self.objNamesParser=ParseFunctionsTasks(namesList)
		
		
#### Main	
print ("=========== Main =================")

objNamesParser=ParseFunctionsTasks("tvip_axi_component_baseFunctions.txt")
objNamesParser.readNamesList()
objNamesParser.getFunctions()
objNamesParser.getTasks()


