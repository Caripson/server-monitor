#!/bin/bash


###chmod u+x
declare -a arr=("8.8.8.8@SESTO0852-CC1" "99.99.99.99@SESTO0852-CC2")
dnsname="my-server.com"
influddb="127.0.0.1:8086"


for i in "${arr[@]}"
do

      IFS='@' read -ra NAMES <<< "$i"
      sURL=https://${NAMES[0]}/img/36090/r20-100KB.png;timestamp=$(date +%s%N);output=$(/usr/bin/curl -m 120 -Lo /dev/null -skw "time_connect:%{time_connect}\ttime_namelookup:%{time_namelookup}\ttime_pretransfer:%{time_pretransfer}\ttime_starttransfer:%{time_starttransfer}\ttime_redirect:%{time_redirect}\ttime_total:%{time_total}" -H " $dnsname" $sURL);
      for ii in $output; do
      IFS=':' read -ra check <<< "$ii"
      /usr/bin/curl -XPOST http://$influddb/write?db=telegraf --data-binary "cdn-monitor-${NAMES[1]},type=${check[0]}  data=${check[1]} $timestamp"
      done
done
