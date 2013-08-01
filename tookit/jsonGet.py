#!/usr/bin/python
import sys, json
json_file_name = sys.argv[1]
key = sys.argv[2]

fp = open(json_file_name, 'r')
info_list = json.load(fp)
print info_list[key]
fp.close()

