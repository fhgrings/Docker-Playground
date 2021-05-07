# vim: set background=dark:
# vim: set number:

#
#     G R A F A N A

# Image
SERVICE_NAME="kibana"
IMAGE="kibana"
PORT=5601

# Configs

if [ -z "$(docker service ls | grep ${SERVICE_NAME})" ]; then 

   echo "Creating service ${SERVICE_NAME}"

   echo "** Downloading IMAGE "
   docker pull ${IMAGE}

   docker service create --name ${SERVICE_NAME} --replicas=1 --limit-cpu=1 --limit-memory=300mb -p ${PORT}:${PORT}  \
     ${IMAGE}
  for i in {1..5}; do echo -en "\rWaiting..$i - 5"; sleep 1; done
fi
echo "Verifying service ${SERVICE_NAME}"
echo "$(docker node ps $(docker node ls -q) -f name=${SERVICE_NAME} --filter desired-state=Running)"
