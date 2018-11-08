# tarsnap-zabbix-check

These are just a few quick and dirty scripts I use to monitor my Tarsnap backups with Zabbix. Maybe somebody else finds them useful.

## Problem

Because Tarsnap backups are encrypted there is no API or anything like that.
You have to use the `tarsnap` client with a key, and even that provides very limited metadata.

On top of that I use [acts](https://github.com/alexjurkiewicz/acts) which generates timestamped archive names, which means I cannot easily query for yesterday's backup.

## Workaround

I only monitor for the size values, as given by `tarsnap --print-stats`. In normal operations the total size should always increase and decrease after deleting old archives. If the total size does not change for two days, then there is probably something wrong and Zabbix should raise an alarm.

## Files

* [tarsnap_stats_format.pl](tarsnap_stats_format.pl) only converts the formatting from CSV to zabbix-sender input.
* [cronjob.sh](cronjob.sh) is the main structure, installed as `/usr/local/etc/periodic/daily/tarsnap_zabbix` (under Linux it would go into `/etc/cron.daily`). It shows the data flow from tarsnap, through the conversion, into zabbix-sender.
* [zbx_template.xml](zbx_template.xml) is my Zabbix template. It defines the four trapper items, a graph, and one trigger to detect missing changes.
