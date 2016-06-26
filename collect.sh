#!/bin/bash

# usage:
# bash ~/collect.sh 2>/dev/null > dmp.txt

echo -e "Current date: $(date)\n"
echo -e "External IP: $(curl -s http://ifconfig.me/ip)\n"
echo -e "Current user: $(id -u)\n"
echo -e "Uptime: $(uptime -p)\n"
echo -e "Kernel version: $(uname -a)\n"
echo -e "Operating System: $(cat /etc/issue)\n"
echo -e "\n\n"

echo -e "**** Environment ****\n"
set
echo -e "\n"

# active logins
echo -e "**** Active logins ****\n"
w
echo -e "\n"

# last logins
echo -e "**** Last logins ****\n"
last
echo -e "\n"

# instance data
echo -e "**** Instance data ****\n"
curl -s http://169.254.169.254/latest/dynamic/instance-identity/document
echo -e "\n\n"

# mounts
echo -e "**** Mounts ****\n"
mount
echo -e "\n"

# installed software
echo -e "**** Installed software ****\n"
# if ubuntu
dpkg -l 
echo -e "\n"

# check suid / guid
echo -e "**** SUID / GID files for root ****\n"
find / -perm /6000 -executable -user root -ls 2>/dev/null
echo -e "\n"

# check processes
echo -e "**** Running processes ****\n"
ps axeuw
echo -e "\n"

# check open file descriptors
echo -e "**** Open file descriptors ****\n"
lsof -T -w
echo -e "\n"

echo -e "**** Listening processes ****\n"
lsof -iTCP -sTCP:LISTEN
echo -e "\n"

echo -e "***** Network configuration **** \n"
ifconfig
echo -e "\n"

echo -e "***** Known hosts ***** \n"
arp -an
echo -e "\n"

echo -e "***** hosts ***** \n"
cat /etc/hosts
echo -e "\n"

echo -e "**** Files last written to since 7 days: ****\n"
find / -mtime -7 -ls 2>/dev/null
echo -e "\n"

echo -e "**** Users ****\n"
cat /etc/passwd
echo -e "\n"

# readable files by current user:
echo -e "**** Readable files by current user ($(id -u)) ****\n"
find / -readable -user $(id -u) -ls 2>/dev/null
echo -e "\n"

# writable files by current user:
echo -e "**** Writable files by current user $((id -u)) ****\n"
find / -writable -user $(id -u) -ls 2>/dev/null
echo -e "\n"

echo -e "**** Socket status ****\n"
cat /proc/net/tcp
echo -e "\n"

# enum all crontabs
for P in "/etc/cron.hourly" "/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.monthly" "/etc/cron.d" "/etc/crontab"
do
	echo -n -e "**** Crontab ($P) ****\n"
	while read LINE; do
		echo -e "$LINE"
	done < <(find $P -ls)
	echo -n -e "\n"
done

echo -e "**** Loaded modules ****\n"
lsmod 
echo -e "\n"

result=$(cat /proc/sys/fs/suid_dumpable)
if [ $result -eq 1 ]; then
	echo -e "VULN: SUID's coredumps are readable by everyone ($result)\n"
fi

if [ -f /sys/module/apparmor/parameters/enabled ]; then
	result=$(cat /sys/module/apparmor/parameters/enabled)
	if [ $result == 'Y' ]; then 
		echo -e "AppArmor enabled\n"
	else 
		echo -e "AppArmor not enabled\n"
	fi
fi


echo -e "\n ****************************************** \n"


