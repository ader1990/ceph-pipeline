FROM ubuntu:20.04

LABEL maintainer="Adrian Vladu <adrian.vladu21@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

# Make sure the package repository is up to date.
RUN apt-get update --allow-unauthenticated && \
    apt-get -qy full-upgrade &&
    apt-get install -qy git && \
    apt-get install -qy openssh-server && \
    apt-get install -qy sudo && \
    apt-get -qy install mingw-w64 cmake pkg-config python3-dev python3-pip \
                autoconf libtool ninja-build zip && \
    python3 -m pip install cython && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 (latest stable edition at 2019-04-01)
    apt-get install -qy openjdk-8-jdk && \
# Install maven
    apt-get install -qy maven && \
# Cleanup old packages
    apt-get -qy autoremove

# RUN git -c core.symlinks=true clone --recurse-submodules https://github.com/petrutlucian94/ceph -b wnbd_dev /home/jenkins/ceph

# Create jenkins user
RUN adduser --gecos "" jenkins --disabled-password
RUN echo "jenkins:jenkins" | chpasswd
RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/
RUN echo "jenkins ALL = NOPASSWD : ALL" >> /etc/sudoers

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
