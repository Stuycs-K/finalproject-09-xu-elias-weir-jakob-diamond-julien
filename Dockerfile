# Exploitable sudo 1.8.25 + pwntools on Ubuntu 22.04 LTS
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Tool-chain, runtime libs and assembler that pwntools needs
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential cmake git curl wget ca-certificates \
        libssl-dev libffi-dev libcap-dev libpam0g-dev \
        python3 python3-dev python3-pip python3-setuptools \
        binutils gdb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Pwntools
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --no-cache-dir pwntools

# 3. Build vulnerable sudo (no modern hardening)
WORKDIR /usr/src
RUN wget https://www.sudo.ws/dist/sudo-1.8.25.tar.gz && \
    tar xf sudo-1.8.25.tar.gz && \
    cd sudo-1.8.25 && \
    CFLAGS="-O2 -fno-stack-protector -no-pie -z execstack" \
      ./configure --prefix=/usr --disable-shared && \
    make -j"$(nproc)" && make install

# 4. Turn pwfeedback on non-interactively
RUN echo 'Defaults pwfeedback' > /etc/sudoers.d/pwfeedback && \
    chmod 440 /etc/sudoers.d/pwfeedback

# 5. Unprivileged demo user
ARG USERNAME=base
ARG UID=1234
ARG GID=1234
RUN groupadd -g $GID custom_group && \
    useradd -m -u $UID -g custom_group -s /bin/bash $USERNAME && \
    echo "$USERNAME:pass" | chpasswd
USER $USERNAME
WORKDIR /home/$USERNAME

COPY shellcode_spawn.py .

CMD ["/bin/bash", "-c", "echo \"Inside container as $(whoami) (uid:$(id -u))\" && exec /bin/bash"]
