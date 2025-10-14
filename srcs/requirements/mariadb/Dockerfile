FROM debian:12.4

RUN apt-get update && apt-get install -y \
    mariadb-server 

COPY ./tools/script.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/script.sh
COPY ./tools/maria.cnf /etc/mysql/mariadb.conf.d/
CMD ["/docker-entrypoint-initdb.d/script.sh"]