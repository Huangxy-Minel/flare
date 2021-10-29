FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py

CONFPITH=/data/projects/fate/examples/dsl/v2/homo_logistic_regression/homo_lr_cv_conf.json
DSLPATH=/data/projects/fate/examples/dsl/v2/homo_logistic_regression/homo_lr_cv_dsl.json

# submit job
python $FLOWPATH -f submit_job -c $CONFPITH -d $DSLPATH
