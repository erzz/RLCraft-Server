FROM alpine:3.13 AS base
RUN apk add curl
COPY installRLCraft.sh /
RUN mkdir server \
    && chmod +x installRLCraft.sh
WORKDIR /server
RUN /installRLCraft.sh

FROM openjdk:11-jre-slim AS server-install
COPY --from=base /server /server/
WORKDIR /server
COPY server.properties ops.json /server/
RUN java -jar installer.jar --installServer \
    && rm -rf installer* \
    && ln -s forge-*.jar server.jar

FROM openjdk:11-jre-slim
COPY run-server.sh /
COPY --from=server-install /server /server/
RUN apt update && \
    apt install -y screen procps && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --uid 101 --system --group forge && \
    chmod +x run-server.sh && \
    mkdir -p /server/world && \
    chown -R forge:forge /server
USER forge
WORKDIR /server
EXPOSE 25565
ENTRYPOINT /run-server.sh