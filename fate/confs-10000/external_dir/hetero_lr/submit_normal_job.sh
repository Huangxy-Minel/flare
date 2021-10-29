FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py

CONFPATH=/data/projects/fate/examples/dsl/v2/hetero_logistic_regression/hetero_lr_normal_conf.json
DSLPATH=/data/projects/fate/examples/dsl/v2/hetero_logistic_regression/hetero_lr_normal_dsl.json

python $FLOWPATH -f submit_job -c $CONFPATH -d $DSLPATH
