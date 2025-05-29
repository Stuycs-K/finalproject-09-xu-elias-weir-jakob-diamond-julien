# SETUP INSTRUCTIONS
# docker build -t sudo-test .; docker run -it --rm --tty sudo-test
# also run perl -e 'print(("A"x100 . "\x00") x 50)' | sudo -S id
# docker build -t sudo-test .
# docker run -it --rm sudo-test

# alpine releases https://www.alpinelinux.org/releases/
FROM alpine:3.8.4

# ADD https://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/sudo-1.8.23-r3.apk /tmp/
# RUN apk add --no-cache /tmp/sudo-1.8.23-r3.apk

RUN apk update && apk add bash


# install python : https://stackoverflow.com/questions/62554991/how-do-i-install-python-on-alpine-linux
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools



# # https://www.baeldung.com/linux/alpine-install-sudo
# RUN apk add sudo

# install sudo
# sudo releases: https://www.sudo.ws/releases/legacy/ 
RUN apk update
RUN apk upgrade

RUN apk add --no-cache build-base curl \
    && curl -LO https://www.sudo.ws/dist/sudo-1.8.25.tar.gz \
    && tar xzf sudo-1.8.25.tar.gz \
    && cd sudo-1.8.25 \
    && ./configure --prefix=/usr --without-secure-path \
    && make -j$(nproc) && make install

RUN apk add --no-cache build-base curl gdb
# validate the sudoers file syntax to ensure it's correct
RUN visudo -cf /etc/sudoers && echo "Sudoers file validation passed"
RUN echo 'Defaults pwfeedback' >> /etc/sudoers
RUN grep -q "^Defaults pwfeedback" /etc/sudoers || (echo "Defaults pwfeedback is not in sudoers file" && exit 1)

# Set environment variables
ENV user=base


# https://www.docker.com/blog/understanding-the-docker-user-instruction/
# Create a custom user with UID 1234 and GID 1234
RUN addgroup -g 1234 custom_group && \
    adduser --gecos "" --disabled-password -D -u 1234 -G custom_group ${user} && \
    echo "${user}:pass" | chpasswd

# Switch to the custom user
USER ${user}
 
# Set the workdir
WORKDIR /home/${user}
 
# Print the UID and GID and start a shell
CMD ["/bin/sh", "-c", "echo Inside Container: && echo User: $(whoami) UID: $(id -u) GID: $(id -g) && exec /bin/sh"]

