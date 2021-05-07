# vim: set background=dark:
# vim: set number:

#
#     G R A F A N A

# Image
SERVICE_NAME="grafana"
IMAGE="grafana/grafana:7.1.4-ubuntu"
# IMAGE="grafana/grafana:6.7.1-ubuntu"
#IMAGE="grafana/grafana"
PORT=3000

# Configs
ORG_NAME=Grings
PASSWORD=123456

echo "# FIXME: grafana guarda plugins no volume"

if [ -z "$(docker service ls | grep ${SERVICE_NAME})" ]; then 

   echo "Creating service ${SERVICE_NAME}"

   echo "** Downloading IMAGE "
   docker pull ${IMAGE}

   docker service create --name ${SERVICE_NAME} --replicas=1 --limit-cpu=1 --limit-memory=300mb -p ${PORT}:3000  \
	--mount type=volume,source=grafana-storage,destination=/var/lib/grafana \
	--mount type=bind,source=$(pwd)/grafana.ini,destination=/etc/grafana/grafana.ini   \
	--env GF_SECURITY_ADMIN_PASSWORD=${PASSWORD} \
	--env GF_INSTALL_PLUGINS=farski-blendstat-panel \
	--env TZ=America/Argentina/Buenos_Aires  \
	--env GF_SECURITY_ALLOW_EMBEDDING=true \
	--env GF_PANELS_DISABLE_SANITIZE_HTML=true \
	--env GF_SECURITY_COOKIE_SAMESITE=disabled \
	--env GF_AUTH_ANONYMOUS_ENABLED=true \
	--env GF_AUTH_ANONYMOUS_ORG_NAME=${ORG_NAME} \
     ${IMAGE}
  for i in {1..5}; do echo -en "\rWaiting..$i - 5"; sleep 1; done
fi
echo "Verifying service ${SERVICE_NAME}"
echo "$(docker node ps $(docker node ls -q) -f name=${SERVICE_NAME} --filter desired-state=Running)"
