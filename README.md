# RLCraft Server

Docker image for the Forge modded server with RLCraft installed.

## Quickstart

Currently looking into the most cost effective way to run this:

* Cloudrun is, astonishingly, possible - though limited in terms of 8GB RAM and data persistence
* Standard COS VM (current solution)
* Pre-emptible COS VM (need to add some persistence automation)

Also want to automate everything (Infra, network/firewall, run, backup) a single cloud function invocation. 

But right now, the kids are impatient - so this is very much quick and dirty - but effective!

### GCP VM (Run as it is)

For quickest start with 6GB RAM allocated to the Minecraft Server JVM:

1. Create a e2-highmem-2 vm with network tag `mc` using COS image
1. Add a firewall rule for port 25565 0.0.0.0/0 to target tag `mc`
1. SSH into server
```bash
docker pull eu.gcr.io/mc-rlcraft/rlcraft:latest
mkdir ~/world
docker run -dit -e EULA=true -v ~/world:/server/world -p 25565:25565 eu.gcr.io/mc-rlcraft/rlcraft:latest
```
**NOTE**: By providing EULA=TRUE you agree to the EULA at https://account.mojang.com/documents/minecraft_eula
**NOTE**: You can override the RAM setting by adding an ´-e RAM=12G` which would give it 12GB of RAM
### GCP VM (Custom)

1. Create a e2-highmem-2 vm with network tag `mc` using COS image
1. Add a firewall rule for port 25565 0.0.0.0/0 to target tag `mc`
1. SSH into server
```bash
cd &&
git clone https://github.com/erzz/RLCraft-Server.git
docker build -t rl:latest .
mkdir ~/world
docker run -dit -e EULA=true -v ~/world:/server/world -p 25565:25565 rl:latest
```
**NOTE**: By providing EULA=TRUE you agree to the EULA at https://account.mojang.com/documents/minecraft_eula
**NOTE**: You can override the RAM setting by adding an ´-e RAM=12G` which would give it 12GB of RAM

## Environment Variables
- EULA (Required)
  - Default: none
- RAM - Sets the dedicated RAM (java -Xms, -Xmx)
  - Default: 12G

## References
- JVM Parameters<br>
  https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
- Crontab<br>
  https://www.adminschoice.com/crontab-quick-reference
