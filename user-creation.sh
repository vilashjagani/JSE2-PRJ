#!/bin/bash
python /usr/lib/cgi-bin/main.py
query_string=$QUERY_STRING;
#USRNAME=`echo $query_string | sed -e 's/username=//g'`
USERNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $1'} | sed -e 's/username=//g'`
PASS=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $2'} | sed -e 's/password=//g' | sed -e 's/%21/!/g' -e 's/%22/"/g' -e 's/%23/#/g' -e 's/%24/$/g' -e 's/%25/%/g' -e 's/%26/\&/g' -e 's/%28/(/g' -e 's/%29/)/g' -e 's/%2A/*/g' -e 's/%2B/+/g' -e 's/%2D/-/g' -e 's/%40/@/g' -e 's/%5E/\^/g'`
PRJNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $3'}| sed -e 's/prjname=//g'`

#echo "$USERNAME $PASS $PRJNAME"
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects
PRJID=`cat /usr/lib/cgi-bin/tmp/projects | grep $PRJNAME | awk {'print $2'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/roles -k  | json_pp| jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/roles
ROLID=`cat /usr/lib/cgi-bin/tmp/roles | grep "_member_" | awk {'print $2'}`

echo 'curl -H "Content-Type: application/json" -s -X POST -H "X-Auth-Token: '$TOKEN'" -d '"'"'{''"user"'': {''"default_project_id"'': ''"'$PRJID'"'',''"domain_id"'': ''"default"'',''"enable"'': ''"true"'',''"name"'': ''"'$USERNAME'"'',''"password"'': ''"'$PASS'"''}}'"'"' https://'$IP':5000/v3/users -k ' > /usr/lib/cgi-bin/tmp/users

bash /usr/lib/cgi-bin/tmp/users | json_pp > /usr/lib/cgi-bin/tmp/usr-create-out
USERID=`cat /usr/lib/cgi-bin/tmp/usr-create-out | grep '"id" ' | sed -e 's/"//g' -e 's/,//g' | awk {'print $3'}`
##echo "$PRJID  $ROLID  $USERID"
curl -H "Content-Type: application/json" -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/users/$USERID/roles/$ROLID -k
#bash /usr/lib/cgi-bin/tmp/test2 | json_pp > /usr/lib/cgi-bin/tmp/grp-create-out
echo "<br>"
echo "<br>"
echo "<font color="#229954"> <h2>User has created </h2> </font> "
echo "<br>"
echo "<br>"
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">User-name</font></th>
    <th><font color="#FFC300">Password</font></th>
    <th><font color="#FFC300">User-id</font></th>
  </tr>"
  echo "<tr><td><font color="#FFFFFF">` echo $USERNAME`</font></td>"
  echo "<td><font color="#FFFFFF">` echo $PASS`</font></td>"
  echo "<td><font color="#FFFFFF">` echo $USERID`</font></td></tr>"
echo "</table>"
echo "</center>"
echo "</body>"
echo "</html>"
