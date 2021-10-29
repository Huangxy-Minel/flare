FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py
JSONPATH=/data/projects/fate/external_files/upload/upload_data_guest.json

# upload data
python $FLOWPATH -f upload -c $JSONPATH -drop 1