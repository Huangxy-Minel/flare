FLOWPATH=/data/projects/fate/python/fate_flow/fate_flow_client.py
JSONPATH=/data/projects/fate/external_files/upload/gzjk_upload_data_homo_guest.json

# upload data
python $FLOWPATH -f upload -c $JSONPATH -drop 1