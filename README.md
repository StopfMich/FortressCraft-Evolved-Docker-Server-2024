# FortressCraft-Evolved-Docker-Server
A fork from https://github.com/Stinosko/FortressCraft-Evolved-Docker-Server
since I couldn't get it to start, I have migrated it from steamcmd/steamcmd to cm2network/steamcmd (the official one)


## Usage

I recommend reading this article first https://github.com/StopfMich/FortressCraft-Evolved-Docker-Server-2024

### Quick Start

Clone the repo: 
```bash
git clone "https://github.com/Dakes/FortressCraft-Evolved-Docker-Server.git"
cd FortressCraft-Evolved-Docker-Server
```

Change the following files to your needs:
```bash
docker-compose.yml
files/firstrun.ini
files/serveroverrides.ini
```

You may need to create the necessary directories yourself, like in this case
```bash
~/games/FCE/
~/games/FCE_server/
```

To build the image: (in the same folder as docker-compose.yml)
```bash
docker-compose build
```

To start it:
```bash
docker-compose up -d
```

Or both commands in one: 
```bash
docker-compose up -d --build
```


### Notes

It may take some time until the server gets downloaded the first time. It is ~5 GB in size. So please don't panic if it looks stuck on 
```log Loading Steam API...OK```

### Mods

To set up your server with mods, follow the steps in this Article:
https://steamcommunity.com/sharedfiles/filedetails/?id=788739671

The necessary directories can be configured in the docker-compose file!

