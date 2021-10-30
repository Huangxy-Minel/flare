USER=xinyang
PARTY='10000'
NETWORK='192.168.136.0/24'


docker network create \
-d overlay \
--subnet=$NETWORK \
--attachable=true \
${USER}_confs${PARTY}_fate-network