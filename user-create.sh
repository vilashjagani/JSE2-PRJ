#!/bin/bash
python /usr/lib/cgi-bin/main.py
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects

echo " <form action="user-creation.sh" method="get" accept-charset="ISO-8859-1">
    <h1><font color="#FFC300">  User name:</font></h1> <font color="#FFC300"> [don't use space and special characters in user name] </font>
    <input type="text" name="username" maxlength="120" size="30">"
echo "<font color="#FFC300">Password: <input type="password" name="password"></font>"
echo "<font color="#FFC300"> Poject Name: </font><select name="prjname">"
  for i in `cat /usr/lib/cgi-bin/tmp/projects | awk {'print $1'} | grep -v admin | grep -v service`
  do
  echo " <option value="$i">$i</option>"
  done
echo "</select>"

echo  "<input type="submit" value="Submit">"
echo "</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
