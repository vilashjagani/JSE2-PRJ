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
if [ $RSRCNAME == "nova" ] ;
then
echo " <form action="project-quota-update-nova-update.sh" method="get">"
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:8774/v2.1/$ADMID/os-quota-sets/$PRJID -k  | python -m json.tool > /usr/lib/cgi-bin/tmp/tenant-quota-nova
echo "<h1><font color="#FFC300"> Compute Quota for Project  $PRJNAME </font></h1>"
   echo "<font color="#FFC300">Project-Name: <input type="text" name="prjname" value="$PRJNAME" ></font><br>"
   for i in `cat nova-resourece-name`
   do 
  echo " <font color="#FFC300">$i: <input type="text" name="$i" value=`grep $i /usr/lib/cgi-bin/tmp/tenant-quota-nova |awk {'print $2'} | sed -e 's/://g' | sed -e 's/,//g'`> </font>" 
   echo "<br>"
  done

else
   echo " <form action="project-quota-update-cinder-update.sh" method="get">"
curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:8776/v1/$ADMID/os-quota-sets/$PRJID -k  | python -m json.tool > /usr/lib/cgi-bin/tmp/tenant-quota-cinder
   echo "<h1><font color="#FFC300"> Block storage Quota for Project  $PRJNAME </font></h1>"
   echo "<font color="#FFC300">Project-Name: <input type="text" name="prjname" value="$PRJNAME" ></font><br>"
   for i in `cat cinder-resource-name`
   do 
  echo " <font color="#FFC300">$i: <input type="text" name="$i" value=`grep $i /usr/lib/cgi-bin/tmp/tenant-quota-cinder |awk {'print $2'} | sed -e 's/://g' | sed -e 's/,//g'`> </font>" 
   echo "<br>"
  done
fi

echo "<input type="submit" value="Submit">"

         
echo "</form>"
echo "</center>"
echo "</body>"
echo "</html>"
