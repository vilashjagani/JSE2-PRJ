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
>/usr/lib/cgi-bin/tmp/test2
echo $query_string > /usr/lib/cgi-bin/tmp/local1-string
sed -i 's/&/ /g' /usr/lib/cgi-bin/tmp/local1-string
for i in `cat /usr/lib/cgi-bin/tmp/local1-string` 
   do echo $i, | sed -e 's/=/" : /g' -e 's/^/\"/g' >> /usr/lib/cgi-bin/tmp/test2
done

echo "{" > /usr/lib/cgi-bin/tmp/test3
echo '"quota_set" : {' >>/usr/lib/cgi-bin/tmp/test3
for i in `more /usr/lib/cgi-bin/tmp/test2 | grep -v prjname | awk {'print $1'}`
   do grep $i /usr/lib/cgi-bin/tmp/test2 >> /usr/lib/cgi-bin/tmp/test3
done
echo } >> /usr/lib/cgi-bin/tmp/test3
echo } >> /usr/lib/cgi-bin/tmp/test3
a=`cat  /usr/lib/cgi-bin/tmp/test3 | wc -l`
b=`expr $a - 2`
sed -i "$b s/,//g" /usr/lib/cgi-bin/tmp/test3
curl -H "Content-Type: application/json"  --data @/usr/lib/cgi-bin/tmp/test3 -s -X PUT -H "X-Auth-Token: $TOKEN" https://$IP:8774/v2.1/$ADMID/os-quota-sets/$PRJID -k  |python -m json.tool > /usr/lib/cgi-bin/tmp/updated-nova-qouta

echo "<h1><font color="#FFC300"> Updated Compute Quota for Project  $PRJNAME </font></h1>"
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Resource-Name</font></th>
    <th><font color="#FFC300">Values</font></th>
  </tr>"
   name=`cat /usr/lib/cgi-bin/tmp/updated-nova-qouta | grep -v "quota_set" | grep -v id | grep -v { | grep -v } | awk {'print $1'}`
   for i in $name;
      do
        echo "<tr><td><font color="#FFFFFF">`grep $i /usr/lib/cgi-bin/tmp/updated-nova-qouta | awk {'print $1'} | sed -e 's/://g' | sed -e 's/"//g'` </font></td>"
        echo "<td><font color="#FFFFFF">`grep $i /usr/lib/cgi-bin/tmp/updated-nova-qouta | awk {'print $2'} | sed -e 's/://g' | sed -e 's/,//g'` </font></td></tr>"
      done
echo "</table>"
echo "</form>"
echo "</center>"
echo "</body>"
echo "</html>"
