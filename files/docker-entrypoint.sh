#!/bin/bash

STEAMAPPDIR="/opt/FCE"

echo "Creating necessary directories..."
mkdir -p "$SAVES"
mkdir -p "$CONFIG"
mkdir -p "$MODS"
mkdir -p "$STEAMAPPDIR/Default"

set -ox pipefail

if [ -n "${STEAM_BETA_BRANCH}" ]; then
    echo "Loading Steam Beta Branch"
    bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                    +login anonymous \
                    +app_update "${STEAM_BETA_APP}" \
                    -beta "${STEAM_BETA_BRANCH}" \
                    -betapassword "${STEAM_BETA_PASSWORD}" \
                    +quit
else
    echo "Loading Steam Release Branch"
    bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                    +login anonymous \
                    +app_update "${STEAMAPPID}" \
                    +quit
fi

# Check if steamcmd was successful
if [ $? -ne 0 ]; then
  echo "steamcmd failed"
  exit 1
fi

echo "Checking configuration files..."
if [[ ! -f $CONFIG/firstrun.ini ]]; then
  cp "/home/steam/firstrun.ini" "$CONFIG/firstrun.ini"
  echo "Copying default firstrun.ini"
fi

if [[ ! -f $CONFIG/serveroverrides.ini ]]; then
  cp "/home/steam/serveroverrides.ini" "$CONFIG/serveroverrides.ini"
  echo "Copying default serveroverrides.ini"
fi

cp $CONFIG/serveroverrides.ini "$STEAMAPPDIR/Default/serveroverrides.ini"
cp $CONFIG/firstrun.ini "$STEAMAPPDIR/Default/firstrun.ini"

if [[ $(id -u) = 0 ]]; then
  echo "Updating user and group IDs..."
  usermod -o -u "$PUID" steam
  groupmod -o -g "$PGID" steam
  chown -R steam:steam "/home/steam"
  SU_EXEC="su-exec steam"
else
  SU_EXEC=""
fi

echo "Starting FortressCraft server..."
cd "$STEAMAPPDIR"

# Check if the executable exists
if [[ ! -f ./FC_Linux_Universal.x86_64 ]]; then
  echo "Executable FC_Linux_Universal.x86_64 not found!"
  exit 1
fi

# Make sure the executable has execute permissions
chmod +x ./FC_Linux_Universal.x86_64

# Start the server
exec $SU_EXEC ./FC_Linux_Universal.x86_64 -batchmode

# Keep the container running
tail -f /dev/null