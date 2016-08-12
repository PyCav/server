# Server

[Link to Server Setup Guide](https://github.com/PyCav/Server/blob/master/server_setup_guide.md)

**Don't mess with folder structure** /parent/

                                      --users/
                                      
                                      --demos/
                                      
                                      --data/
                                      
                                      --investigations/
                                      
                                      --server/


## Todo:

Build on machine? Rather than using docker hub's auto build

Finish server_setup_guide.md

documentation

output to logfiles

remove references to we in server_setup_guide.md

nbgrader

whitelisting by course tis library

admin access to /home/public/users top level customise dockerSpawner.py

improve Auto set up demonstration server script autosetup.sh implement checks

~~in guide explain how to use local users instead of docker containers?~~ not planned for now

~~Use relative paths in scripts, (custom notebooks and user folders location?)~~ folders (users, demos, data, investigations, server) can live in custom parent now.

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

~~updating software script(remove containers, docker pull jordanosborn/pycav periodically and https://github.com/pycav/demos.git) update.sh~~




