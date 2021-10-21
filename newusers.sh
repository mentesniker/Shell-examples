#!/bin/bash
while IFS= read -r line
do
	users=$(echo $line | cut -f1 -d:)
	passwd=$(echo $line | cut -f2 -d:)
	uid=$(echo $line | cut -f3 -d:)
	gid=$(echo $line | cut -f4 -d:)
	gecos=$(echo $line | cut -f5 -d:)
	home=$(echo $line | cut -f6 -d:)
	shell=$(echo $line | cut -f7 -d:)
	getent passwd $users > /dev/null
	existentGroup=$( grep -c "$gid" "/etc/group" )
	salt=$( openssl rand -base64 12 )
	hashedpasswd=$( openssl passwd -6 -salt $salt  $passwd )
	if [ existentGroup = 0 ]
	then 
		>&2 echo "WARNING: the group " $gid " doesn't exists"
	else
		if [ $? == 0  ]
		then
			>&2 echo "WARNING: User " $users " already exists"
		else
			sudo useradd -p $hashedpasswd -u $uid -g $gid -c $gecos -m -d $home -s $shell $users
			echo "The user " $users " has been created"
		fi
	fi
done < $1
