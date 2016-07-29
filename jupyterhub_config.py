# jupyterhub_config.py
raven = False
local = False
github = False


c = get_config()

c.NotebookApp.open_browser = False


import os
#from pycav_tis import tis

# Enable Logging
c.JupyterHub.log_level = 'DEBUG'

c.JupyterHub.port = 8000

# SSL
c.JupyterHub.ssl_key = '/etc/letsencrypt/live/website/privkey.pem'
c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/website/fullchain.pem'

# Cookies
auth_key=''
c.JupyterHub.proxy_auth_token=auth_key
c.JupyterHub.cookie_secret_file = '/home/public/jupyterhub_cookie_secret'

# Users
c.JupyterHub.db_url = '/home/public/jupyterhub.sqlite'
c.JupyterHub.admin_access = True

#tis_config = '/home/public/tis_config'
#tis_csv = '/home/public/tis.csv'
#tis_conn = tis.pycavTisDictReader(tis_csv)

#c.Authenticator.admin_users = tis_conn.get_admins()
#c.Authenticator.whitelist = tis_conn.get_users()


if github:
    from oauthenticator.github import GitHubOAuthenticator
    c.JupyterHub.authenticator_class = GitHubOAuthenticator
    #c.LocalGitHubOAuthenticator.create_system_users = True
    c.GitHubOAuthenticator.oauth_callback_url = 'https://website:8000/hub/oauth_callback'
    c.GitHubOAuthenticator.client_id = ''
    c.GitHubOAuthenticator.client_secret = ''
    #c.Authenticator.whitelist = {''}
    #c.Authenticator.admin_users = {''}
elif local:
    c.JupyterHub.authenticator_class = LocalAuthenticator
    #c.LocalAuthenticator.create_system_users = True
    #c.Authenticator.whitelist = {''}
    #c.Authenticator.admin_users = {''}
elif raven:
    from raven_auth.raven_auth import RavenAuthenticator
    c.JupyterHub.authenticator_class = RavenAuthenticator
    c.RavenAuthenticator.description = "pyCav"
    c.RavenAuthenticator.login_logo = './resources/logo.png'
    c.RavenAuthenticator.long_description = ”The_pyCav_Jupyterhub_server.”
    c.RavenAuthenticator.allowed_colleges = {'PHY'} 

# Docker
from dockerspawner import DockerSpawner
c.JupyterHub.spawner_class = DockerSpawner
c.Spawner.debug = True

c.DockerSpawner.volumes={'/home/public/users/{username}':'/home/jovyan/work','/srv/nbgrader/exchange':'/srv/nbgrader/exchange','/home/public/server/crsidify':"/srv/crsidify"}

#demos_c.DockerSpawner.read_only_volumes={'/home/public/demos':'/home/jovyan/work/demos'}

#c.DockerSpawner.notebook_dir = '/home/jovyan/work/{username}'
c.DockerSpawner.extra_create_kwargs.update({
    'command': 'sh /srv/crsidify/start-singleuser.sh'
})
c.DockerSpawner.remove_containers=True
c.DockerSpawner.container_image = "jordanosborn/pycav"

import netifaces
docker0 = netifaces.ifaddresses('docker0')
docker0_ipv4 = docker0[netifaces.AF_INET][0]
c.JupyterHub.hub_ip = docker0_ipv4['addr']


#c.JupyterHub.spawner_class.container_port=8089
#c.JupyterHub.spawner_class.container_port=32773

