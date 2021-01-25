# RLCraft Server

Docker image for the Forge modded server with RLCraft installed.

## Quickstart

Currently looking into the most cost effective way to run this:

* Cloudrun is, astonishingly, possible - though limited in terms of 8GB RAM and data persistence
* Standard COS VM (current solution)
* Pre-emptible COS VM (need to add some persistence automation)

I plan to add more automation such as backup and some cloud functions so the kids can start/stop/reset world/create new world/backup etc. 

But right now, the kids are impatient - so this is very much quick and dirty - but effective!

### The REALLY Quick Start

The default configuration in this project has been tested for 48 hours straight with 5-10 teenage users constantly with zero complaints and zero restarts. The fact that there were no complaint's about lag or anything else from a gang of teenagers is the ultimate test and thus approved!

The default configuration would cost ~$76 per month if running 24/7 plus bandwidth costs. I use MOTD to inform users of the planned opening times. For example just opening it at weekends cost me approx $4 for a month! You can reduce that cost even more by using preemptible nodes (`--preemptive`) which are around 25% of the cost though only last for 24 hours, so you will want to put a backup procedure in action first.

Using either a local Google SDK or the console version of Cloud Shell, the commands in [createServerGCP.sh](createServerGCP.sh) will:

* Create a Compute Engine VM
* Pull the latest docker image from this project
* Create a local directory for world storage
* Start the RLCraft server with /server/world mounted from the VM
* A firewall rule allowing internet access to the server.

You can either run the script locally (if you have Google Cloud SDK already configured to your project) or just copy/paste the commands into Cloud Shell at https://console.cloud.google.com/

If you are going to run the script locally - make sure you first `export GOOGLE_CLOUD_PROJECT=<your-project-id>`

#### Potential Modifications

* `--zone=europe-north1-b` -> Change to a closer region/zone for your users
* `--machine-type=e2-highmem-2` -> Change to a bigger or smaller machine type based on your needs (this default size is 2 CPU & 16GB RAM)
* `-e RAM=12G` -> How much memory you wish to assign to the Minecraft Server's JVM - set to approx ~2G lower than your machine-types RAM
* `--boot-disk-size=100GB` -> Making this larger or smaller will impact your Read/Write OPs for storage
* `--boot-disk-type=pd-standard` -> Again if you feel disk bound, you may want to swap to SSD

### Manually Building

If you want to fiddle with more Google Compute or other VM/Network settings:

1. Create a e2-highmem-2 (or your choice of size) VM with network tag `mc` using COS image
1. Add a firewall rule for port 25565 0.0.0.0/0 to target tag `mc`
1. SSH into server
```bash
docker pull eu.gcr.io/mc-rlcraft/rlcraft:latest
mkdir -p /home/forge/world && chmod -R 101:101 /home/forge
docker run -dit -e EULA=true -e RAM=6G -v /home/forge/world:/server/world -p 25565:25565 eu.gcr.io/mc-rlcraft/rlcraft:latest
```
**NOTE**: By providing EULA=TRUE you agree to the EULA at https://account.mojang.com/documents/minecraft_eula
**NOTE**: You can override the RAM setting by adding an ´-e RAM=12G` which would give it 12GB of RAM

### Customise the server

If you want to customise the server (server.properties, MOTD, add mods etc):

1. Create a e2-highmem-2 vm with network tag `mc` using COS image
1. Add a firewall rule for port 25565 0.0.0.0/0 to target tag `mc`
1. SSH into server
```bash
cd &&
git clone https://github.com/erzz/RLCraft-Server.git
docker build -t rl:latest .
mkdir -p /home/forge/world && chmod -R 101:101 /home/forge
docker run -dit -e EULA=true -v /home/forge/world:/server/world -p 25565:25565 rl:latest
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
- Change MOTD<br>
  https://mctools.org/motd-creator
