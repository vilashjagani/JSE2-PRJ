#!/bin/bash
python /usr/lib/cgi-bin/main.py
query_string=$QUERY_STRING;
#echo $query_string
EMAILID=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $1'} | sed -e 's/emailid=//g' | sed -e 's/\%40/\@/g' | sed -e 's/\<./\u&/g' | sed -e 's/Ril.Com/ril.com/g'`
GRPNAME=`echo $query_string | sed -e 's/\&/ /g' | awk {'print $2'}| sed -e 's/grpname=//g'`

mail=`grep $EMAILID cas-emails`
if [[ -z $mail ]]
then
 if [[ $EMAILID == *"@ril.com" ]]
 then

source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`

#curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://10.144.164.80:5000/v3/projects -k  | json_pp| jshon -e projects -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/projects
#PRJID=`cat /usr/lib/cgi-bin/tmp/projects | grep $PRJNAME | awk {'print $2'}`

curl -H "Content-Type: application/json" -s -X GET -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/groups -k  | json_pp| jshon -e groups -a -e name -u -i n -e id | paste - - |sed -e 's/"//g' > /usr/lib/cgi-bin/tmp/groups
GRPID=`cat /usr/lib/cgi-bin/tmp/groups | grep $GRPNAME | awk {'print $2'}`

python /usr/lib/cgi-bin/user-group-mapping.py $GRPID $EMAILID

curl -H "Content-Type: application/json" --data @tmp/ril-mapping.json -s -X PATCH -H "X-Auth-Token: $TOKEN" https://$IP:5000/v3/OS-FEDERATION/mappings/keystone-idp-mapping -k > /usr/lib/cgi-bin/tmp/user-group-map-out 

python user-group-mapping-read.py $GRPID > /usr/lib/cgi-bin/tmp/mail-id-list


echo "<br>"
echo "<br>"
echo "<br>"
echo "<br>"
echo "<font color="#229954"> <h2>Group $GRPNAME has following users </h2> </font> "
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Email-ID-List for $GRPNAME</font></th>
  </tr>"
   for i in `cat /usr/lib/cgi-bin/tmp/mail-id-list`
  do

  echo "<tr><td><font color="#FFFFFF">`echo $i`</font></td>"
  done

echo "</center>"
echo "</body>"
echo "</html>"

 else
      echo "<br>"
      echo "<br>"
      echo "<br>"
      echo "<br>"
      echo "<font color="#FF0000"> <h2>Please use RIL EMAIL ID for User </h2> </font> "
      echo "</center>"
      echo "</body>"
      echo "</html>"
 fi
else 
  echo "<br>"
  echo "<br>"
  echo "<br>"
  echo "<br>"
  echo "<font color="#229954"> <h2>  $EMAILID is already maped in Group GRP_SUPPORT  </h2> </font> "
  echo "<font color="#FF0000"> <h2> Don't map CAS users with customers project Groups </h2> </font> "
  echo "</center>"
      echo "</body>"
      echo "</html>"
 fi 
> /tmp/ril-mapping.json
>/tmp/user-group-map-out
