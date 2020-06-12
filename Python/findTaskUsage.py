
## Execute Anadonda powershell Promt
## cd D:\Documents\AXI_VIP\dev\tvip-axi\Python
## cd D:\Documents\AXI_VIP\dev\Python


print ("Getting function or task usage in the file")

class ParseFunctionsTasks (object):

	def __init__(self, namesList="namesList"):
		self.namesList=namesList
		
	def readNamesList (self):
		with open(self.namesList) as f:
			self.checkNames = f.read()	
			print (self.checkNames)
	
	def getFunctions (self):
		#for each in self.checkNames:
		#	print (each)
		return
	
	
	
#### Main	
print ("=========== Main =================")

objNamesParser=ParseFunctionsTasks("taskFunctionsList.txt")
objNamesParser.readNamesList()
objNamesParser.getFunctions()


