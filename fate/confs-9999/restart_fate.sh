bash rm_container.sh

if [ $1 = 'standalone' ];then
# ----------------standalone----------------
bash create_container.sh volume
bash create_container.sh container
fi

if [ $1 = 'manager' ];then
# ----------------cluster manager----------------
bash create_container.sh manager
bash create_container.sh volume
bash create_container.sh container
fi

if [ $1 = 'worker' ];then
# ----------------cluster worker----------------
bash create_worker.sh
fi


