#!/bin/bash
python /usr/lib/cgi-bin/main.py
echo " <form action="project-creation.sh" method="get">
    <h1><font color="#FFC300">  Project name:</font></h1> <font color="#FFC300"> [don't use space and special characters in project name] </font>
    <input type="text" name="prjname" maxlength="120" size="30">
  <input type="submit" value="Submit">
</form>" 


echo "</center>"
echo "</body>"
echo "</html>"
