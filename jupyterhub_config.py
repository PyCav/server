# jupyterhub_config.py
c = get_config()

c.NotebookApp.open_browser = False

import os

# Enable Logging
#c.JupyterHub.log_level = 'DEBUG'

c.JupyterHub.port = 8000

# SSL
c.JupyterHub.ssl_key = '/etc/letsencrypt/live/pycav.ovh/privkey.pem'
c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/pycav.ovh/fullchain.pem'

# Cookies
auth_key=''
c.JupyterHub.proxy_auth_token=auth_key
c.JupyterHub.cookie_secret_file = '/home/jordan/jupyterhub_cookie_secret'

# Users
c.JupyterHub.db_url = '/home/jordan/jupyterhub.sqlite'
c.LocalAuthenticator.create_system_users = True
c.JupyterHub.admin_access = True

#c.Authenticator.whitelist = {''}
c.Authenticator.admin_users = {''}

raven = True
remoteauth = False
github = False

if github:
    from oauthenticator.github import GitHubOAuthenticator
    c.LocalGitHubOAuthenticator.create_system_users = True
elif remoteauth:
    from remote_user.remote_user_auth import RemoteUserAuthenticator
    c.JupyterHub.authenticator_class = RemoteUserAuthenticator
elif raven:
    from raven_auth.raven_auth import RavenAuthenticator
    c.JupyterHub.authenticator_class = RavenAuthenticator
    c.RavenAuthenticator.description = "pyCav"
    c.RavenAuthenticator.login_logo = './logo.png' 

# Docker
from dockerspawner import DockerSpawner
c.JupyterHub.spawner_class = DockerSpawner
c.DockerSpawner.read_only_volumes={'/home/public/demos':'/home/jovyan/work'}

import netifaces
docker0 = netifaces.ifaddresses('docker0')
docker0_ipv4 = docker0[netifaces.AF_INET][0]
c.JupyterHub.hub_ip = docker0_ipv4['addr']

#c.JupyterHub.spawner_class.container_port=8089
#c.JupyterHub.spawner_class.container_port=32773

#c.GitHubOAuthenticator.oauth_callback_url = 'https://site_name:jupyterHubPort/hub/oauth_callback'
#c.GitHubOAuthenticator.client_id = ''
#c.GitHubOAuthenticator.client_secret = ''

# start single-user notebook servers in ~/assignments,
# with ~/assignments/Welcome.ipynb as the default landing page
# this config could also be put in
# /etc/ipython/ipython_notebook_config.py
