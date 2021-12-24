import numpy as np

filepath = "/home/xinyang/fate_cluster_1.6.1/flare/fate/confs-10000/shared_dir/fate_flow_logs/202111241042473462280/guest/10000/INFO.log"
match_str = "Encrypt half_d costs: "
num_list = []

with open(filepath, 'r') as f:
    for line in f.readlines():
        idx = line.find(match_str)
        if idx > -1:
            temp_str = line[idx + len(match_str) :]
            time = temp_str.split(' ')[0]
            try: 
                num_list.append(float(time))
            except ValueError:
                pass

print(np.mean(num_list))