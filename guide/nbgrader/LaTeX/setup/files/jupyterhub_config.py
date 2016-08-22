"""
jupyterhub_config.py

The pycav project jupyterhub config
"""

c = get_config()

"""
Imports

os : for accessing absolute paths
pycav_tis : for interfacing with the Teaching Information System
"""
import os
from pycav_tis import tis

# Setup for the TiS module
# TODO: Replace DictReader with SQL system when appropriate
tis_config = '/home/public/tis_config'
tis_csv = '/home/public/tis.csv'
tis_conn = tis.pycavTisDictReader(tis_csv)

c.NotebookApp.open_browser = False

# Enable Logging
c.JupyterHub.log_level = 'DEBUG'
c.JupyterHub.port = 8000

# SSL
c.JupyterHub.ssl_key = '/etc/letsencrypt/live/pycav.ovh/privkey.pem'
c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/pycav.ovh/fullchain.pem'

# Cookies
c.JupyterHub.proxy_auth_token='you-need-to-set-this-see-the-docs'
c.JupyterHub.cookie_secret_file = '/home/jordan/jupyterhub_cookie_secret'

# Users
c.JupyterHub.db_url = '/home/jordan/jupyterhub.sqlite'
c.JupyterHub.admin_access = True

c.Authenticator.admin_users = tis_conn.get_admins()
c.Authenticator.whitelist = tis_conn.get_users()

# Ucam Authentication
from raven_auth.raven_auth import RavenAuthenticator
c.JupyterHub.authenticator_class = RavenAuthenticator
c.RavenAuthenticator.description.value = "pyCav"
c.RavenAuthenticator.long_description = "The pyCav Jupyterhub server."
c.RavenAuthenticator.login_logo = '/home/public/py_cav.jpg'

# Docker
from dockerspawner import DockerSpawner
c.Spawner.debug = True
c.JupyterHub.spawner_class = DockerSpawner
#c.DockerSpawner.container_prefix = pycav
c.DockerSpawner.read_only_volumes={'/home/public/demos':
'/home/jovyan/work/demos',
'/home/public/crsidify':'/srv/crsidify'}
c.DockerSpawner.volumes={'/srv/nbgrader':'/srv/nbgrader'}
c.DockerSpawner.extra_create_kwargs.update({
    'command': 'sh /srv/crsidify/start-singleuser.sh'
})
c.DockerSpawner.container_image = "jordanosborn/pycav"

import netifaces
docker0 = netifaces.ifaddresses('docker0')
docker0_ipv4 = docker0[netifaces.AF_INET][0]
c.JupyterHub.hub_ip = docker0_ipv4['addr']