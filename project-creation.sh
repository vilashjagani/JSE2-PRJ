#!/bin/bash
python /usr/lib/cgi-bin/main.py
query_string=$QUERY_STRING;
PRJNAME=`echo $query_string | sed -e 's/prjname=//g'`
#echo "$PRJNAME"
source /usr/lib/cgi-bin/keystonerc
TOKEN=`keystone --insecure token-get | grep id | grep -v 'tenant_id'| grep -v 'user_id' |awk {'print $4'}`
echo 'curl -H "Content-Type: application/json" -s -X POST -H "X-Auth-Token: '$TOKEN'" -d '"'"'{''"project"'': {''"enabled"'': true,''"description"'': ''"'$PRJNAME'"'',''"domain_id"'': ''"default"'',''"name"'': ''"'$PRJNAME'"''}}'"'"' https://'$IP':5000/v3/projects -k ' > /usr/lib/cgi-bin/tmp/test1
bash /usr/lib/cgi-bin/tmp/test1 | json_pp > /usr/lib/cgi-bin/tmp/prj-create-out
echo "<br>"
echo "<br>"
echo "<font color="#229954"> <h2>Project has created </h2> </font> "
echo "<br>"
echo "<br>"
a=`cat /usr/lib/cgi-bin/tmp/prj-create-out  | egrep  '"id"|"name"' |paste - - | sed -e 's/"//g' -e 's/,//g'`
echo " <table border="2" style="width:80%">
  <tr>
    <th><font color="#FFC300">Project-name</font></th>
    <th><font color="#FFC300">Project-id</font></th>
  </tr>"
  echo "<tr><td><font color="#FFFFFF">` echo $a | awk {'print $3'}`</font></td>"
  echo "<td><font color="#FFFFFF">` echo $a | awk {'print $6'}`</font></td></tr>"
echo "</table>"
echo "</center>"
echo "</body>"
echo "</html>"
