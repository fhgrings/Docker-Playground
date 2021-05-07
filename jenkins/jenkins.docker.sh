# vim: set background=dark:
# vim: set number:

#
#     J E N K I N S

# Image
SERVICE_NAME="jenkins"
IMAGE="jenkins/jenkins"
PORT1=8080
PORT2=50000

# Configs
ORG_NAME=Grings
PASSWORD=123456

#echo "# FIXME: grafana guarda plugins no volume"

if [ -z "$(docker service ls | grep ${SERVICE_NAME})" ]; then 

   echo "Creating service ${SERVICE_NAME}"

   echo "** Downloading IMAGE "
   docker pull ${IMAGE}

   docker service create --name ${SERVICE_NAME} --replicas=1 --limit-cpu=1 --limit-memory=300mb -p ${PORT1}:8080 -p ${PORT2}:50000  \
	--mount type=volume,source=jenkins,destination=/var/jenkins_home \
	${IMAGE}
#	--mount type=bind,source=$(pwd)/grafana.ini,destination=/etc/grafana/grafana.ini   \
     
  for i in {1..5}; do echo -en "\rWaiting..$i - 5"; sleep 1; done
fi
echo "Verifying service ${SERVICE_NAME}"
echo "$(docker node ps $(docker node ls -q) -f name=${SERVICE_NAME} --filter desired-state=Running)"
