FROM resin/rpi-raspbian

LABEL maintainer="voldedore"

ENV VERSION 0.1.0

# Workaround for resolvconf issue
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

# Install prerequisites
RUN apt-get update && apt-get install -y apt-utils wget curl

# Install DS for DST (@see http://dontstarve.wikia.com/wiki/Guides/Don%E2%80%99t_Starve_Together_Dedicated_Servers)
RUN apt-get update && dpkg --add-architecture i386 && apt-get install -y lib32gcc1 lib32stdc++6 libcurl4-gnutls-dev:i386

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

# volume
VOLUME ["/home/steam/.klei/DoNotStarveTogether"]

# Command
CMD ["/bin/bash"]
