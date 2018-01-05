# Written by Jared on Jan 23, 2018.
FROM redis:3.2
COPY redis.conf /usr/local/etc/redis/redis.conf
RUN chown redis:redis /usr/local/etc/redis/redis.conf

EXPOSE 16379
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
