#!/bin/bash

TCPSTAT=`netstat -nt`

echo -n "OK | "

echo "$TCPSTAT"                         |
awk '{ print $6 }'                      |       # Extract TCP state
sort                                    |       # Sort
grep -v ^$                              |       # Remove blank lines
uniq -c                                 |       # Count unique states
awk -v q="'" '{ print q $2 q "=" $1}'   |       # Format status output for Nagios
tr "\n" " "                             |       # Remove newline characters
# Make sure each of the following connection states are listed
awk '$0 !~ /CLOSE_WAIT/ { printf "%s \x27%s\x27=0", $0, "CLOSE_WAIT";next } 1'      |
awk '$0 !~ /SYN_RECV/ { printf "%s \x27%s\x27=0", $0, "SYN_RECV";next } 1'          |
awk '$0 !~ /LAST_ACK/ { printf "%s \x27%s\x27=0", $0, "LAST_ACK";next } 1'          |
awk '$0 !~ /CLOSING/ { printf "%s \x27%s\x27=0", $0, "CLOSING";next } 1'            |
awk '$0 !~ /SYN_SENT/ { printf "%s \x27%s\x27=0", $0, "SYN_SENT";next } 1'          |
awk '$0 !~ /Foreign/ { printf "%s \x27%s\x27=0", $0, "Foreign";next } 1'            |
awk '$0 !~ /TIME_WAIT/ { printf "%s \x27%s\x27=0", $0, "TIME_WAIT";next } 1'        |
awk '$0 !~ /ESTABLISHED/ { printf "%s \x27%s\x27=0", $0, "ESTABLISHED";next } 1'    |
awk '$0 !~ /FIN_WAIT2/ { printf "%s \x27%s\x27=0", $0, "FIN_WAIT2";next } 1'        |
awk '$0 !~ /FIN_WAIT1/ { printf "%s \x27%s\x27=0", $0, "FIN_WAIT1";next } 1'        |
sed 's/$/\n/g'                        # Add newline at end
