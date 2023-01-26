#! /bin/bash

Help()
{
	echo "--------------------------------------------"
	echo " "
	echo "-a: display the IP adresses and symbolic names of all hosts in the current subnet"
	echo " "
	echo "-t target_ip: display a list of open system TCP ports"
	echo " "
	echo "--------------------------------------------"
}

function AllDevices()
{
	allConnects=()

	for i in 192.168.1.{1..250};
		do
			if ping -c1 -w1 $i; then
				allConnects+=($i)
				echo 'add'
			fi;
			
		done


	echo "----------------------------------"
	echo "All hosts in subnet 192.168.1.0/24"

	for k in ${allConnects[@]};
		do
			nmap $k | awk '/^Nmap scan report/ {print$5$6}';
		done

}

function Target()
{
	echo $#
	if [ $# -ne 0 ]
	  then
	    nmap -sT -p- $1
	  else
	  	echo "You didn't write target IP"
	fi	

}

while getopts ":hat:" option; do
   case $option in
     h) # display Help
         Help
         exit;;
     a) # Invalid option
         AllDevices
         exit;;
     t) # Invalid option
		 target_ip=$OPTARG
         Target $target_ip
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [ $# -eq 0 ]
  then
    Help
fi