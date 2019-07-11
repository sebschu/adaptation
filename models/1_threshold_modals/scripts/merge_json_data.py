import json

## script to merge the data used for parameter estimation (conditions 0-14
## were prepared before the remaining 6 conditions)

orig_data = json.load(open("../data/data_workerids.json"))
add_data = json.load(open("../data/data_workerids_cond15-20.json"))

orig_data["obs"].extend(add_data["obs"])

json.dump(orig_data, open("../data/data_workerids_cond0-20.json", "w"))