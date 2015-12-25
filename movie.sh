#!/bin/bash
c=0
while read line
do
	c=$((c + 1))
	echo ============$c============
	echo $line
done < <(curl "http://loklak.org/api/search.json?q=Star%20Wars%3A%20The%20Force%20Awakens" | jq -r '.statuses[].text')
