import subprocess as sp
import time as t

MAX_IDLE_TIME=15*60 #in seconds
INCREMENT_TIME=3 #in seconds

class processes:
	def __init__(self):
		self.processes=[]
		self.idleTime=[]
		self.time0=t.time()

	def time(self):
		return t.time()-self.time0

	def getRunning(self):
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
			return ps
	def processesCheck(self):
		ps=getRunning()
		isNew= True
		StillRunning=False
		#remove exited containers from processes
		for i in range(0,len(self.ps)):	
			isNew= True
			for j in range(0,len(self.processes)):
				if(ps[j][1]==self.processes[i][1]):
					isNew=0
					break
			if isNew:
				self.processes.append(ps[i])
				self.idleTime.append(0.0)
		for i in range(0,len(self.processes)):
			stillRunning=False
			for j in range(0,len(self.ps)):
				if(ps[j][1]==self.processes[i][1]):
					stillRunning=True
			if(not stillRunning):
				del self.processes[i]
				del self.idleTime[i]
	#increment idle time reset to 0 if we get a usage spike over t period increment if not
	def idleCheck(self):
		pass
	def kill(self):
		#if idle:
			#kill
		pass
	def run(self):
		pass
def main():
	PS=processes()
	while True:
		PS.run()	

	
main()
