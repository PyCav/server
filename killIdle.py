#must test?
import subprocess as sp
import sys
import time as t

TIMEOUT=15.0*60.0 #in seconds
INCREMENT_TIME=3.0 #in seconds
CPU_MIN_THRESHOLD=None #decide thresholds?
CPU_MAX_THRESHOLD=None #decide thresholds?
REMOVE_AFTER_STOP=False #add flag?

#add logging statements?
try:
	if(sys.argv[1]=="-l"):
		log=True
		logfile=open(".killidleDocker.log",'w')
	else:
		log=False

except IndexError:
	log = False

def printlog(string):
	if log:
		logfile.write(string+"\n")
		print(string)
	else:
		print(string)

class processes:
	def __init__(self):
		self.processes=[] #index: 0=container_name, 1=container_id, 2=idle_time, 3=maxing_time, 4=cpu_time user, 5= cpu_time system
		self.time0=0
		self.time=0

	def _getTime(self):
		self.time=t.time()-self.time0

	def _getRunning(self):
		dockerps=sp.Popen(["docker","ps","-f","\"status=running\""],stdout=sp.PIPE)
		dockerps=str(dockerps.stdout.read()).replace("\'", "").replace("\\n","\n")[1:]
		ps=[]
		start=0
		for c in range(0,len(dockerps)):
				if(dockerps[c]=="\n"):
						dockerps=dockerps[c+1:]
						break
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
					self.processes[len(self.processes)-1].append(0.0)
					self.processes[len(self.processes)-1].append(0.0)
					self.processes[len(self.processes)-1].append(0.0)
					self.processes[len(self.processes)-1].append(0.0)
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

	#use system or user cpu usage?
	def _usageCheck(self):
		for i in range (0,len(self.processes)):
			with open("/sys/fs/cgroup/cpuacct/docker/"+self.processes[i][1]+"/cpuacct.stat",'r') as f:
				stats=f.readlines()
			user=int(''.join(filter(lambda x: x.isdigit(),stats[0])))
			system=int(''.join(filter(lambda x: x.isdigit(),stats[1])))
			try:
				if abs(user-self.processes[i][4])<=CPU_MIN_THRESHOLD:
						self.processes[i][2]+=INCREMENT_TIME
				else:
						self.processes[i][2]=0.0
				if abs(user-self.processes[i][4])>=CPU_MAX_THRESHOLD:
						self.processes[i][3]+=INCREMENT_TIME
				else:
						self.processes[i][3]=0.0
				self.processes[i][4]=user
				self.processes[i][5]=system
			except IndexError:
				pass

	def _kill(self):
		for i in range(0,len(self.processes)):
			try:
				if(self.processes[i][2]>=TIMEOUT):
					sp.call(["docker","stop",self.processes[i][0]])
					if REMOVE_AFTER_STOP:
						sp.call(["docker","rm",self.processes[i][0]])
					del self.processes[i]
				elif(self.processes[i][3]>=TIMEOUT):
					sp.call(["docker","stop",self.processes[i][0]])
					if REMOVE_AFTER_STOP:
						sp.call(["docker","rm",self.processes[i][0]])
					del self.processes[i]
			except IndexError:
				pass

	def run(self):
		self.time0=t.time()
		while True:	
			self._processesCheck()
			self._usageCheck()
			self._kill()
			self._getTime()
			print(self.processes)
			t.sleep(INCREMENT_TIME)

def main():
	PS=processes()
	PS.run()

if __name__=="__main__":
	main()
