#!/bin/bash
# If you are using OSX, you can use `brew install jq` to install jq library
# If you are using Debian, Ubuntu, or something, then you can use `sudo apt-get install jq`
# I don't use yum and rpm system, so XDDDD Google it!
# Oh, Windows user? Sorry, you need a unix system.

orgid='4625502878826496' #FOSSASIA
#orgid='4568116747042816' #Ubuntu

while true
do
	out=$out`echo '<html>
						<head>
							<meta name="viewport" content="width=device-width, initial-scale=1">
							<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
						</head>
						<body>
							<div class="container" style="padding-top: 20px;">
								<p>'`
	out=$out`echo "Last Update: "``date`
	out=$out`echo '				</p>
								<div class="table-responsive">
									<table class="table table-bordered table-striped">
										<thead>
											<tr>
											<td width="58%">Task Name</td>
											<td width="6%">Time Limit</td>
											<td width="6%">Approved</td>
											<td width="6%">Total Working</td>
											<td width="6%">Failed</td>
											<td width="6%">Available instances</td>
											<td width="6%">Total claimed</td>
											<td width="6%">Max instances</td>
										</tr>
									</thead>
								<tbody>'`
	while read -r res
	do

		# Base data
		name=`echo "$res" | jq -r .name`
		time_to_complete_in_days=`echo "$res" | jq -r .time_to_complete_in_days`
		is_beginner=`echo "$res" | jq -r .is_beginner`
		is_exhausted=`echo "$res" | jq -r .is_exhausted`

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

		if [ "$is_exhausted" == "false" ]
		then
			if [ "$is_beginner" == "false" ]
			then
				out=$out`echo '<tr>'`
			else
				out=$out`echo '<tr class="success">'`
			fi
		else
			out=$out`echo '<tr class="danger">'`
		fi

		out=$out`echo -n "<td>$name</td>"`
		[ "$time_to_complete_in_days" -gt 1 ] && out=$out`echo -n "<td>$time_to_complete_in_days days</td>"`
		[ "$time_to_complete_in_days" -eq 1 ] && out=$out`echo -n "<td>$time_to_complete_in_days day</td>"`
		out=$out`echo -n "<td>$completed_count</td>"`
		out=$out`echo -n "<td>$active_count</td>"`
	#	echo "　├─Student not finish: $in_progress_count"
	#	echo "　└─Waiting for review: $waiting_for_review"
		out=$out`echo -n "<td>$failed</td>"`
	#	echo "　├─Abandoned by mentor: $abandoned_by_mentor_count"
	#	echo "　├─Abandoned by student: $abandoned_by_student_count"
	#	echo "　└─Timeout: $out_of_time_count"
		out=$out`echo -n "<td>$available_count</td>"`
		out=$out`echo -n "<td>$claimed_count</td>"`
		out=$out`echo -n "<td>$max_instances</td>"`
		out=$out`echo '</tr>'`
	#done < <(curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/?is_beginner=False&is_exhausted=False&organization=$orgid&page=1&page_size=1000&status=0" | jq -c '.results[]')
	#done < <(curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/?is_exhausted=False&organization=$orgid&page=1&page_size=1000&status=0" | jq -c '.results[]')
	#done < <(curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/?is_beginner=False&organization=$orgid&page=1&page_size=1000&status=0" | jq -c '.results[]')
	done < <(curl -s "https://codein.withgoogle.com/api/program/2015/taskdefinition/?organization=$orgid&page=1&page_size=1000&status=0" | jq -c '.results[]')
	out=$out`echo '					</tbody>
									</table>
								</div>
							</div>
						</body>
					</html>'`
	echo `date`
	echo $out > index.html
done
