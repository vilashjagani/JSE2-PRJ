#!/bin/bash
python /usr/lib/cgi-bin/main.py
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects
ADMID=`cat /usr/lib/cgi-bin/tmp/projects | grep admin | awk {'print $2'}`
query_string=$QUERY_STRING;
#echo $query_string
PRJNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $1'} | sed -e 's/prjname=//g'`
PRJID=`cat /usr/lib/cgi-bin/tmp/projects | grep $PRJNAME | awk {'print $2'}`
RSRCNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $2'} | sed -e 's/typersource=//g'`

#curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:8774/v2.1/$ADMID/os-quota-sets/$PRJID -k  | python -m json.tool > /usr/lib/cgi-bin/tmp/tenant-quota



echo "<br>"
echo "<br>"
#curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:8774/v2.1/$ADMID/os-quota-sets/$PRJID -k  | python -m json.tool > /usr/lib/cgi-bin/tmp/tenant-quota-nova
echo "<h1><font color="#FFC300"> Compute Quota for Project  $PRJNAME </font></h1>"

echo $query_string > /usr/lib/cgi-bin/tmp/local1-string
echo "`cat /usr/lib/cgi-bin/tmp/local1-string`"

         
echo "</form>"
echo "</center>"
echo "</body>"
echo "</html>"
