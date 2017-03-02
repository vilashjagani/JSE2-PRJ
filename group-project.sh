#!/bin/bash
python /usr/lib/cgi-bin/main.py
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/roles -k  | json_pp| jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/roles

echo "<br>"
echo "<br>"
echo " <form action="group-project-mapping.sh" method="get">"
echo "<font color="#FFC300"> Poject Name: </font><select name="prjname">"
  for i in `cat /usr/lib/cgi-bin/tmp/projects | awk {'print $1'} | grep -v admin | grep -v service`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"
echo "<font color="#FFC300"> Group Name: </font><select name="grpname">"
  for i in `cat /usr/lib/cgi-bin/tmp/groups | awk {'print $1'} | grep -v GRP_IAAS_ADMIN`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"

echo "<font color="#FFC300"> Role Name: </font><select name="rolname">"
  for i in `cat /usr/lib/cgi-bin/tmp/roles | awk {'print $1'} | grep -v admin | grep -v ResellerAdmin | grep -v IAAS_ADMIN | grep -v IAAS_MEMBER`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"



echo "<input type="submit" value="Submit">"

echo "</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
