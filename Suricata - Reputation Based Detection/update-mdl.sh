#!/usr/bin/env bash
cat /dev/null > ./mdl.list

#downloads the csv file
wget -q 'https://gitlab.cs.wwu.edu/tsikerm/assignment-files/raw/master/mdl.csv'
#removes the first line from the csv file because it was giving bad input
sed -i '/^$/d' mdl.csv

#reads in the ips from the mdl list into the array delimiting on commas, colons, slashes and quotes to get just IPs
readarray -t mdl_ip < <(awk -F ',' '{print $3}' ./mdl.csv | awk -F ":" '{print $1}' | awk -F "/" '{print $1}' | sed -e 's/^"//' -e 's/"$//')

#gets the total unique occurences of each IP address, delimiting on new lines and sorting
readarray -t count < <((IFS=$'\n'; sort <<< "${mdl_ip[*]}") | uniq -c)

#creates array with occurences and ips stored in unique elements
IFS=' ' read -a score <<< "${count[@]}"

category=1
multiply=1.5
lowb=3
uppb=127
#this for loop goes through each occurence count of the ip and calculates a score by multiplying it by 3
#I was unable to fix error that on the last newline it multiplies nothing by 3 so it will output error
for (( i = 0; i <= "${#score[@]}"; i+=2 )); do

#gets every other index in array to grab just counts
    if [[ $(( $i % 2 )) == 0 ]]; then
    score2=$(echo ${score[$i]}*$multiply | bc -l)
    
    #if the score is less than 3 set it to 1 to fulfill athinas requirements
    if [[ ${score2%%.*} -le ${lowb%%.*} ]]; then
      score2=1
      
    #if the score is greater than 127 set it to 127 to fulfill athinas requirements
    elif [[ ${score2%%.*} -ge ${uppb%%.*} ]]; then
      score2=127
    fi
    
    echo -e "${score[$i+1]},$category,${score2}" >> ./mdl.list
  fi
done

rm ./mdl.csv