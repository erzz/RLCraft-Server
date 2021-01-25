#!/bin/bash

# Create the firewall rule
gcloud compute --project="$GOOGLE_CLOUD_PROJECT" firewall-rules create rlcraft \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:25565 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=mc

# Create the VM
gcloud beta compute --project="$GOOGLE_CLOUD_PROJECT" instances create rlcraft \
    --zone=europe-north1-b \
    --machine-type=e2-highmem-2 \
    --subnet=default \
    --network-tier=STANDARD \
    --tags=mc \
    --boot-disk-size=100GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=rlcraft \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image-family=cos-77-lts \
    --image-project=cos-cloud \
    --metadata=startup-script="docker pull eu.gcr.io/mc-rlcraft/rlcraft:latest && mkdir -p /home/forge/world && chown -R 101:101 /home/forge/ && docker run -dit -e EULA=true -e RAM=12G -v /home/forge/world:/server/world -p 25565:25565 eu.gcr.io/mc-rlcraft/rlcraft:latest"
