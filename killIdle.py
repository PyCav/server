import subprocess as sp
import time as t
#kill resource intensive containers
#print output to logs?
TIMEOUT=15*60 #in seconds
INCREMENT_TIME=3 #in seconds
RM=False #remove containers after stopping them

class processes:
	def __init__(self):
		self.processes=[] #index: 0=container_name, 1=container_id, 2=idle_time, 3=cpu_time
		self.time0=0
		self.time=0
	def _getTime(self):
		self.time=t.time()-self.time0
#seperate formatting from code
	def _formatting(self):
		pass
	def _getRunning(self):
		dockerps=sp.Popen(["docker","ps","-f","\"status=running\""],stdout=sp.PIPE)
		dockerps=str(dockerps.stdout.read()).replace("\'", "").replace("\\n","\n")[1:]
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
				dockerid=(sp.Popen(["docker" ,"inspect","--format","\'{{.Id}}\'",ps[i][0]],stdout=sp.PIPE))
				dockerid=str(dockerid.stdout.read())[3:-4]
				ps[i].append(dockerid)
		return ps
	def _processesCheck(self):
		ps=self._getRunning()
		isNew= True
		StillRunning=False
		for i in range(0,len(ps)):	
			isNew= True
			for j in range(0,len(self.processes)):
				try:
					if(ps[j][1]==self.processes[i][1]):
						isNew=False
						break
				except IndexError:
					pass
			if isNew:
				try:
					self.processes.append(ps[i])
					self.processes.append(0.0)
					self.processes.append(0.0)
				except IndexError:
					pass
		for i in range(0,len(self.processes)):
			stillRunning=False
			for j in range(0,len(ps)):
				try:
					if(ps[j][1]==self.processes[i][1]):
						stillRunning=True
						break
				except IndexError:
					pass
			if(not stillRunning):
				try:
					del self.processes[i]
				except IndexError:
					pass
	#increment idle time reset to 0 if we get a usage spike over t period increment if not
	def _idleCheck(self):
		for ps in self.processes:
			cpuFile=open("/sys/fs/cgroup/cpuacct/docker/"+ps[1]+"cpuacct.usage",'r')
			
			cpuFile.close()

	def _kill(self):
		for i in range(0,len(self.processes)):
			if(self.processes[2]>=TIMEOUT):
				sp.call("docker","stop",self.processes[i][0])
				if RM:
					sp.call("docker","rm",self.processes[i][0])
	def run(self):
		self.time0=t.time()
		while True:	
			self._processesCheck()
			self._idleCheck()
			self._kill()
			self._getTime()
			print(self.processes)
			t.sleep(INCREMENT_TIME)
def main():
	PS=processes()
	PS.run()
main()
