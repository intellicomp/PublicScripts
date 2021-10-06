ECHO OFF
LOCATIONID=$3
cd /tmp&&(
 (rm -f cwaagent.zip; rm -Rf CWAutomate)&>/dev/null
 curl "https://$1/LabTech/Deployment.aspx?InstallerToken=$2" -s -o cwaagent.zip
 [[ $(find cwaagent.zip -type f -size +700000c 2>/dev/null) ]]&&(
  echo "SUCCESS-cwaagent.zip was downloaded"
  unzip -n -d CWAutomate cwaagent.zip &>/dev/null
  [ -f CWAutomate/config.sh ]&&(
   [ -f /usr/local/ltechagent/uninstaller.sh ]&&(echo "Existing installation found. Removing."; /usr/local/ltechagent/uninstaller.sh)
   cd /tmp/CWAutomate&&(
    mv -f config.sh config.sh.bak 2>/dev/null
    [ -f config.sh.bak ]&&sed "s/LOCATION_ID=[0-9]*/LOCATION_ID=$LOCATIONID/" config.sh.bak > config.sh&&[ -f config.sh ]&&echo "SUCCESS-Installer Data Updated for location $LOCATIONID"
    . ./config.sh ; installer -pkg ./LTSvc.mpkg -verbose -target /
    [ -d /usr/local/ltechagent ]&&echo "SUCCESS-computer_id:$(sudo grep -o '"computer_id": *[0-9]*' /usr/local/ltechagent/state | grep -o "[0-9]*$")"
    launchctl list | grep -i "com.labtechsoftware"&&echo "LTService Started successfully"
   )
  )||echo ERROR-Failed to extract
 )||echo ERROR-Failed to download cwaagent.zip
)||echo ERROR-Failed to change path to /tmp