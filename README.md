# Server

[Link to Server Setup Guide](https://github.com/PyCav/Server/blob/master/server_setup_guide.md)

**Don't mess with the folder structure of /parent or the file layout in /parent/server** 

    /parent/
          --users/
                                      
          --demos/
                                      
          --data/
                                      
          --investigations/
                                      
          --server/


## Todo:
Finish server_setup_guide.md updatescripts section fix formatting when outputting to pdf

Build on machine? Rather than using docker hub's auto build or move to pycav account on hub.docker.com run trigger build script at 1am everyday on main server

Investigate crons not working and updatescripts.sh as cronjob? serverguide

documentation

Output to log files

nbgrader documentation  autosetup.sh server_setup_guide.md

whitelisting by course tis library

admin users access to /home/public/users top level user folders customise dockerSpawner.py

Raven auth to Pypi so can be updated without git.

~~updatescripts.sh backup.sh set up?~~

~~improve Auto set up demonstration server script autosetup.sh implement checks~~

~~in guide explain how to use local users instead of docker containers?~~ not planned for now

~~Use relative paths in scripts, (custom notebooks and user folders location?)~~

~~make update server files script that pulls github repo and customises jupyterhub_config.py~~(only for Raven usage)

~~stopping server~~ nicely 

~~Add 404 page to demo website~~

~~add uptime in running containers list~~

~~improve demo website~~

~~make server stats easier to view~~

~~fix nokill flag~~

~~finish idlechecks and checks for containers exceeding fair use in killidle.py~~

~~jupyterhub customisation (logos)~~

~~folder restructuring~~

~~make jupyterhub_config.py authentication type flaggable~~ (not tested)

~~backup of /home/public/users backup.sh~~

~~updating software script(remove containers, docker pull jordanosborn/pycav periodically and pycav repos) update.sh~~




