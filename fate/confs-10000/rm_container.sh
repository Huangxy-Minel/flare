# ----------------variables----------------
USER=xinyang
PARTY='10000'
WORKER_NUM=5

docker stop ${USER}_confs${PARTY}_sql
docker stop ${USER}_confs${PARTY}_datanode
docker stop ${USER}_confs${PARTY}_namenode
for ((i=1; i<=${WORKER_NUM}; i++));
do
docker stop ${USER}_confs${PARTY}_spark-worker_$i
done
docker stop ${USER}_confs${PARTY}_spark-master
docker stop ${USER}_confs${PARTY}_pulsar
docker stop ${USER}_confs${PARTY}_python
docker stop ${USER}_confs${PARTY}_nginx
docker stop ${USER}_confs${PARTY}_fateboard
docker stop ${USER}_confs${PARTY}_client

docker rm ${USER}_confs${PARTY}_sql
docker rm ${USER}_confs${PARTY}_datanode
docker rm ${USER}_confs${PARTY}_namenode
for ((i=1; i<=$WORKER_NUM; i++));
do
docker rm ${USER}_confs${PARTY}_spark-worker_$i
done
docker rm ${USER}_confs${PARTY}_spark-master
docker rm ${USER}_confs${PARTY}_pulsar
docker rm ${USER}_confs${PARTY}_python
docker rm ${USER}_confs${PARTY}_nginx
docker rm ${USER}_confs${PARTY}_fateboard
docker rm ${USER}_confs${PARTY}_client

docker volume rm ${USER}_confs${PARTY}_download_dir
docker volume rm ${USER}_confs${PARTY}_fate_flow_logs
docker volume rm ${USER}_confs${PARTY}_shared_dir_data
docker volume rm ${USER}_confs${PARTY}_shared_dir_examples
docker volume rm ${USER}_confs${PARTY}_shared_dir_federatedml
docker volume rm ${USER}_confs${PARTY}_shared_dir_fate_arch
docker volume rm ${USER}_confs${PARTY}_shared_dir_fate_flow

# docker network rm ${USER}_confs${PARTY}_fate-network
