#!/bin/bash
# yes, it can be this easy to find a packet of death in a piece of $10 000 enterprise software
export LC_CTYPE=C; export LANG=C;
echo WILYGHETTOFUZZ
echo ==============

target="10.10.10.10"
declare -a ports; ports=(443);
prepend=""; postpend=""
proto="tcp" # udp or tcp
declare -i debug; debug=0;
declare -i ps; ps=1024

if [ -z `which socat` ] || [ -z `which xxd` ] || [ -z `which head` ] || [ -z `which sed` ]; then
	echo "You need socat, xxd, head and sed."
	exit
fi
 
function ghettofuzz() {
                a=`head -c ${ps} /dev/urandom|sed 's/ //g'`
                echo -n \.
                for port in "${ports[@]}"
                                do          
                                                result_a=`echo $prepend$a$postpend | socat - $proto:$target:$port 2>&1 | grep refused`
                done
                if [ -n "$result_a" ]
                                then
                                                echo "We have crashed the server, saving packets and exiting."
                                                echo "$a"|xxd -p >> wilyghettofuzz-success.packet.txt
                                                exit 1
                fi
}
 
while true;
                do ghettofuzz
done;
 
