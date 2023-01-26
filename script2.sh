#! /bin/bash


declare -a allString
allString=()
# allString[2]=far


function MostRequestIP()
{
	max_qty=0
	id_address=$(awk '/GET/ {print $1}' apache_logs.txt)

	for i in $id_address;
	do
		max=$(grep -o $i <<< $id_address -c)
		if [ $max -gt $max_qty ]; then
			ip=$i
			max_qty=$max
		fi
	done

	echo 'Ip address' $ip 'occurs in file' $max_qty 'times'
}

function MostRequestPage()
{	
	max_qty=0
	 qty_slash=0
	pages=$(awk '{print $7}' apache_logs.txt)

	for i in $pages;
	do
		if [ $i = "/" ]; then
			((qty_slash+=1))
		else
			max=$(grep -o $i <<< $pages -c)
			if [ $max -gt $max_qty ]; then
				page=$i
				max_qty=$max
			fi
		fi
	done
	if [ $max_qty -gt $qty_slash ]; then
		echo 'Page' $page 'occurs in file' $max_qty 'times'
	else
		echo 'Page "/" occurs in file' $qty_slash 'times'
	fi
	
}


function RequestFromEachIP()
{
	id_address=$(awk '/GET/ {print $1}' apache_logs.txt)
	uniq_id_address=$(awk '/GET/ {print $1}' apache_logs.txt | sort -u)
	
	for i in $uniq_id_address;
	do
		echo 'Ip address' $i 'made' $(grep -o $i <<< $id_address -c) 'requests'
	done
}

function NonExistentPages()
{	
	declare -A array;
	pages=$(awk '$9 !~ /^2[0-9][0-9]/ {print $7,$9}' apache_logs.txt | sort -u)
	for i in $pages;
	do
		A+=($i)
		
	done

	
	for ((k=0; k<${#A[@]}; k+=2));
	do
		((j=$k+1))
		echo 'The page' ${A[k]} 'did not find. Code Error "'${A[j]}'"'
	done
}

function MostRequestTime()
{	
	hour=()
	min=()
	max_qty=0

	dates=$(awk '/GET/ {print $4}' apache_logs.txt)

	for i in $dates
	do
		hours+=$( echo $i | cut -d ':' -f2 )" "
		mins+=$( echo $i | cut -d ':' -f3 )" "
		# time=$i | cut -d ':' -f2 + $i | cut -d ':' -f3
		# A+=($time)
	done

	for k in $hours
	do
		hour+=($k)
	done
	
	for n in $mins
	do
		min+=($n)
	done

	for ((j=0; j<${#hour[@]}; j++))
	do
		max=$(grep -o ${hour[j]}':'${min[j]} <<< $dates -c)
			if [ $max -gt $max_qty ]; then
				time=${hour[j]}':'${min[j]}
				max_qty=$max
			fi
	done

	echo 'In the time' $time 'site get' $max_qty 'requests'
}

function SearchBots()
{
	arr_bots=()
	bots=$(awk '/bot/ {print $1,$(NF-1)}' apache_logs.txt | sort -u)
	arr_bots=($bots)

	for ((j=0; j<${#arr_bots[@]}; j+=2))
	do
		echo "IP" ${arr_bots[j]} "used bot -" ${arr_bots[j+1]}
	done

}


echo "-------------1. From which ip were the most requests?-------------"
MostRequestIP
echo "-------------2. What is the most requested page?-------------"
MostRequestPage
echo "-------------3. How many requests were there from each ip?-------------"
RequestFromEachIP
echo "-------------4. What  were clients referred to?-------------"
NonExistentPages
echo "-------------5. What time did site get the most requests?-------------"
MostRequestTime
echo "-------------6. What search bots have accessed the site?-------------"
SearchBots

# echo $line
# echo "----------------"
# echo ${allCString[@]}
# allString+=(six)
# echo "----------------"
# echo ${allCString[@]}
