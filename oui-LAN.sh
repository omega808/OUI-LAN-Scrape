#!/bin/bash
#Gets the OUI from every Mac Address in your local subnet
#Note:Assuming this is being run on a home class c subnet not enterprise network

#Make file to write to
touch ./OUI_RESULTS.txt
echo "Lookup OUI Results on this wireshark tool: https://www.wireshark.org/tools/oui-lookup.html" >> OUI_RESULTS.txt

#Set up variables
MAC_LIST=( $(seq 1 254 ) ) #Array to hold Mac Addresses
IP_LIST=( $(seq 1 254 ) ) #Array to hold IP Addresses
SUBNET_LENGTH=${!MAC_LIST[@]}
COUNT=0



#iterate through array
for i in $SUBNET_LENGTH;
do
	
	#Theirs proably a better way to simulate a couple of dots moving..
	if [ $COUNT -eq 0 ];
	then
		clear
		echo "Arping the subnet"

	elif [ $COUNT -eq 1 ];
	then
		clear
		echo "Arping the subnet."

	elif [ $COUNT -eq 2 ];
	then
		clear
		echo "Arping the subnet.."
	elif [ $COUNT -eq 3 ];
	then
		clear
		echo "Arping the subnet..."
	fi



	OUI=$( sudo arping -r -c 1 192.168.1.${i} | cut -d ':' -f 1-3  )
	
	IP_LIST[$i]=$( echo "192.168.1.${i}" )
	MAC_LIST[$i]=$OUI
	
	let COUNT++
	
	if [ $COUNT -eq 3 ];
	then
		COUNT=0
	fi

done


#ierate through array, to save results to text
for I in $SUBNET_LENGTH;
do
	#if host isnt active, dont write to file
	if [ -z ${MAC_LIST[$I]} ];
	then
		
		continue
	else
	
		echo "OUI: ${MAC_LIST[$I]} of IP: ${IP_LIST[$I]}" >> OUI_RESULTS.txt

	fi

done


echo " all done"

exit 0
