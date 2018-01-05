# written by Jared on Jan 31, 2019.
# Build image for esrally.
FROM python:3-stretch
RUN pip3 install esrally

VOLUME /root/.rally/
COPY docker-entrypoint.sh /root/docker-entrypoint.sh
ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
