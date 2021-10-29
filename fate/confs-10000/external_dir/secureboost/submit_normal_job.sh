FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py

CONFPATH=/data/projects/fate/examples/dsl/v2/hetero_secureboost/test_secureboost_train_binary_conf.json
DSLPATH=/data/projects/fate/examples/dsl/v2/hetero_secureboost/test_secureboost_train_dsl.json

python $FLOWPATH -f submit_job -c $CONFPATH -d $DSLPATH
