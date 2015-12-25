#!/bin/bash
# If you are using OSX, you can use `brew install jq` to install jq library
# If you are using Debian, Ubuntu, or something, then you can use `sudo apt-get install jq`
# I don't use yum and rpm system, so XDDDD Google it!
# Oh, Windows user? Sorry, you need a unix system.
while read -r res
do

	# Base data
	name=`echo "$res" | jq .name`
	time_to_complete_in_days=`echo "$res" | jq .time_to_complete_in_days`

	# Stat data
	completed_count=`echo "$res" | jq .completed_count`
	active_count=`echo "$res" | jq .active_count`
	in_progress_count=`echo "$res" | jq .in_progress_count`
	waiting_for_review=$(($active_count - $in_progress_count))
		# Fail data
		abandoned_by_mentor_count=`echo "$res" | jq .abandoned_by_mentor_count`
		abandoned_by_student_count=`echo "$res" | jq .abandoned_by_student_count`
		out_of_time_count=`echo "$res" | jq .out_of_time_count`
		failed=$(($abandoned_by_mentor_count + $abandoned_by_student_count + $out_of_time_count))
	claimed_count=`echo "$res" | jq .claimed_count`
	available_count=`echo "$res" | jq .available_count`
	max_instances=`echo "$res" | jq .max_instances`

	echo '--------------------'
	echo "Task Name: $name"
	[ "$time_to_complete_in_days" -gt 1 ] && echo "Time limit: $time_to_complete_in_days days"
	[ "$time_to_complete_in_days" -eq 1 ] && echo "Time limit: $time_to_complete_in_days day"
	echo '--------------------'
	echo "Approved: $completed_count"
	echo "Total Working: $active_count"
	echo "　├─Student not finish: $in_progress_count"
	echo "　└─Waiting for review: $waiting_for_review"
	echo "Failed: $failed"
	echo "　├─Abandoned by mentor: $abandoned_by_mentor_count"
	echo "　├─Abandoned by student: $abandoned_by_student_count"
	echo "　└─Timeout: $out_of_time_count"
	echo "Total claimed: $claimed_count"
	echo "Available instances: $available_count"
	echo "Max instances: $max_instances"
	echo ""
	#[ "$name" != "null" ] && echo -e "$name\t$claimed_count/$max_instances"

done < <(curl -s 'https://codein.withgoogle.com/api/program/2015/taskdefinition/?is_beginner=False&is_exhausted=False&organization=4625502878826496&page=1&page_size=100&status=-1' | jq -c '.results[]')
