FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py

NAMESPACE=experiment
TABLE_NAME=breast_hetero_host
# check table
python $FLOWPATH -f table_info -n $NAMESPACE -t $TABLE_NAME
