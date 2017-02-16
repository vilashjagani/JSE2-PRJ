#!/bin/bash
python /usr/lib/cgi-bin/main.py
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups


echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"
echo "<h1> <font color="#FFC300"> Map user with Group</font></h1>"
echo " <form action="user-group-map-call.sh" method="get">
    <font color="#FFC300">Enter user RIL Email ID:</font>
    <input type="text" name="emailid" maxlength="120" size="30">"
echo "<font color="#FFC300"> Group Name: </font><select name="grpname">"
         for i in `cat /usr/lib/cgi-bin/tmp/groups | awk {'print $1'}`
           do
             echo " <option value="$i">$i</option>"
          done
      echo "</select>"
    

 echo "<input type="submit" value="Submit"> </form>" 


echo "</center>"
echo "</body>"
echo "</html>"
