USER=xinyang
WORKER_NUM=5
BASE_DIR=/home/xinyang/fate_cluster_1.6.1/flare/fate
PARTY='9999'
TAG=1.6.1-release

# ----------------create docker volumes----------------
# shared_dir_data
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/data \
${USER}_confs${PARTY}_shared_dir_data

# ----------------create containers----------------
# create datanode
docker run -d \
--name ${USER}_confs${PARTY}_datanode \
-v ${BASE_DIR}/confs-${PARTY}/shared_dir/data/datanode:/hadoop/dfs/data \
--ipc=shareable \
-e "SERVICE_PRECONDITION=172.16.0.160:10085" \
--env-file ${BASE_DIR}/confs-${PARTY}/confs/hadoop/hadoop.env \
--restart=always \
-p 50010:50010 \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=datanode \
federatedai/hadoop-datanode:2.0.0-hadoop2.7.4-java8

# create spark-worker
for ((i=1; i<=$WORKER_NUM; i++));
do
p=$(($i+10100))
docker run -d \
--name ${USER}_confs${PARTY}_spark-worker_$i \
-v ${BASE_DIR}/confs-${PARTY}/confs/fate_flow/conf:/data/projects/fate/conf \
-v ${USER}_confs${PARTY}_shared_dir_federatedml:/data/projects/fate/python/federatedml \
-p "$p":8081/tcp \
--ipc=shareable \
-e "SPARK_MASTER=spark://172.16.0.160:10089" \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=spark-worker \
--cpus=8 \
--memory 6GB \
federatedai/spark-worker:${TAG}
done
