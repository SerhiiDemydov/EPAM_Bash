#! /bin/bash

function MakeArchiveFile()
{
	
	cp --backup $1* $2
	
}

function CompareTwoDir()
{	
	dir_arr=()
	diff_dir=$(diff $1 $2 | awk '/^Only/ ' | awk '$(NF) !~ /~$/ {print $3}' | cut -d ':' -f1 ) 

	fil_arr=()
	diff_fil=$(diff $1 $2 | awk '/^Only/' | awk '$(NF) !~ /~$/ {print $4}' )

	delet_file_arr=()
	delet_files=$(awk '/deleted/ {print$(NF)}' < $2log.log | sort -u)

	for i in $delet_files;
	do
		delet_file_arr+=($i)
	done
	delet_file_arr+=(six)
	
	find=0

	for i in $diff_dir;
	do
		dir_arr+=($i)
	done

	for i in $diff_fil;
	do
		fil_arr+=($i)
	done
	for ((j=0; j<${#dir_arr[@]}; j++));
	do
		if [ ${fil_arr[j]} != "log.log" ];
		then
			if [ ${dir_arr[j]} == $1 ];
			then
				echo $time "- Was created new file" ${fil_arr[j]} >> $2log.log
			else
				for ((k=0; k<${#delet_file_arr[@]}; k++)); 
				do
					if [ ${fil_arr[j]} == ${delet_file_arr[k]} ];
					then
						find=1
						break
					fi
				done
				if [ $find -ne 1 ];
				then
						echo $time "- Was deleted file" ${fil_arr[j]} >> $2log.log
						delet_file_arr+=(${fil_arr[j]})
						find=0
				fi
			fi
		fi
	done

	chg_file=$(diff -q backup_source/ backup_direction/ | awk '/^Files|differ$/' | cut -d '/' -f2 | cut -d ' ' -f1)

	for i in $chg_file;
	do
		echo $time "- File" $i "was changed" >> $2log.log
	done
}



mkdir -p $2
echo "---------------------------------------" >> $2log.log
time=$(echo $(date) | awk '{print $2,$3,$4,$5}')
echo $time "- Backup was done" >> $2log.log
CompareTwoDir $1 $2
MakeArchiveFile $1 $2

