#!/bin/bash
python /usr/lib/cgi-bin/main.py
query_string=$QUERY_STRING;
#echo $query_string
PRJNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $1'} | sed -e 's/prjname=//g'`
GRPNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $2'}| sed -e 's/grpname=//g'`
ROLNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $3'} |sed -e 's/rolname=//g'`



source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects
PRJID=`cat /usr/lib/cgi-bin/tmp/projects | grep $PRJNAME | awk {'print $2'}`

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups
GRPID=`cat /usr/lib/cgi-bin/tmp/groups | grep $GRPNAME | awk {'print $2'}`

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/roles -k  | json_pp| jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/roles
ROLID=`cat /usr/lib/cgi-bin/tmp/roles | grep $ROLNAME | awk {'print $2'}`

IAAS_READONLY_ROLID=`cat /usr/lib/cgi-bin/tmp/roles | grep IAAS_READONLY | awk {'print $2'}`
IAAS_MEMBER_ROLID=`cat /usr/lib/cgi-bin/tmp/roles | grep IAAS_MEMBER | awk {'print $2'}`
IAAS_ADMIN_ROLID=`cat /usr/lib/cgi-bin/tmp/roles | grep admin | awk {'print $2'}`

if [ $GRPNAME == "GRP_BUSINESS" ] ;
 then
   
curl -H "Content-Type: application/json" -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles/$IAAS_READONLY_ROLID -k
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles -k | json_pp | jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/grp-roles

 elif [ $GRPNAME == "GRP_SUPPORT" ] ;
  then
curl -H "Content-Type: application/json" -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles/$IAAS_MEMBER_ROLID -k
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles -k | json_pp | jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/grp-roles

  elif [ $GRPNAME == "GRP_IAAS_ADMIN" ];
    then
curl -H "Content-Type: application/json" -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles/$IAAS_ADMIN_ROLID -k
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles -k | json_pp | jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/grp-roles
  else
curl -H "Content-Type: application/json" -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles/$ROLID -k
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects/$PRJID/groups/$GRPID/roles -k | json_pp | jshon -e roles -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/grp-roles
      fi

echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"
echo "<font color="#229954"> <h2>Group $GRPNAME has following Roles on project  $PRJNAME  </h2> </font> "
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Role-name</font></th>
    <th><font color="#FFC300">Role-id</font></th>
  </tr>"
   for i in `cat /usr/lib/cgi-bin/tmp/grp-roles | awk {'print $1 "----"$2'}`
  do 

  echo "<tr><td><font color="#FFFFFF">` echo $i |sed -e 's/----/ /g'| awk {'print $1'}`</font></td>"
  echo "<td><font color="#FFFFFF">` echo $i |sed -e 's/----/ /g'| awk {'print $2'}`</font></td></tr>"
  done
echo "</table>"
echo "</center>"
echo "</body>"
echo "</html>"
