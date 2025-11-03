FROM debian:12.4

RUN apt-get update && apt-get install -y \
    mariadb-server 

COPY ./tools/script.sh /etc/
RUN chmod +x /etc/script.sh
COPY ./tools/maria.conf /etc/mysql/mariadb.conf.d/50-server.cnf
CMD ["/etc/script.sh"]