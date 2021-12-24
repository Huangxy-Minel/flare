# Use to remove data in mysql, fate_flow_logs, namenode, datanode
sudo chown -R xinyang ./shared_dir
rm -rf ./shared_dir/data/datanode/*
rm -rf ./shared_dir/data/namenode/*
rm -rf ./shared_dir/data/pulsar/*
rm -rf ./shared_dir/data/mysql/*
rm -rf ./shared_dir/fate_flow_logs/*