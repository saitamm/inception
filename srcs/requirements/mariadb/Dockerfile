FROM mariadb:11.2

COPY ./tools/mariadb.conf /etc/mysql/mariadb.conf.d/maria.conf

RUN apt-get update && apt-get install mariadb-server -y 
