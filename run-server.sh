#!/bin/sh

# Use RAM environment variable, else set a default 
if [ -z "$RAM" ]; then
  DEFAULT_RAM=6G
else
  DEFAULT_RAM="$RAM"
fi

if [ ! -f eula.txt ]; then
     if [ "$EULA" != "" ]; then
          echo "eula=$EULA" > eula.txt
     else
          echo "Please provide the EULA environment variable."
          echo "Note: By providing EULA=TRUE you agree to the EULA at https://account.mojang.com/documents/minecraft_eula."
          exit 1
     fi
fi

# Parameters from aikar's post:
# https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
java -Xms${RAM:-$DEFAULT_RAM} -Xmx${RAM:-$DEFAULT_RAM} \
     -XX:+UseG1GC \
     -XX:+ParallelRefProcEnabled \
     -XX:MaxGCPauseMillis=100 \
     -XX:+UnlockExperimentalVMOptions \
     -XX:+DisableExplicitGC \
     -XX:+AlwaysPreTouch \
     -XX:G1NewSizePercent=30 \
     -XX:G1MaxNewSizePercent=40 \
     -XX:G1HeapRegionSize=8M \
     -XX:G1ReservePercent=20 \
     -XX:G1HeapWastePercent=5 \
     -XX:G1MixedGCCountTarget=8 \
     -XX:InitiatingHeapOccupancyPercent=15 \
     -XX:G1MixedGCLiveThresholdPercent=90 \
     -XX:G1RSetUpdatingPauseTimePercent=5 \
     -XX:SurvivorRatio=32 \
     -XX:+PerfDisableSharedMem \
     -XX:MaxTenuringThreshold=1 \
     -XX:-OmitStackTraceInFastThrow \
     -Dusing.aikars.flags=true \
     -Daikars.new.flags=true \
     -jar server.jar nogui
