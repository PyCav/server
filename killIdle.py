import subprocess as sp

class processes:
	def __init__():
		self.processes=[]

	def getRunning():
	        dockerps=sp.Popen(["docker","ps","-a","-f","\"status=running\""],stdout=sp.PIPE)
	        dockerps= str(dockerps.stdout.read()).replace("\'", "").replace("\\n","\n")[1:]
	        ps=[]
	        for c in range(0,len(dockerps)):
	                if(dockerps[c]=="\n"):
	                        dockerps=dockerps[c+1:]
	                        break
	        start=0
	        for c in range(0,len(dockerps)):
	                if(dockerps[c]=="\n"):
	                        ps.append([dockerps[start:c]])
	                        start=c+1
	        for i in range(0,len(ps)):
	                ps[i][0]=ps[i][0][ps[i][0].find("jupyter"):len(ps[i][0])]
	                ps[i].append(sp.Popen(["docker", "inspect", "--format","\'{{ .State.Pid }}\'",ps[i][0]],stdout=sp.PIPE))
	                ps[i][1]=int(''.join(filter(lambda x: x.isdigit(),str(ps[i][1].stdout.read()))))
	                ps[i].append(True) #not idle
	        return ps
	def processesCheck():
		ps=getRunning()
		isNew= True
		#remove exited containers from 
		for i in range(0,len(self.ps)):	
			#check if new process
			isNew= True
			#check if process is still running if it already exists
			for j in range(0,len(self.processes)):
				if(ps[j][1]==self.processes[i][1]):
					isNew=0
			if isNew:
				processes.append(ps[i])
	def idleCheck():
		pass
	def kill():
		#if idle:
			#kill
		pass
def main():
	ps=getRunning()

	
main()
print(processes)