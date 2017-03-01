#!/bin/bash
python /usr/lib/cgi-bin/main.py
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects



echo "<br>"
echo "<br>"
echo " <form action="project-quota-list.sh" method="get">"
echo "<font color="#FFC300"> Poject Name: </font><select name="prjname">"
  for i in `cat /usr/lib/cgi-bin/tmp/projects | awk {'print $1'} | grep -v admin | grep -v service`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"
echo "<font color="#FFC300">Type of Resource: </font><select name="typersource">"
      echo "<option value="nova">Nova</option>"
      echo "<option value="cinder">Cinder</option>" 
echo "<input type="submit" value="Submit">"

echo "</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
