############################################################
# Dockerfile that builds a FortressCraft Gameserver
############################################################
FROM cm2network/steamcmd:root

LABEL maintainer="Stopfen, for now"

ENV STEAMAPPID 443600
ENV STEAMAPP fortresscraft
ENV STEAMAPPDIR "/home/steam/fortresscraft-dedicated"

ENV STEAM_BETA_APP 443600
ENV STEAM_BETA_PASSWORD ""
ENV STEAM_BETA_BRANCH "linux-staging"

ENV WORKSHOPID 443600
ENV MODPATH "${STEAMAPPDIR}/WorkshopMods"
ENV MODS "()"

COPY etc/entry.sh /home/steam
COPY files/firstrun.ini /home/steam
COPY files/serveroverrides.ini /home/steam

# Set the UID and GID to match the host user
ARG PUID=1000
ARG PGID=1000

RUN set -x \
    && if getent group steam; then groupmod -g "$PGID" steam; else groupadd -g "$PGID" steam; fi \
    && if id -u steam >/dev/null 2>&1; then usermod -u "$PUID" steam; else useradd -m -u "$PUID" -g "$PGID" -s /bin/bash steam; fi \
    && chmod 755 "/home/steam/entry.sh" \
    && apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

ENV PORT=27012 \
    RCON_PORT=27015 \
    SAVES="/home/steam/fce/Worlds" \
    CONFIG="/home/steam/fce/Config" \
    MODS="/home/steam/fce/WorkshopMods" \
    SCRIPTOUTPUT="/factorio/script-output" \
    PUID=1000 \
    PGID=1000

WORKDIR /home/steam

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27012/udp \
    27012/tcp \
    27015/udp \
    27015/tcp