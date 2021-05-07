# vim: set background=dark:
# vim: set number:

#
# default mysql container

set -e

# Image
SERVICE_NAME=mysql
IMAGE=mysql:8
PORT=3306


# Configs
DATABASE=main
USER=admin
PASSWORD=admin


if [ -z "$(docker service ls | grep ${SERVICE_NAME})" ]; then

   echo "Creating service ${SERVICE_NAME}"

   echo "** Downloading IMAGE "
   docker pull ${IMAGE}

   docker service create --name ${SERVICE_NAME} --replicas=1 --limit-cpu=1 --limit-memory=150mb -p ${PORT}:3306  \
   --env MYSQL_USER=${USER} \
   --env MYSQL_DATABASE=${DATABASE} \
   --env MYSQL_ROOT_PASSWORD=${PASSWORD} \
   --env MYSQL_ROOT_HOST=${PASSWORD} \
   --mount type=bind,source=$(pwd)/sql,destination=/docker-entrypoint-initdb.d   \
   ${IMAGE}

   for i in {1..5}; do echo -en "\rWaiting..$i/5"; sleep 1; done
fi

echo "Verifying service ${SERVICE_NAME}"
echo "$(docker node ps $(docker node ls -q) -f name=${SERVICE_NAME} --filter desired-state=Running)"
