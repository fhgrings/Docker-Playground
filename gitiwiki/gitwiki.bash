# vim: set background=dark:
# vim: set number:

# 
# Wiki suporte unisys
#

serviceName="wiki-suporte-prod"


if [ -z "$(docker service ls | grep ${serviceName})" ]; then

   echo "criando servico ${serviceName}"

   echo "** baixar a imagem "
   docker pull marcelhuberfoo/docker-gitit:latest

   ## restor volume
   echo "** Verificando se existe o volume wiki-java-suporte no silpro1198"  
   echo "** execute manualmente: docker volume create wiki-java-suporte "
   echo "** execute manualmente: recover backup do volume "

# essa imagem nao tem suporte ao curl
#   --health-cmd="curl -s -o /dev/null -I -w '%{http_code}' localhost:5001 | grep 200 || exit 1" \
#   --health-interval=10s --health-retries=3 --health-timeout=2s	\
 
   ## criar serviço 
   docker service create --name ${serviceName} --replicas=1 --limit-cpu=1 --limit-memory=50mb -p 10880:5001  \
   --mount type=volume,source=wiki-java-suporte,destination=/data   \
   --env GIT_COMMITTER_NAME="user" \
   --env GIT_COMMITTER_EMAIL="user@domain.com" \
   marcelhuberfoo/docker-gitit:latest
   #--constraint node.hostname==silpro1198 

	
   
   echo "sleep 10"
   sleep 10
   #
   
fi 


##
echo "verificando o servico ${serviceName}"
echo "$(docker node ps $(docker node ls -q) -f name=${serviceName} --filter desired-state=Running)"
