#!/bin/bash
# https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
export COMPOSEFILE=$1
export ENVFILE=$2
export COMPOSEARG=$3

echo "file:$ENVFILE"

source ~/load_env.sh $ENVFILE

if [ $COMPOSEARG = "up" ]; then
	docker compose -f $COMPOSEFILE --env-file $ENVFILE up -d
	echo "ESPERANDO 10 SEGS"
	sleep 10
	docker exec $USERNAME bash -c "bash /root/create_user.sh $USERNAME $PASSWORD"
else
	docker compose -f $COMPOSEFILE --env-file $ENVFILE down
fi
