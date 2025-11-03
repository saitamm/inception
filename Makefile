
WP_VOLUME_DIR = /home/$(USER)/data/wordpress
MDB_VOLUME_DIR = /home/$(USER)/data/mariadb

all: create-volumes
	docker compose -f ./srcs/docker-compose.yml up --build  -d
create-volumes:
	@if [ ! -d "$(MDB_VOLUME_DIR)" ]; then \
		mkdir -p $(MDB_VOLUME_DIR); \
	fi
	@if [ ! -d "${WP_VOLUME_DIR}" ]; then \
		mkdir -p $(WP_VOLUME_DIR); \
	fi


up: create-volumes
	docker compose -f ./srcs/docker-compose.yml up --build -d
down:
	docker compose -f ./srcs/docker-compose.yml down
clean:
	docker compose -f ./srcs/docker-compose.yml down -v

re: fclean all


fclean: clean
	docker system prune -a -f
	docker volume prune -f
	docker network prune -f
	docker container prune -f
	docker image prune -f
	docker builder prune
	sudo rm -rf ${WP_VOLUME_DIR}
	sudo rm -rf ${MDB_VOLUME_DIR}
	