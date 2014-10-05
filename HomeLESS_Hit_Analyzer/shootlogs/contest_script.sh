#!/bin/bash
# run this script within CONTEST directory
# contest.html will be created
echo '<html>' > contest.html
echo '<head>' >> contest.html
echo '<title>LinuxAlt 2013</title>' >> contest.html
echo '<meta http-equiv="refresh" content="5">' >> contest.html
echo '</head>' >> contest.html
echo '<body>' >> contest.html
echo '<p style="text-align: center; font-size: x-large; font-weight: bold">LinuxAlt 2013 Shooting</p>' >> contest.html
echo '<table border="1" style="margin-left: auto; margin-right: auto; text-align: center">' >> contest.html
echo '<tr>' >> contest.html
echo '<th>No.</th>' >> contest.html
echo '<th>Name</th>' >> contest.html
echo '<th>Points</th>' >> contest.html
echo '</tr>' >> contest.html
#old
#ls *.slg | sort -t "_" -k 3 -n > contest.sort
#fixed
ls *.slg | sort -t "_" -k2  -n -r > contest.sort


NUMBER=1
while read line
do
POINTS=$(echo $line | cut -f2 -d "_")
#NAME=$(echo $line | cut -f4 -d "_" | cut -f1 -d ".")
NAME=$(echo $line | cut -f4 -d "_" | sed 's/.slg//g' )
echo $NUMBER $POINTS $NAME
echo '<tr>' >> contest.html
echo '<td>'$NUMBER'</td>' >> contest.html
echo '<td>'$NAME'</td>' >> contest.html
echo '<td>'$POINTS'</td>' >> contest.html
echo '</tr>' >> contest.html
let NUMBER+=1
done < contest.sort
echo '</table>' >> contest.html
echo '</body>' >> contest.html
echo '</html>' >> contest.html
