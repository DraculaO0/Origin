#!/bin/bash
echo "O R I G I N" | figlet
echo "                             By @DraculaO0"


help()
{
   # Display Help
   echo "This tool is developed for one step reconssiance of origin ips"
   echo
   echo "Syntax: ./origin.sh -d hackerone.com -i -s"
   echo "options:"
   echo "d     Takes input domain for enumeration"
   echo "i     enumerate all the ips and filters the ips which has 200 status code"
   echo "h     Prints the help"
   echo
}
flag=0

while getopts "d:ish" opt 
do 
    case "$opt" in
        d) 
        
            dom=${OPTARG}
            if [[ "$dom" = " " ]]
            then
                echo "exit"
                exit
            else
                echo "Valid domain"
            fi
        
        ;;
        i | is)
            censys search $dom | grep "ip" | egrep -v "description" | cut -d ":" -f2 | tr -d \"\, |tr -d "[:blank:]" | tee ips.txt >> /dev/null
            cat ips.txt | httpx -mc 200 | tee resolved_ip.txt >> /dev/null
            cat resolved_ip.txt
        ;;
        s) 
            echo "Started Scanning ips for open ports"
            cat ips.txt | naabu -v | tee open_ports.txt >> /dev/null
        ;;
        h) 
            help
        ;;
        /?)
            echo "help"
        ;;
    esac
    flag=1
done

if [ $flag -eq 0 ]
then
    help
fi
