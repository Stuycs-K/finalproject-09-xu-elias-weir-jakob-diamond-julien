FROM ubuntu:jammy-20221130
# FROM ubuntu:jammy-20230816
ENV DEBIAN_FRONTEND=noninteractive

ENV USER=nopriv LOGNAME=nopriv SSH_CLIENT=0  XDG_SESSION_TYPE=tty \
    SSH_CONNECTION=0 SSH_TTY=/dev/pts/0 XDG_SESSION_ID=1 TERM=xterm-256color \
    XDG_RUNTIME_DIR=/run/user/1001 MOTD_SHOWN=pam LANG=en_US.UTF-8  SHELL=/bin/bash

# Downgrade to the first 22.04 glibc build that had CET disabled
RUN apt-get update && \
    apt-get install -y --allow-downgrades \
        libc6=2.35-0ubuntu3 \
        libc6-dev=2.35-0ubuntu3 \
        libc-dev-bin=2.35-0ubuntu3 && \
    apt-mark hold libc6 libc6-dev libc-dev-bin 

RUN apt-get install -y --allow-downgrades gdb 

RUN apt-get update && apt-get install  --allow-downgrades -y gcc locales python3 python3-pip sudo \
        git wget vim tmux build-essential gcc && \
    pip3 install pwntools==4.11.0 && \
    locale-gen en_US.UTF-8
    
 # Optional: pull in Debian's default bashrc for colours, dircolors, etc.
    
RUN apt-get install -y bash && \
    cp /etc/skel/.bashrc /root/ && \
    useradd -ms /bin/bash ${USER} && \
    cp /etc/skel/.bashrc /home/${USER}/
    
# RUN echo 0 | tee /proc/sys/kernel/randomize_va_space


USER ${USER}
WORKDIR /home/${USER}

COPY exp.c .
COPY gen_libc.py .

CMD ["/bin/bash"]
