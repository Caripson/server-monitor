#!/bin/bash

CONFIG="endpoints.yml"
INFLUX_URL="http://localhost:8086/api/v2/write?org=server-monitor&bucket=monitoring&precision=s"
TOKEN="mytoken"

parse_yaml() {
    python3 -c "import yaml,sys; print('\n'.join([f'{e['name']}|{e['url']}|{e.get('type','http')}' for e in yaml.safe_load(sys.stdin)['endpoints']]))"
}

while IFS= read -r line; do
    NAME=$(echo $line | cut -d'|' -f1)
    URL=$(echo $line | cut -d'|' -f2)
    TYPE=$(echo $line | cut -d'|' -f3)
    TIMESTAMP=$(date +%s)

    if [ "$TYPE" = "http" ]; then
        RESULT=$(curl -o /dev/null -s -w "%{time_namelookup}|%{time_connect}|%{time_total}" $URL)
        NLK=$(echo $RESULT | cut -d'|' -f1)
        CNK=$(echo $RESULT | cut -d'|' -f2)
        TTL=$(echo $RESULT | cut -d'|' -f3)
        LINE="monitor,name=$NAME,type=$TYPE time_namelookup=$NLK,time_connect=$CNK,time_total=$TTL $TIMESTAMP"
    elif [ "$TYPE" = "ping" ]; then
        PING=$(ping -c 1 -w 1 $URL | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')
        LINE="monitor,name=$NAME,type=$TYPE ping_time=${PING:-0} $TIMESTAMP"
    fi

    curl -s -XPOST "$INFLUX_URL" \
        -H "Authorization: Token $TOKEN" \
        --data-raw "$LINE"
done < <(parse_yaml < $CONFIG)
