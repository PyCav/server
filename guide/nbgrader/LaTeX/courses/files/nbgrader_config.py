import os
from pycav_tis import tis

c = get_config()

# TODO: When creating a new course, change this to the course_id on the TiS
# May have to write a dictionary to look this up because nbgrader automatically converts an integer represented in a string to an int object
course_id = 'pycav-test'

# TiS
#tis_config = ''
tis_csv = '/home/public/tis.csv'
tis_conn = tis.pycavTisDictReader(tis_csv, course_id)

# Generic nbgrader configs
c.NbGrader.course_id = course_id
#c.TransferApp.exchange_directory = "/home/public/pycav-nbgrader/exchange"
c.NbGrader.db_assignments = [dict(name="ex1")]
c.NbGrader.db_students = tis_conn.get_students()

# Options that are specific to formgrader & integrating it with JupyterHub

c.FormgradeApp.ip = "127.0.0.1"
c.FormgradeApp.port = 9000
c.FormgradeApp.authenticator_class = "nbgrader.auth.hubauth.HubAuth"

#
import netifaces
docker0 = netifaces.ifaddresses('docker0')
docker0_ipv4 = docker0[netifaces.AF_INET][0]

# This is the actual URL or public IP address where JupyterHub is running (by
# default, the HubAuth will just use the same address as what the formgrader is
# running on -- so in this case, 127.0.0.1). If you have JupyterHub behind a
# domain name, you probably want to set that here.
# TODO: Convert this into some sort of jupyterhub or shared config
c.HubAuth.hub_base_url = "https://pycav.ovh:8000"
c.HubAuth.hub_port = 8001
c.HubAuth.hubapi_port = 8081
c.HubAuth.hubapi_address = docker0_ipv4['addr']

# Call the TiS to get the graders for this particular course_id
c.HubAuth.graders = tis_conn.get_graders()

c.HubAuth.hubapi_token = os.environ['JPY_API_TOKEN']