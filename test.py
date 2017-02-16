#!/usr/bin/python
import json
import urllib2
import requests

#defined username ,project and URL for endpoint#####
data = '{"auth": {"tenantName": "admin", "passwordCredentials": {"username": "cas.user1", "password": "Rjil@2017"}}}'

url = 'https://10.144.164.80:5000/v2.0/tokens'

url2 = 'https://10.144.164.80:5000/v3/OS-FEDERATION/mappings/keystone-idp-mapping'
#Generate TOken for user first#####
req = urllib2.Request(url, data, {'Content-Type': 'application/json'})
f = urllib2.urlopen(req)
data = f.read()
values = json.loads(data)
token = values['access']['token']['id']
#Now, read existing mapping from keystone and dump in file
headers = {'X-Auth-Token': token}
r = requests.get(url2,headers=headers,verify=False)
#data1 = r.json()
with open("ril-mapping.json","w") as file1:
    json.dump(r.json(), file1)
#Read json file#####
data1 = json.load(open("ril-mapping.json","r+"))
#data2 = json.dumps(data1['mapping'])
for x in data1['mapping']['rules']:
    if x['local'][1]['group']['id'] == "e83de6a0e3c24160b8a80365bc560f9c": 
        print "Group is already in mapping"   
        for i  in x['remote'][1]['any_one_of']:
            if x['remote'][1]['any_one_of'] == "vilash.jagani@ril.com":
                print "user in rule"
            else:
                print i
        x['remote'][1]['any_one_of'].append('vilas.jagani@ril.com')
        



#remote = json.dumps(data1['mapping']['rules'][0]['remote'][1]['any_one_of'])
#local =  json.dumps(data1['mapping']['rules'][0]['local'][1]['group']['id'])
#print remote 
#print "====================================================================="
#print local
f.close()
