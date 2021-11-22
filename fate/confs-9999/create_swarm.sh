IP_MANAGER="172.16.0.160"

docker swarm init --advertise-addr=${IP_MANAGER}
docker swarm join --token <TOKEN> \
  --advertise-addr <IP-ADDRESS-OF-WORKER-1> \
  <IP-ADDRESS-OF-MANAGER>:2377