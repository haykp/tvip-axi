
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
	
class getCall (object) :
		
			
		def __init__(self, namesList="namesList",systemVerilogFile="fileText" ):
			self.objNamesParser=ParseFunctionsTasks(namesList)
			self.objNamesParser.readNamesList()
			self.svFile=systemVerilogFile
			
		
		def start(self):
			self.functions= self.objNamesParser.getFunctions()
			self.tasks= self.objNamesParser.getTasks()
			return self.functions+self.tasks
		
		def readSVFile (self):
			with open(self.svFile) as f:
				self.svData = f.read().splitlines()			
			print (self.svData)
		
		def findFunctionsUsage(self):
		
			notUsedList=[]
			usedList=[]
			
			print ("Size of self.functions:", len(self.functions))
			i=0;
			
			for function in self.functions:
				#print (function)
				used=0;
				for line in self.svData:
					if function in line and ( not used):
						print ("Used:", function, "=> RTL=", line, "  :i=", i)
						i=i+1
						used=1;
						usedList.append(function)
				
				if (not used):
					notUsedList.append(function)
				
			print ("========== Used Functions ===============\n")
			print (usedList)
			print ("========== Not Used Functions ===============\n")
			print (notUsedList)

		def findTasksUsage(self):
		
			notUsedList=[]
			usedList=[]
			
			print ("Size of self.tasks:", len(self.tasks))
			i=0;
			
			for task in self.tasks:
				#print (function)
				used=0;
				for line in self.svData:
					if task in line and ( not used):
						print ("Used:", task, "=> RTL=", line, "  :i=", i)
						i=i+1
						used=1;
						usedList.append(task)
				
				if (not used):
					notUsedList.append(task)
			print ("========== Used Tasks ===============\n")
			print (usedList)
			print ("========== Not Used Tasks ===============\n")
			print (notUsedList)
			
#### Main	
print ("=========== Main =================")

#objNamesParser=ParseFunctionsTasks("tvip_axi_component_baseFunctions.txt")
#objNamesParser.readNamesList()
#objNamesParser.getFunctions()
#objNamesParser.getTasks()

#getCallObj = getCall(namesList="tvip_axi_component_baseFunctions.txt",
#					 systemVerilogFile="tvip_axi_master_write_driver.svh")
					 
#getCallObj = getCall(namesList="tvip_axi_component_baseFunctions.txt",
#					 systemVerilogFile="tvip_axi_slave_driver.svh")
					 
getCallObj = getCall(namesList="tvip_axi_component_baseFunctions.txt",
					 systemVerilogFile="tvip_axi_monitor_base.svh")					 
					 
getCallObj.start()
getCallObj.readSVFile()
getCallObj.findFunctionsUsage()
getCallObj.findTasksUsage()


