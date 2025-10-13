FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Copy configuration file
COPY .//tools/maria.cnf /etc/mysql/my.cnf

# Copy initialization script
COPY ./tools/script.sh /script.sh
RUN chmod +x /script.sh

# Expose port
EXPOSE 3306

# Volume for database files
VOLUME ["/var/lib/mysql"]

# Start MariaDB (and ensure it’s initialized)
CMD ["/script.sh"]
