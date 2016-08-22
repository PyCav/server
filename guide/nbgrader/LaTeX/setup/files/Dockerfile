# Build as jupyterhub/singleuser
# Run with the DockerSpawner in JupyterHub

FROM jupyterhub/singleuser

MAINTAINER jordan <jo357@cam.ac.uk>

EXPOSE 8888

USER root
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" \
    >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -t jessie-backports  -y install ffmpeg
RUN pip3 install vpython
RUN pip3 install pycav
RUN pip3 install nbgrader
RUN nbgrader extension install
RUN nbgrader extension activate

# Prep. to replace the jovyan user with the crsid
RUN userdel jovyan
ENV SHELL /bin/bash

ADD pycav-start.sh /srv/pycav/pycav-start.sh

# Execute this script on startup
CMD ["sh", "/srv/pycav/pycav-start.sh"]