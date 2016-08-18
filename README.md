# Server

[Link to Server Setup Guide](https://github.com/PyCav/Server/blob/master/guide/server_setup_guide.md)

**Don't mess with the folder structure of /parent or the file layout in /parent/server** 

    /parent/
          --users/
                                      
          --demos/
                                      
          --data/
                                      
          --investigations/
                                      
          --server/


## **Todo:**

1. Finish server_setup_guide.md updatescripts section fix formatting when outputting to pdf

2. Move global scripts into ./global/

3. Build on machine? Rather than using docker hub's auto build or move to pycav account on hub.docker.com run trigger build script at 1am everyday on main server

4. Investigate crons not working and updatescripts.sh as cronjob? serverguide

5. documentation

6. Output to log files

7. nbgrader documentation  autosetup.sh server_setup_guide.md

8. whitelisting by course tis library

9. admin users access to /home/public/users top level user folders customise dockerSpawner.py?

10. Raven auth to Pypi so can be updated without git. (Niall)

### **Complete:**

1. ~~updatescripts.sh backup.sh set up?~~
 
2. ~~improve Auto set up demonstration server script autosetup.sh implement checks~~

3. ~~in guide explain how to use local users instead of docker containers?~~ not planned for now

4. ~~Use relative paths in scripts, (custom notebooks and user folders location?)~~

5. ~~make update server files script that pulls github repo and customises jupyterhub_config.py~~(only for Raven usage)

6. ~~stopping server~~ nicely 

7. ~~Add 404 page to demo website~~

8. ~~add uptime in running containers list~~

9. ~~improve demo website~~

10. ~~make server stats easier to view~~

11. ~~fix nokill flag~~

12. ~~finish idlechecks and checks for containers exceeding fair use in killidle.py~~

13. ~~jupyterhub customisation (logos)~~

14. ~~folder restructuring~~

15. ~~make jupyterhub_config.py authentication type flaggable~~ (not tested)

16. ~~backup of /home/public/users backup.sh~~

17. ~~updating software script(remove containers, docker pull jordanosborn/pycav periodically and pycav repos) update.sh~~




