#!/bin/bash
# https://linux.how2shout.com/how-to-install-python-3-and-pip-3-on-ubuntu-20-04-lts/
#https://www.cyberciti.biz/faq/linux-cp-command-copy-symbolic-soft-link/
apt-get install python3 -y \
	&& cp -av /usr/bin/python3 /usr/bin/python \
	&& apt-get install python3-pip -y;