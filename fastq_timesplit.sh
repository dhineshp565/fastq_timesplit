#!/bin/bash
# this script will sort fastq file generated using oxford nanopore technology based on time points and split the based on provided time intervals
# $1 directory with fastq files
# $2 time interval in minutes

# get the start time by sorting the file basen on start_time and getting the first line
starttime=$(zcat $1/*.gz|awk -F'[-=]' '/start_time/ {print $5 $0}'|cut -f6 -d' '|sort|sed 's/start_time=//'|head -n 1)
# get the end time by sorting the file basen on start_time and getting the last line
endtime=$(zcat $1/*.gz|awk -F'[-=]' '/start_time/ {print $5 $0}'|cut -f6 -d' '|sort|sed 's/start_time=//'|tail -n 1)
# formatting inputs for the python script 
time_to=$(date -d "${starttime}" +"%Y-%m-%dT%H:%M:%S%z")
time_from=$(date -d "${starttime}" +"%Y-%m-%dT%H:%M:%S%z")
# formatting end time to detemins the stopping point
time_end=$(date -d "${endtime}" +"%Y-%m-%dT%H:%M:%S%z")
# generae a listfile for each time interval
echo "${time_from}    ${endtime}" >> timelist.csv
# print startime to stdout for 
echo "Original timestamp: ${time_to}"
# get the nasname of the file to genarte results file with same file name
base_name=$(basename "$1")
# conactenate files within fastq directory
zcat $1/*.gz > ${base_name}.fastq.gz
# for loop to include file genearted until 72 hrs (0.5hr for each cycle)
for ((i=1; i<=144; i++));do
    # add $2 minutes to the start time to get the time_to for python script
    time_to=$(date -d "${time_to} + $2 minutes" +"%Y-%m-%dT%H:%M:%S%z")
    # condition for stopping the loop if the time_to exceeds the endtime
    if [[ $(date -d "${time_to}" +%s) -gt $(date -d "${time_end}" +%s) ]];then
        echo "Time exceeds"
    # get the whole run
        mkdir -p ${base_name}_wholerun
        cp ${base_name}.fastq.gz ${base_name}_wholerun/${base_name}_wholerun.fastq
        break
    fi
    # generate names for output directory and fastq file
    minutes=$(($2 * $i))
    mkdir -p ${base_name}_${minutes}_mins
    # printing time stamp
    echo "Timestamp after +${i} increments: ${time_to}"
    # run python script
    python nanopore_timefilt.py ${base_name}.fastq.gz --time_from ${time_from} --time_to ${time_to} > "${base_name}"_"${minutes}"_mins/"${base_name}"_"${minutes}"_mins.fastq
    # print new time from and time to to the list file
    echo "${time_from}    ${time_to}" >> timelist.csv
done

