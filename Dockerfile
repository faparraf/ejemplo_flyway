FROM openjdk:8
RUN apt-get update && apt-get install -y postgresql-client
COPY cache/flyway-commandline.tar.gz /
RUN mkdir -p /flyway && \
    cd /flyway && \
    tar xzf /flyway-commandline.tar.gz --strip-components=1 && \
    rm /flyway-commandline.tar.gz
COPY bin/enc.sh /bin/enc
COPY bin/migrate.sh /bin/migrate
COPY bin/passed.sh /bin/passed
RUN chmod +x /bin/enc /bin/migrate /bin/passed
