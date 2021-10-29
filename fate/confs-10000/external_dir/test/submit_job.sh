FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py

CONFPITH=/data/projects/fate/external_files/test/test_conf.json
DSLPATH=/data/projects/fate/external_files/test/test_dsl.json

# submit job
python $FLOWPATH -f submit_job -c $CONFPITH -d $DSLPATH
