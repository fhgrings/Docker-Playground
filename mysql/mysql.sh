echo "** Starting script"

STACK_NAME=mysql

if [ -z "$(docker service ls | grep ${STACK_NAME})" ]; then
    echo "** Starting stack deploy"
    docker stack deploy --compose-file mysql.yml ${STACK_NAME}
    echo "sleep 5"
   sleep 5
   #
fi

echo "Verifying stack ${STACK_NAME}"
echo "$(docker node ps $(docker node ls -q) -f name=${STACK_NAME} --filter desired-state=Running)"
