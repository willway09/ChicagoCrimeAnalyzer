USERNAME=$(grep "User" ../server/connection.json | awk '{print $2}' | sed "s/\\\"//g" | sed "s/,/\r/g" | tr -d '\r')
PASSWORD=$(grep "Password" ../server/connection.json | awk '{print $2}' | sed "s/\\\"//g" | sed "s/,/\r/g" | tr -d '\r')
CONNSTR=$(grep "Connect" ../server/connection.json | awk '{print $2}' | sed "s/\\\"//g" | sed "s/,/\r/g" | tr -d '\r')
sqlldr $USERNAME/$PASSWORD@$CONNSTR CONTROL=CrimesTransformed.ctl LOG=../datasources/crimes.log/CrimesTransformed.log BAD=../datasources/crimes.bad/CrimesTransformed.bad skip=1   
