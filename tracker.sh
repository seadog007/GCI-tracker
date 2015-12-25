#!/bin/bash
# If you are using OSX, you can use `brew install jq` to install jq library
# If you are using Debian, Ubuntu, or something, then you can use `sudo apt-get install jq`
# I don't use yum and rpm system, so XDDDD Google it!
# Oh, Windows user? Sorry, you need a unix system.

while read input
do
	res=`curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/$input/"`
	detail=`echo $res | jq .detail`
	if [ "$detail" = '"Not found."' ]
	then
		echo "Warning: your input is not taskid, try to covert to taskid."
		taskid=`curl -s -D - "https://codein.withgoogle.com/dashboard/task-instances/$input/" | grep Location | grep -oh '[[:digit:]]\+'`
		res=`curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/$taskid/"`
		testdata=`echo "$res" | jq .name`
		[ "$testdata" = "null" ] && echo "Still wrong, please check your input" && exit 1
		[ "$testdata" != "null" ] && echo "Guess correct, the id is instance id." && echo "Task ID of $input is: $taskid" && echo ''
	fi

	# Base data
	name=`echo "$res" | jq -r .name`
	claimed_count=`echo "$res" | jq .claimed_count`
	max_instances=`echo "$res" | jq .max_instances`

	[ "$name" != "null" ] && echo -e "$name\t$claimed_count/$max_instances"
done < tasklist
