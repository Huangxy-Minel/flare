# ----------------variables----------------
USER=hxy
WORKER_NUM=5
BASE_DIR=/home/hxy/flare/fate
PARTY='10000'

NETWORK='192.168.136.0/24'
FLOW_IP='192.168.136.100'
TAG=1.6.1-release
PORT_FATEBOARD='10081'
PORT_GRPC='10082'
PORT_HTTP='10083'
PORT_CLIENT='10084'
PORT_HDFS='10085'
PORT_HADOOP='10086'
PORT_WEBHDFS='10087'
PORT_SPARKMASTER1='10088'
PORT_SPARKMASTER2='10089'
PORT_SPARKWORKER='10090'
PORT_PULSAR1='10091'
PORT_PULSAR2='10092'
PORT_PULSAR3='10093'
PORT_NGINX1='10094'
PORT_NGINX2='10095'

if [ $1 = 'standalone' ];then
# ----------------create docker network----------------
docker network create \
--driver=bridge \
--subnet=$NETWORK \
--attachable=true \
${USER}_confs${PARTY}_fate-network
fi

if [ $1 = 'manager' ];then
# ----------------create docker overlay-network----------------
docker network create \
-d overlay \
--subnet=$NETWORK \
--attachable=true \
${USER}_confs${PARTY}_fate-network
fi

if [ $1 = 'volume' ];then
# ----------------create docker volumes----------------
# fate flow logs
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/fate_flow_logs \
${USER}_confs${PARTY}_fate_flow_logs

# download_dir
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/download_dir \
${USER}_confs${PARTY}_download_dir

# shared_dir_examples
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/examples \
${USER}_confs${PARTY}_shared_dir_examples

# shared_dir_federatedml
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/federatedml \
${USER}_confs${PARTY}_shared_dir_federatedml

# shared_dir_data
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/data \
${USER}_confs${PARTY}_shared_dir_data

# fate_arch_data
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/fate_arch \
${USER}_confs${PARTY}_shared_dir_fate_arch

# fate_flow_data
docker volume create --driver local \
--opt type=none \
--opt o=bind \
--opt device=${BASE_DIR}/confs-${PARTY}/shared_dir/fate_flow \
${USER}_confs${PARTY}_shared_dir_fate_flow

fi

if [ $1 = 'container' ];then
# ----------------create containers----------------
# create mysql
docker run -d \
--name ${USER}_confs${PARTY}_sql \
--expose=3306 \
-v ${BASE_DIR}/confs-${PARTY}/confs/mysql/init:/docker-entrypoint-initdb.d/ \
-v ${BASE_DIR}/confs-${PARTY}/shared_dir/data/mysql:/var/lib/mysql \
--ipc=shareable \
--network-alias=mysql \
-e "MYSQL_ALLOW_EMPTY_PASSWORD=yes" \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
mysql:8

# create namenode
docker run -d \
--name ${USER}_confs${PARTY}_namenode \
-p ${PORT_HDFS}:9000/tcp \
-p ${PORT_HADOOP}:9870/tcp \
-p ${PORT_WEBHDFS}:50070/tcp \
-v ${BASE_DIR}/confs-${PARTY}/confs/hadoop/core-site.xml:/etc/hadoop/core-site.xml \
-v ${BASE_DIR}/confs-${PARTY}/shared_dir/data/namenode:/hadoop/dfs/name \
--env-file ${BASE_DIR}/confs-${PARTY}/confs/hadoop/hadoop.env \
--ipc=shareable \
-e "CLUSTER_NAME=fate" \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=namenode \
federatedai/hadoop-namenode:2.0.0-hadoop2.7.4-java8

# create datanode
docker run -d \
--name ${USER}_confs${PARTY}_datanode \
-v ${BASE_DIR}/confs-${PARTY}/shared_dir/data/datanode:/hadoop/dfs/data \
--ipc=shareable \
-e "SERVICE_PRECONDITION=namenode:9000" \
--env-file ${BASE_DIR}/confs-${PARTY}/confs/hadoop/hadoop.env \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=datanode \
federatedai/hadoop-datanode:2.0.0-hadoop2.7.4-java8

# create spark-master
docker run -d \
--name ${USER}_confs${PARTY}_spark-master \
-p ${PORT_SPARKMASTER1}:8080/tcp \
-p ${PORT_SPARKMASTER2}:7077/tcp \
--ipc=shareable \
-e "INIT_DAEMON_STEP=setup_spark" \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=spark-master \
federatedai/spark-master:${TAG}

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
-e "SPARK_MASTER=spark://spark-master:7077" \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=spark-worker \
--cpus=8 \
--memory 6GB \
federatedai/spark-worker:${TAG}
done

