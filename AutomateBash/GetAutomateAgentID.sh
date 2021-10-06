ComputerID=$(sudo grep -o '"computer_id": *[0-9]*' /usr/local/ltechagent/state | grep -o "[0-9]*$")
if [[ ComputerID -gt 0 ]]
then
	echo "computer_id:$ComputerID"
else
	sleep 20
	echo "computer_id:$(sudo grep -o '"computer_id": *[0-9]*' /usr/local/ltechagent/state | grep -o "[0-9]*$")"
fi
