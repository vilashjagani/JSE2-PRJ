#!/bin/bash
python /usr/lib/cgi-bin/main.py
echo " <form action="group-creation.sh" method="get">
    <h1><font color="#FFC300">  Group name:</font></h1> <font color="#FFC300"> [don't use space and special character in Group name] </font>
    <input type="text" name="grpname" maxlength="120" size="30">
  <input type="submit" value="Submit">
</form>" 

echo "</center>"
echo "</body>"
echo "</html>"
