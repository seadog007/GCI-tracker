#!/bin/bash
# If you are using OSX, you can use `brew install jq` to install jq library
# If you are using Debian, Ubuntu, or something, then you can use `sudo apt-get install jq`
# I don't use yum and rpm system, so XDDDD Google it!
# Oh, Windows user? Sorry, you need a unix system.
echo '<html>
		<head>
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
		</head>
		<body>
			<table class="table">
				<thead>
					<td width="58%">Task Name</td>
					<td width="7%">Approved</td>
					<td width="7%">Total Working</td>
					<td width="7%">Failed</td>
					<td width="7%">Available instances</td>
					<td width="7%">Total claimed</td>
					<td width="7%">Max instances</td>
				</thead>
			<tbody>'
while read -r res
do

	# Base data
	name=`echo "$res" | jq -r .name`
	time_to_complete_in_days=`echo "$res" | jq -r .time_to_complete_in_days`

	# Stat data
	completed_count=`echo "$res" | jq -r .completed_count`
	active_count=`echo "$res" | jq -r .active_count`
	in_progress_count=`echo "$res" | jq -r .in_progress_count`
	waiting_for_review=$(($active_count - $in_progress_count))
		# Fail data
		abandoned_by_mentor_count=`echo "$res" | jq -r .abandoned_by_mentor_count`
		abandoned_by_student_count=`echo "$res" | jq -r .abandoned_by_student_count`
		out_of_time_count=`echo "$res" | jq -r .out_of_time_count`
		failed=$(($abandoned_by_mentor_count + $abandoned_by_student_count + $out_of_time_count))
	claimed_count=`echo "$res" | jq -r .claimed_count`
	available_count=`echo "$res" | jq -r .available_count`
	max_instances=`echo "$res" | jq -r .max_instances`

	echo '<tr>'
	echo -n "<td>$name</td>"
#	[ "$time_to_complete_in_days" -gt 1 ] && echo "Time limit: $time_to_complete_in_days days"
#	[ "$time_to_complete_in_days" -eq 1 ] && echo "Time limit: $time_to_complete_in_days day"
	echo -n "<td>$completed_count</td>"
	echo -n "<td>$active_count</td>"
#	echo "　├─Student not finish: $in_progress_count"
#	echo "　└─Waiting for review: $waiting_for_review"
	echo -n "<td>$failed</td>"
#	echo "　├─Abandoned by mentor: $abandoned_by_mentor_count"
#	echo "　├─Abandoned by student: $abandoned_by_student_count"
#	echo "　└─Timeout: $out_of_time_count"
	echo -n "<td>$available_count</td>"
	echo -n "<td>$claimed_count</td>"
	echo -n "<td>$max_instances</td>"
	echo '</tr>'
done < <(curl -s 'https://codein.withgoogle.com/api/program/2015/taskdefinition/?is_beginner=False&is_exhausted=False&organization=4625502878826496&page=1&page_size=100&status=-1' | jq -c '.results[]')
echo '</tbody>
	</body>
	</html>'
