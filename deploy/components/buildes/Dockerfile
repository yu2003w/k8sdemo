FROM openjdk:9
ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
RUN mkdir -p /opt/estack/ && \
    mkdir -p /opt/build/logs/ && \
    apt-get update && apt-get install -y ant
# make stdout and stderr available in log files
RUN ln -sf /dev/stdout /opt/build/logs/out.log && \
    ln -sf /dev/stderr /opt/build/logs/err.log
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
WORKDIR /opt/estack/
VOLUME ["/opt/estack/", "/opt/build/logs"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
