import subprocess as sp
import os
import sys
import time as t

TIMEOUT_MIN=30.0 #in seconds idle time threshold
TIMEOUT_MAX=30.0 #in seconds maxing time threshold
INCREMENT_TIME=3.0 #in seconds
CPU_MIN_THRESHOLD=3 #decide thresholds idle? in 1/100 of a second of cpu time x86 per second| 3 -> 3% USER CPU usage
CPU_MAX_THRESHOLD=50 #decide thresholds maxing?
REMOVE_AFTER_STOP=True
FNULL = open(os.devnull, 'w')
#add logging statements?
try:
	if(sys.argv[1]=="-l"):
		log=True
		logfile=open(".killcontainers.log",'w')
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
		self.time0=0.0
		self.time="0h 0m 0s"

	def _getTime(self):
		seconds=round(t.time()-self.time0,1)
		self.time=str(int(seconds/3600.0))+"h "+str(int((round(seconds,0)%3600)/60.0))+"m "+ str(int(round(seconds,0))%60)+"s"

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
					printlog(str(self.time) + ": Container "+self.processes[i][0]+" is now running.")
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
					printlog(str(self.time) + ": Container "+self.processes[i][0]+" is not running any more.")
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
				if abs(user-self.processes[i][4])<=CPU_MIN_THRESHOLD*INCREMENT_TIME:
						self.processes[i][2]+=INCREMENT_TIME
				else:
						self.processes[i][2]=0.0
				if abs(user-self.processes[i][4])>=CPU_MAX_THRESHOLD*INCREMENT_TIME:
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
				if(self.processes[i][2]>=TIMEOUT_MIN):
					sp.call(["docker","stop",self.processes[i][0]], stdout=FNULL, stderr=sp.STDOUT)
					printlog(str(self.time) + ": Container "+self.processes[i][0]+" has been stopped for being idle for " + str(TIMEOUT_MIN/60.0) + " minutes.")
					if REMOVE_AFTER_STOP:
						sp.call(["docker","rm",self.processes[i][0]], stdout=FNULL, stderr=sp.STDOUT)
						printlog(str(self.time) + ": Container "+self.processes[i][0]+" has been deleted.")
					del self.processes[i]
				elif(self.processes[i][3]>=TIMEOUT_MAX):
					sp.call(["docker","stop",self.processes[i][0]], stdout=FNULL, stderr=sp.STDOUT)
					printlog(str(self.time) + ": Container "+self.processes[i][0]+" has been stopped for exceeding max cpu use for " + str(TIMEOUT_MAX/60.0) + " minutes.")
					if REMOVE_AFTER_STOP:
						sp.call(["docker","rm",self.processes[i][0]], stdout=FNULL, stderr=sp.STDOUT)
						printlog(str(self.time) + ": Container "+self.processes[i][0]+" has been deleted.")
					del self.processes[i]
			except IndexError:
				pass
	def _usersRunning(self):
		userList=str(self.time)+": "
		for i in range(0,len(self.processes)):
			if i+1==len(self.processes):
				userList+=(self.processes[i][0])[8:]+"."
			else:
				userList+=(self.processes[i][0])[8:]+", "
		printlog(userList)

	def run(self):
		self.time0=t.time()
		while True:
			self._usersRunning()
			self._processesCheck()
			self._usageCheck()
			self._kill()
			self._getTime()
			#print(self.processes)
			t.sleep(INCREMENT_TIME)

def main():
	PS=processes()
	PS.run()

if __name__=="__main__":
	main()
