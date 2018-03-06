FROM resin/rpi-raspbian

LABEL maintainer="voldedore"

ENV VERSION 0.1.0

# Workaround for resolvconf issue
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

# Install prerequisites
RUN apt-get update && apt-get install -y apt-utils wget curl

# Install DS for DST (@see http://dontstarve.wikia.com/wiki/Guides/Don%E2%80%99t_Starve_Together_Dedicated_Servers)
#RUN dpkg --add-architecture i386
RUN mkdir -p /home/prepare && cd /home/prepare
RUN wget http://security.debian.org/debian-security/pool/updates/main/g/gcc-4.9/lib32gcc1_4.9.2-10+deb8u1_amd64.deb && \
  wget http://security.debian.org/debian-security/pool/updates/main/c/curl/libcurl3-gnutls_7.38.0-4+deb8u9_i386.deb && \
  wget http://security.debian.org/debian-security/pool/updates/main/g/gcc-4.9/lib32stdc++6_4.9.2-10+deb8u1_amd64.deb && \
  dpkg -i lib32gcc1_4.9.2-10+deb8u1_amd64.deb libcurl3-gnutls_7.38.0-4+deb8u9_i386.deb lib32stdc++6_4.9.2-10+deb8u1_amd64.deb

#RUN apt-get update && apt-get install -y lib32gcc1 libcurl3-gnutls:i386 lib32stdc++6
# lib32gcc1
# libcurl3-gnutls:i386
# lib32stdc++6
#RUN apt-get update && apt-get install -y lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386


# Create user to run the server
RUN useradd -m steam
USER steam
WORKDIR /home/steam

# Install the server
RUN cd /home/steam && \
  wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
  tar -xvzf steamcmd_linux.tar.gz && \
  mkdir server_dst && \
  ./steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir /home/steam/server_dst +app_update 343050 validate +quit

# ./dontstarve_dedicated_server_nullrenderer -cluster DSTWhalesCluster -shard "Test world"

# volume
VOLUME ["/home/steam/.klei/DoNotStarveTogether"]

# Command
CMD ["/bin/bash"]