# create pulsar
docker run -d \
--name ${USER}_confs${PARTY}_pulsar \
-v ${BASE_DIR}/confs-${PARTY}/confs/pulsar/standalone.conf:/pulsar/conf/standalone.conf \
-v ${BASE_DIR}/confs-${PARTY}/shared_dir/data/pulsar:/pulsar/data \
-p ${PORT_PULSAR1}:6650/tcp \
-p ${PORT_PULSAR2}:6651/tcp \
-p ${PORT_PULSAR3}:8080/tcp \
--ipc=shareable \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=pulsar \
apachepulsar/pulsar:2.7.0 \
"/bin/bash" "-c" "bin/pulsar standalone -nss" 

# create python
docker run -d \
--name ${USER}_confs${PARTY}_python \
-p ${PORT_GRPC}:9360/tcp \
-p ${PORT_HTTP}:9380/tcp \
-v ${USER}_confs${PARTY}_shared_dir_federatedml:/data/projects/fate/python/federatedml \
-v ${USER}_confs${PARTY}_shared_dir_examples:/data/projects/fate/examples \
-v ${USER}_confs${PARTY}_download_dir:/data/projects/fate/python/download_dir \
-v ${USER}_confs${PARTY}_fate_flow_logs:/data/projects/fate/logs \
-v ${USER}_confs${PARTY}_shared_dir_fate_arch:/data/projects/fate/python/fate_arch \
-v ${USER}_confs${PARTY}_shared_dir_fate_flow:/data/projects/fate/python/fate_flow \
-v ${BASE_DIR}/confs-${PARTY}/confs/fate_flow/conf:/data/projects/fate/conf \
-v ${BASE_DIR}/confs-${PARTY}/confs/spark/spark-defaults.conf:/data/projects/spark-2.4.1-bin-hadoop2.7/conf/spark-defaults.conf \
-v ${BASE_DIR}/confs-${PARTY}/external_dir:/data/projects/fate/external_files \
--ipc=shareable \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=python \
--ip=${FLOW_IP} \
--restart=always \
federatedai/python-spark:${TAG} \
"/bin/bash" "-c" "sleep 5 && python /data/projects/fate/python/fate_flow/fate_flow_server.py"

# --gpus all \
# --rm \

# create nginx
docker run -d \
--name ${USER}_confs${PARTY}_nginx \
-v ${BASE_DIR}/confs-${PARTY}/confs/nginx/route_table.yaml:/data/projects/fate/proxy/nginx/conf/route_table.yaml \
-v ${BASE_DIR}/confs-${PARTY}/confs/nginx/nginx.conf:/data/projects/fate/proxy/nginx/conf/nginx.conf \
-p ${PORT_NGINX1}:9300/tcp \
-p ${PORT_NGINX2}:9310/tcp \
--ipc=shareable \
--restart=always \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=nginx \
federatedai/nginx:${TAG}

# create fateboard (depends on python)
docker run -d \
--name ${USER}_confs${PARTY}_fateboard \
-p ${PORT_FATEBOARD}:8080/tcp \
-v ${BASE_DIR}/confs-${PARTY}/confs/fateboard/conf:/data/projects/fate/fateboard/conf \
-v ${USER}_confs${PARTY}_fate_flow_logs:/data/projects/fate/logs \
--ipc=shareable \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=fateboard \
federatedai/fateboard:${TAG}

# create client (depends on python)
docker run -d \
--name ${USER}_confs${PARTY}_client \
-p ${PORT_CLIENT}:15000/tcp \
--restart=always \
-e "FATE_FLOW_HOST=python:9380" \
-e "FATE_SERVING_HOST=172.16.0.160:8059" \
-v ${USER}_confs${PARTY}_download_dir:/fml_manager/Examples/download_dir \
-v ${USER}_confs${PARTY}_shared_dir_examples:/data/projects/fate/examples \
-v ${BASE_DIR}/confs-${PARTY}/confs/fate_flow/conf:/data/projects/fate/conf \
-v ${BASE_DIR}/confs-${PARTY}/confs/client/pipeline_conf.yaml:/data/projects/fate/conf/pipeline_conf.yaml \
--ipc=shareable \
--network=${USER}_confs${PARTY}_fate-network \
--network-alias=client \
federatedai/client:${TAG}
fi

if [ $1 = 'stop' ];then
docker stop ${USER}_confs${PARTY}_sql
docker stop ${USER}_confs${PARTY}_clustermanager
docker stop ${USER}_confs${PARTY}_nodemanager
docker stop ${USER}_confs${PARTY}_rollsite
docker stop ${USER}_confs${PARTY}_python
docker stop ${USER}_confs${PARTY}_fateboard
docker stop ${USER}_confs${PARTY}_client
fi

if [ $1 = 'start' ];then
docker start ${USER}_confs${PARTY}_sql
docker start ${USER}_confs${PARTY}_clustermanager
docker start ${USER}_confs${PARTY}_nodemanager
docker start ${USER}_confs${PARTY}_rollsite
docker start ${USER}_confs${PARTY}_python
docker start ${USER}_confs${PARTY}_fateboard
docker start ${USER}_confs${PARTY}_client
fi
