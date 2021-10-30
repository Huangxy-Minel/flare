# Flare
**Flare** (Federated Learning AcceleRation Engine) is a **distributed machine learning system for Federated Learning**. We build Flare based on [FATE](https://github.com/FederatedAI/FATE) and deploy it using **Docker**. Flare provides a high-performance distributed FL computation model and a friendly programming model. The main technologies include *dynamic dataflow execution*, *heterogeneous secret computing accelerator* and *inter-party communication scheduler*.

## Installation
In this section, we will introduce how to use Docker to deploy flare quickly.

### Prerequisites
1. Docker 18+
2. Add user into docker group

### Deploy flare using docker step by step
**Step 1: Change file name**
Rename flare/fate/confs-* to your party number, such as *confs-10000*
**Step 2: Create folders**
Transfer path to flare/fate/confs-10000 using cd ./fate/confs-10000
Run: sh create_dir.sh
**Step 3: Edit confs files**
Local ip means the ip address of the machine;
Docker ip means the ip address of docker network.
1. confs/fate_flow/conf/service_conf: change [servings][hosts] to your local ip.
2. confs/fate_flow/conf/pulsar_route_table.yaml: Configure routing table.
3. confs/fate_flow/conf/rabbitmq_route_table.yaml: Configure routing table.
4. confs/nginx/route_table.yaml: Configure routing table.

**Step 4: Edit shell files**
The ports in shell files mean local ports. You must make sure that all ports are **not occupied** and the ip address of docker network is **not occupied** as well.
For all shell files (such as create_container.sh), you need to edit variables in the front of the shell files, such as USER, BASE_DIR, Party and so on.

### Create docker containers
We provide three types of container sets: 
1. standalone: Run flare just in one machine.
2. cluster master: Run flare in a cluster and this machine is cluster manager.
3. cluster worker: Run flare in a cluster and this machine is cluster worker.

