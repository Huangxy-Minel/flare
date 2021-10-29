FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py


CONFPATH=/data/projects/fate/examples/dsl/v2/homo_logistic_regression/gzjk_homo_lr_train_conf.json
DSLPATH=/data/projects/fate/examples/dsl/v2/homo_logistic_regression/homo_lr_train_dsl.json

python $FLOWPATH -f submit_job -c $CONFPATH -d $DSLPATH
