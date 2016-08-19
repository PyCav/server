#finds build status on docker hub

from bs4 import BeautifulSoup
import urllib.request as urllib

import sys,time

#docker hub status codes
status={10:"Success",3:"Building",0:"Queued",-1:"Failure"} 
url="https://hub.docker.com/r/jordanosborn/pycav/builds/"
token=""
DELTA_T=5 # in seconds
BUILD_TIME=30*60 # in seconds

#import os
#insert triggerbuild code here ?
#curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/namespace/name/trigger/token/
#insert docker rmi, pull commands here etc

def trigger_build(url,token):
	trigger_url=url.replace("r","u").replace("builds","trigger/"+str(token))
	#curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/namespace/name/trigger/token/
	pass

def build(name,dockerfile=""):
	pass

#smarten up using date built, if under a day pull that image
#smarten up time information

#properties for builds include updated, created, status, build_code, dockertag_name, cause
repo_updated=""

def countdown(t0):
	if (BUILD_TIME-(time.time()-t0))<=0:
		return 0
	else:
		return int(round(BUILD_TIME-(time.time()-t0)))

def fix_date(date):
	return date.replace("T"," ")[0:date.find(".")]

def find_property(string,property):
	if string == "created":
		string = "created_date"
	elif string == "updated":
		string = "last_updated"
	else:
		pass

	property_start=string.find(property)+len(property)+len('":')
	property_end=string[property_start:].find(',')+len(string[0:property_start])
	output=string[property_start:property_end].replace('"','')

	if property.find("status") != -1:
		output=status.get(int(output))
	elif string  == "last_updated" or string == "created_date":
		ouput=fix_date(output)
	return output

def format(soup_obj):
	global repo_updated
	data_starts_at='"lastUpdated"'
	data_ends_at='"AutoBuildSettingsStore"'
	string=str(soup_obj)
	string=string[string.find(data_starts_at):string.find(data_ends_at)]
	string=string.replace('{"id"','\n{"id"').replace("{","").replace("}","")
	#string=string.replace('"count"','\n"count"').replace('"RepoDetailsBuildsStore":"results":[','')+"\n"
	builds=[]
	previous_newline=-1
	for index,c in enumerate(string):
		if c=="\n":
			builds.append(string[previous_newline+1:index])
			previous_newline=index
	repo_updated=fix_date(find_property(builds[0],data_starts_at))
	return builds[1:]

#reads docker hub builds page to find a specific build (latest = 0) and it's properties
def read_hub(location,index):
	page=urllib.urlopen(location).read()
	soup = BeautifulSoup(page, 'html.parser')
	builds=format(soup)
	if index == "all":
		return builds
	else:
		return builds[index]
def get_build_index(id):
	builds=read_hub(url,"all")
	index=0
	for i, build in enumerate(builds):
		if build.find(id) != -1:
			index=i
			break
	return index

def is_currently_building():
	builds=read_hub(url,"all")
	index=-1
	for i, build in enumerate(builds):
		if find_property(build,"status") == "Building":
			index=i
			break
	return index

try:
	if sys.argv[1] == "--stream":
		print("Builds take approximately 30 minutes to complete, but may be less.")
		print("This script will print the approximate time remaining but will always end when a build has completed.\n")
		hub=read_hub(url,"all")
		T=BUILD_TIME
		build_status=""
		if is_currently_building() == -1 :
			ID=find_property(hub[0],"id")
		else:
			ID=find_property(hub[is_currently_building()],"id")
		T0=time.time()
		while True:
			build_status=find_property(read_hub(url,get_build_index(ID)),"status")
			if(build_status == "Success" or build_status == ""):
				break
			if build_status == "Building":
				print("Build Status: " + build_status + " Approximate time remaining: " +str(int(T/60.0))+ "m " + str(T%60) + "s.")
				T=countdown(T0)
			else:
				print("Build Status: " + build_status + ". Build should start shortly.")
			time.sleep(DELTA_T)
		print("Build has ended with status " + build_status+".")
		if build_status == "Failure":
			print("Build has failed you will download the previously successful build.")
	else:
		raise IndexError
except IndexError:
	print(find_property(read_hub(url,0),"status"))
		
