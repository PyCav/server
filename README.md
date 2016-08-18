# Server

[Link to Server Setup Guide](https://github.com/PyCav/Server/blob/master/guide/server_setup_guide.md)

**Don't mess with the folder structure of /parent or the file layout in /parent/server** 

    /parent/
          --users/
                                      
          --demos/
                                      
          --data/
                                      
          --investigations/
                                      
          --server/


## **Todo**

#### **Current**

1. Total update script, updatescripts, updatecontainers, updatenotebooks.sh, triggerbuild?

1. Build on machine? Rather than using docker hub's auto build or move to pycav account on hub.docker.com run trigger build script at 1am everyday on main server

1. Investigate crons not working? serverguide

1. documenting source code


#### **Future**

1. Output to log files

1. nbgrader documentation and setup in autosetup.sh server_setup_guide.md

1. whitelisting by course tis library

1. admin users access to /home/public/users top level user folders customise dockerSpawner.py?

1. Raven auth to Pypi so can be updated without git. (Niall) Reflect in autosetup.sh and guide.

#### **Complete**

1. ~~fix url highlighting for pdfgen~~

1. ~~Finish server_setup_guide.md updatescripts section~~

1. ~~fix formatting when outputting to pdf~~

1. ~~Move global scripts into ./global/~~

1. ~~updatescripts.sh backup.sh set up?~~
 
1. ~~improve Auto set up demonstration server script autosetup.sh implement checks~~

1. ~~in guide explain how to use local users instead of docker containers?~~ not planned for now

1. ~~Use relative paths in scripts, (custom notebooks and user folders location?)~~

1. ~~make update server files script that pulls github repo and customises jupyterhub_config.py~~(only for Raven usage)

1. ~~stopping server~~ nicely 

1. ~~Add 404 page to demo website~~

1. ~~add uptime in running containers list~~

1. ~~improve demo website~~

1. ~~make server stats easier to view~~

1. ~~fix nokill flag~~

1. ~~finish idlechecks and checks for containers exceeding fair use in killidle.py~~

1. ~~jupyterhub customisation (logos)~~

1. ~~folder restructuring~~

1. ~~make jupyterhub_config.py authentication type flaggable~~ (not tested)

1. ~~backup of /home/public/users backup.sh~~

1. ~~updating software script(remove containers, docker pull jordanosborn/pycav periodically and pycav repos) update.sh~~

