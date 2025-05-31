###############################################################################
# Exploitable sudo 1.8.25 + pwntools on Ubuntu 22.04 LTS
###############################################################################
FROM ubuntu:22.04

# 1. Non-interactive APT
ENV DEBIAN_FRONTEND=noninteractive

# 2. Bring in build-time tooling and run-time libs
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential cmake git curl wget ca-certificates \
        libssl-dev libffi-dev libcap-dev libpam0g-dev \
        python3 python3-dev python3-pip python3-setuptools vim binutils-x86-64-linux-gnu gdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install some additional utils
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --no-cache-dir pwntools pwn

# 3. Build sudo 1.8.25 from the legacy tarball
WORKDIR /usr/src
RUN wget https://www.sudo.ws/dist/sudo-1.8.25.tar.gz && \
    tar xf sudo-1.8.25.tar.gz && \
    cd sudo-1.8.25 && \
    ./configure --prefix=/usr --without-secure-path && \
    make -j"$(nproc)" && make install
    
# 4. Harden sudoers for the pwfeedback PoC
RUN visudo -cf /etc/sudoers && \
    echo 'Defaults pwfeedback' >> /etc/sudoers && \
    grep -q '^Defaults pwfeedback' /etc/sudoers
    

# 6. Low-privilege user that still owns /home/base

ARG USERNAME=base
ARG UID=1234
ARG GID=1234
RUN groupadd -g $GID custom_group && \
    useradd -m -u $UID -g custom_group -s /bin/bash $USERNAME && \
    echo "$USERNAME:pass" | chpasswd && \
    chown $USERNAME:custom_group /home/$USERNAME && chmod 4755 /usr/bin/sudo
USER $USERNAME
WORKDIR /home/$USERNAME

COPY shellcode_spawn.py /home/$USERNAME


CMD ["/bin/bash", "-c", "echo \"Inside container as $(whoami) (uid:$(id -u))\" && exec /bin/bash"]
