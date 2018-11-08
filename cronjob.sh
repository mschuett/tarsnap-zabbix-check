# get tarsnap stats and push to zabbix
tempfile=$(mktemp -t tarsnap_zbx)
which tarsnap &&
tarsnap --print-stats --csv-file $tempfile &&
/usr/local/bin/tarsnap_stats_format.pl < $tempfile \
| zabbix_sender -c /usr/local/etc/zabbix34/zabbix_agentd.conf -i -
rm $tempfile
