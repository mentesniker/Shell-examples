#! /bin/bash

while IFS= read -r line; do
  IFS=' ' read -r -a array <<< "$line"
  var1="${array[1]}"
  var2="${array[2]}"
  if [ $var1 != $var2 ]
       then
	  echo "${array[@]}"
  fi
done < <( ps -e -o pid,ruser,euser,cmd)
