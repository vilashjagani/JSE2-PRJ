#!/usr/bin/python
import json
import urllib2
import requests
import sys
#defined username ,project and URL for endpoint#####
#data = '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "cas.user1", "password": "Rjil@2017"}}}'
#url = 'https://10.144.164.80:5000/v2.0/tokens'
#url2 = 'https://10.144.164.80:5000/v3/OS-FEDERATION/mappings/keystone-idp-mapping'
#Generate TOken for user first#####
#req = urllib2.Request(url, data, {'Content-Type': 'application/json'})
#f = urllib2.urlopen(req)
#data = f.read()
#values = json.loads(data)
#token = values['access']['token']['id']
#Now, read existing mapping from keystone and dump in file
#headers = {'X-Auth-Token': token}
#r = requests.get(url2,headers=headers,verify=False)
#data1 = r.json()
#with open("tmp/ril-mapping.json","w") as file1:
#    json.dump(r.json(), file1)
#file1.close()
#GrpID = "44b0b2a1201748849db267e22df3b716"
#emailID = "vilash.jagani@ril.com"
GrpID = sys.argv[1]
#emailID = sys.argv[2]
count = 0
with open("tmp/user-group-map-out","r+") as file2:
     data1=json.load(file2)
     ruleCount = len(data1['mapping']['rules'])
     while (ruleCount > 0):
         ruleCount = ruleCount - 1
         if GrpID == data1['mapping']['rules'][ruleCount]['local'][1]['group']['id']:
            for i in data1['mapping']['rules'][ruleCount]['remote'][1]['any_one_of']:
                print i
         else:
             count = count + 1

file2.close()
