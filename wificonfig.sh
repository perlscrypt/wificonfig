#!/bin/sh

# written 20230928 - John O'Sullivan john.osullivan@resourcekraft.com
# version 1.1 - 20230929 - backup file
# designed and tested on Ubiquiti UAP-AC-M firmware version 5.43.56

TIMEDATESTAMP=`date -I'seconds'`

WORKINGFILE=/tmp/system.cfg

echo "This script will write changes to $WORKINGFILE. A backup will be saved in $WORKINGFILE.$TIMEDATESTAMP."
cp $WORKINGFILE $WORKINGFILE.$TIMEDATESTAMP
echo ""

# begin SSID config

echo "Original SSID entries..."
grep aaa.1.ssid $WORKINGFILE
grep aaa.2.ssid $WORKINGFILE
grep wireless.1.ssid $WORKINGFILE
grep wireless.2.ssid $WORKINGFILE

echo "Enter new SSID for this AP. (No spaces or \\ allowed) Just hit enter to skip ssid config:"
 
read RDNEWSSID
NEWSSID=${RDNEWSSID// /}

if [ ! -z "$NEWSSID" ]
then
	echo "new ssid is $NEWSSID"
	echo "writing new entries to $WORKINGFILE"
	sed -i 's/aaa\.1\.ssid\=.*/aaa\.1\.ssid\='"$NEWSSID"'/' $WORKINGFILE
	sed -i 's/aaa\.2\.ssid\=.*/aaa\.2\.ssid\='"$NEWSSID"'/' $WORKINGFILE
	sed -i 's/wireless\.1\.ssid\=.*/wireless\.1\.ssid\='"$NEWSSID"'/' $WORKINGFILE
	sed -i 's/wireless\.2\.ssid\=.*/wireless\.2\.ssid\='"$NEWSSID"'/' $WORKINGFILE
else
	echo "Skipping ssid configuration..."
fi

echo "Post config SSID entries..."
grep aaa.1.ssid $WORKINGFILE
grep aaa.2.ssid $WORKINGFILE
grep wireless.1.ssid $WORKINGFILE
grep wireless.2.ssid $WORKINGFILE

# finished SSID config

echo ""

# begin WIFIPASSWORD config

echo "Original wifi password entries..."
grep aaa.1.wpa.psk $WORKINGFILE
grep aaa.2.wpa.psk $WORKINGFILE

echo "Enter new wifi password for this AP. (No spaces or \\ allowed) Just hit enter to skip wifi password config:"

read RDNEWWIFIPASSWORD
NEWWIFIPASSWORD=${RDNEWWIFIPASSWORD// /}

if [ ! -z "$NEWWIFIPASSWORD" ]
then
	echo "new wifi password is $NEWWIFIPASSWORD"
        echo "writing new entries to $WORKINGFILE"
	sed -i 's/aaa\.1\.wpa\.psk\=.*/aaa\.1\.wpa\.psk\='"$NEWWIFIPASSWORD"'/' $WORKINGFILE
	sed -i 's/aaa\.2\.wpa\.psk\=.*/aaa\.2\.wpa\.psk\='"$NEWWIFIPASSWORD"'/' $WORKINGFILE
else
	echo "Skipping wifi password configuration..."
fi

echo "Post config wifi password entries..."
grep aaa.1.wpa.psk $WORKINGFILE
grep aaa.2.wpa.psk $WORKINGFILE

# finish WIFIPASSWORD config

echo ""
echo "The $WORKINGFILE has been modified. A backup was saved in $WORKINGFILE.$TIMEDATESTAMP."
echo "To write all these changes to flash and reboot the system, do the following..."
echo "(sleep 100s; reboot) &          <-- type this command verbatim"
echo "syswrapper.sh apply-config      <-- type this command verbatim"
echo "wait 100 seconds and the system will reboot"

exit

