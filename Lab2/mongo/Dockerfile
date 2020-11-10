ARG MONGO_VERSION=4
FROM mongo:${MONGO_VERSION}

#COPY mongo.conf /usr/local/etc/mongo/mongo.conf

VOLUME /data/db /data/configdb

CMD ["mongod"]

EXPOSE 27017