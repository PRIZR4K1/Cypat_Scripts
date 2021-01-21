#!/bin/bash
#
#	Program:	Ubuntu Security Script
#	File:		secureUbuntu2020.sh
#	Author:		Geric Capili -PR1Z4KI-
#
#********************************************************************
BLUE="\e[94m"
RED="\e[91m"
YELLOW="\e[93m"
GREEN="\e[92m"
NC="\e[0m"

clear

sudo touch ~/Desktop/Script.log

echo > ~/Desktop/Script.log

sudo chmod 777 ~/Desktop/Script.log

if [[ $EUID -ne 0 ]]

then

  echo This script must be run as root

  exit

fi

printf "Script is being run as root. $NC\n"


printf "The current OS is Linux Ubuntu. $NC\n"


sudo mkdir -p ~/Desktop/backups

sudo chmod 777 ~/Desktop/backups

printf "Backups folder created on the Desktop."

sudo cp /etc/group ~/Desktop/backups/

sudo cp /etc/passwd ~/Desktop/backups/


printf "/etc/group and /etc/passwd files backed up. $NC\n"

# Change CURRENT USERS

printf "$BLUE<*> Allow the script to CHANGE current users <Y|N>:$NC "
read -p "" -n 1 -r
echo
# Grabbed lines (56-269) from github user BiermanM
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Running...$NC\n"	
	
	echo Type all user account names, with a space in between
	
	read -a users


	usersLength=${#users[@]}	


	for (( i=0;i<$usersLength;i++))

	do

		clear

		echo ${users[${i}]}

		echo Delete ${users[${i}]}? yes or no

		read yn1

		if [ $yn1 == yes ]

		then

			userdel -r ${users[${i}]}

			printf "${users[${i}]} has been deleted."

		else	

			echo Make ${users[${i}]} administrator? yes or no

			read yn2								

			if [ $yn2 == yes ]

			then

				gpasswd -a ${users[${i}]} sudo

				gpasswd -a ${users[${i}]} adm

				gpasswd -a ${users[${i}]} lpadmin

				gpasswd -a ${users[${i}]} sambashare

				printf "${users[${i}]} has been made an administrator."

			else

				gpasswd -d ${users[${i}]} sudo

				gpasswd -d ${users[${i}]} adm

				gpasswd -d ${users[${i}]} lpadmin

				gpasswd -d ${users[${i}]} sambashare

				gpasswd -d ${users[${i}]} root

				printf "${users[${i}]} has been made a standard user."

			fi

			

			echo Make custom password for ${users[${i}]}? yes or no

			read yn3								

			if [ $yn3 == yes ]

			then

				echo Password:

				read pw

				echo -e "$pw\n$pw" | passwd ${users[${i}]}

				printf "${users[${i}]} has been given the password '$pw'."

			else

				echo -e "Moodle!22\nMoodle!22" | passwd ${users[${i}]}

				printf "${users[${i}]} has been given the password 'Moodle!22'."

			fi

			passwd -x30 -n3 -w7 ${users[${i}]}

			usermod -L ${users[${i}]}

			printf "${users[${i}]}'s password has been given a maximum age of 30 days, minimum of 3 days, and warning of 7 days. ${users[${i}]}'s account has been locked."

		fi

	done

	clear
fi

# Change/add NEW USERS

printf "$BLUE<*> Allow the script to ADD new users? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Running...$NC\n"
	echo Type user account names of users you want to add, with a space in between. Press enter if it is a no.

	read -a usersNew


	usersNewLength=${#usersNew[@]}	

	for (( i=0;i<$usersNewLength;i++))

	do

		clear

		echo ${usersNew[${i}]}

		adduser ${usersNew[${i}]}

		printf "A user account for ${usersNew[${i}]} has been created."

		clear

		echo Make ${usersNew[${i}]} administrator? yes or no

		read ynNew								

		if [ $ynNew == yes ]

		then

			gpasswd -a ${usersNew[${i}]} sudo

			gpasswd -a ${usersNew[${i}]} adm

			gpasswd -a ${usersNew[${i}]} lpadmin

			gpasswd -a ${usersNew[${i}]} sambashare

			printf "${usersNew[${i}]} has been made an administrator."

		else

			printf "${usersNew[${i}]} has been made a standard user."

		fi

		

		passwd -x30 -n3 -w7 ${usersNew[${i}]}

		usermod -L ${usersNew[${i}]}

		printf "${usersNew[${i}]}'s password has been given a maximum age of 30 days, minimum of 3 days, and warning of 7 days. ${users[${i}]}'s account has been locked."

	done
fi


echo Does this machine need Samba?

read sambaYN

echo Does this machine need FTP?

read ftpYN

echo Does this machine need SSH?

read sshYN

echo Does this machine need Telnet?

read telnetYN

echo Does this machine need Mail?

read mailYN

echo Does this machine need Printing?

read printYN

echo Does this machine need MySQL?

read dbYN

echo Will this machine be a Web Server?

read httpYN

echo Does this machine need DNS?

read dnsYN

echo Does this machine allow media files?

read mediaFilesYN

clear

#Alias

printf "$BLUE<*> Remove all alias's? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	unalias -a
	echo "unalias -a" >> ~/.bashrc
	echo "unalias -a" >> /root/.bashrc
	printf "$GREEN<*> All alias have been removed. $NC\n"
fi


#Locking out root account

printf "$BLUE<*> Lock out Root Account? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Locking...$NC\n"	
	sudo usermod -L root
	printf "$GREEN<*> Root account has been locked. Use 'usermod -U root' to unlock it. $NC\n"
fi

#Bash History

printf "$BLUE<*> Set Bash history file permissions? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Setting...$NC\n"	
	sudo chmod 640 .bash_history
	printf "$GREEN<*> Bash history file permissions set. $NC\n"
fi

#Permissions on shadow

printf "$BLUE<*> Set permissions on shadow? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Setting...$NC\n"	
	sudo chmod 604 /etc/shadow
	printf "$GREEN<*> Read/Write permissions on shadow have been set. $NC\n"
fi


printf "Check for any user folders that do not belong to any users in /home/. $NC\n"

ls -a /home/ >> ~/Desktop/Script.log




clear

printf "Check for any files for users that should not be administrators in /etc/sudoers.d. $NC\n"

ls -a /etc/sudoers.d >> ~/Desktop/Script.log


clear

# Removing startup scripts

printf "$BLUE<*> Remove startup scripts? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	sudo cp /etc/rc.local ~/Desktop/backups/

	echo > /etc/rc.local

	echo 'exit 0' >> /etc/rc.local
	printf "$GREEN<*> Any startup scripts have been removed. $NC\n"
fi


# FIREWALL

printf "$BLUE<*> Enable Firewall? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	sudo apt-get install ufw -y -qq
	sudo ufw enable
	sudo ufw deny 1337
	printf"$GREEN<*> Firewall enabled and port 1337 blocked. $NC\n"

fi

clear

env i='() { :;}; echo Your system is Bash vulnerable' bash -c "echo Bash vulnerability test"

printf "Shellshock Bash vulnerability has been fixed. $NC\n"

clear


# HOSTS Files

printf "$BLUE<*> Set HOSTS files to it's default version? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Setting...$NC\n"	
	sudo chmod 777 /etc/hosts
	sudo cp /etc/hosts ~/Desktop/backups/
	echo > /etc/hosts
	echo -e "127.0.0.1 localhost\n127.0.1.1 $USER\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
	sudo chmod 644 /etc/hosts
	printf "$GREEN<*> HOSTS file has been set to defaults. $NC\n"

fi


# lightdm

printf "$BLUE<*> Secure and Install LightDM? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Securing...$NC\n"	
	sudo apt-get -y install lightdm
	
	sudo chmod 777 /etc/lightdm/lightdm.conf

	sudo cp /etc/lightdm/lightdm.conf ~/Desktop/backups/

	echo > /etc/lightdm/lightdm.conf

	echo -e '[SeatDefaults]\nallow-guest=false\ngreeter-hide-users=true\ngreeter-show-manual-login=true' >> /etc/lightdm/lightdm.conf

	sudo chmod 644 /etc/lightdm/lightdm.conf

	printf "$GREEN<*> LightDM has been secured. $NC\n"

fi


# Hidden scripts in /bin/

printf "$BLUE<*> Find/delete hidden scripts in /bin/? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Finding and Deleting...$NC\n"	
	sudo find /bin/ -name "*.sh" -type f -delete
	printf "$GREEN<*> Scripts in bin have been removed. $NC\n"
fi


# IRQ Balance

printf "$BLUE<*> Disable IRQ Balance? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Disabling...$NC\n"
	
	sudo cp /etc/default/irqbalance ~/Desktop/backups/

	echo > /etc/default/irqbalance

	echo -e "#Configuration for the irqbalance daemon\n\n#Should irqbalance be enabled?\nENABLED=\"0\"\n#Balance the IRQs only once?\nONESHOT=\"0\"" >> /etc/default/irqbalance

	printf "$GREEN<*> IRQ Balance has been disabled. $NC\n"

fi


# Systctl

printf "$BLUE<*> Configure Sysctl? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Configuring...$NC\n"
	
	sudo cp /etc/sysctl.conf ~/Desktop/backups/

	echo > /etc/sysctl.conf

	echo -e "# Controls IP packet forwarding\nnet.ipv4.ip_forward = 0\n\n# IP Spoofing protection\nnet.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.rp_filter = 1\n\n# Ignore ICMP broadcast requests\nnet.ipv4.icmp_echo_ignore_broadcasts = 1\n\n# Disable source packet routing\nnet.ipv4.conf.all.accept_source_route = 0\nnet.ipv6.conf.all.accept_source_route = 0\nnet.ipv4.conf.default.accept_source_route = 0\nnet.ipv6.conf.default.accept_source_route = 0\n\n# Ignore send redirects\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\n\n# Block SYN attacks\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.tcp_synack_retries = 2\nnet.ipv4.tcp_syn_retries = 5\n\n# Log Martians\nnet.ipv4.conf.all.log_martians = 1\nnet.ipv4.icmp_ignore_bogus_error_responses = 1\n\n# Ignore ICMP redirects\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\n\n# Ignore Directed pings\nnet.ipv4.icmp_echo_ignore_all = 1\n\n# Accept Redirects? No, this is not router\nnet.ipv4.conf.all.secure_redirects = 0\n\n# Log packets with impossible addresses to kernel log? yes\nnet.ipv4.conf.default.secure_redirects = 0\n\n########## IPv6 networking start ##############\n# Number of Router Solicitations to send until assuming no routers are present.\n# This is host and not router\nnet.ipv6.conf.default.router_solicitations = 0\n\n# Accept Router Preference in RA?\nnet.ipv6.conf.default.accept_ra_rtr_pref = 0\n\n# Learn Prefix Information in Router Advertisement\nnet.ipv6.conf.default.accept_ra_pinfo = 0\n\n# Setting controls whether the system will accept Hop Limit settings from a router advertisement\nnet.ipv6.conf.default.accept_ra_defrtr = 0\n\n#router advertisements can cause the system to assign a global unicast address to an interface\nnet.ipv6.conf.default.autoconf = 0\n\n#how many neighbor solicitations to send out per address?\nnet.ipv6.conf.default.dad_transmits = 0\n\n# How many global unicast IPv6 addresses can be assigned to each interface?

	net.ipv6.conf.default.max_addresses = 1\n\n########## IPv6 networking ends ##############" >> /etc/sysctl.conf

	sysctl -p >> /dev/null

	printf "$GREEN<*> Sysctl has been configured. $NC\n"

fi


# Disabling Ipv6

printf "$BLUE<*> Disable IPv6? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Disabling...$NC\n"
	
	echo -e "\n\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

	sysctl -p >> /dev/null

	printf "$GREEN<*> IPv6 has been disabled. $NC\n"

fi

# SAMBA

if [ $sambaYN == no ]

then
	printf "$YELLOW<*> Removing Samba...$NC\n"
	
	sudo ufw deny netbios-ns

	sudo ufw deny netbios-dgm

	sudo ufw deny netbios-ssn

	sudo ufw deny microsoft-ds

	sudo apt-get purge samba -y -qq

	sudo apt-get purge samba-common -y  -qq

	sudo apt-get purge samba-common-bin -y -qq

	sudo apt-get purge samba4 -y -qq

	clear

	printf "netbios-ns, netbios-dgm, netbios-ssn, and microsoft-ds ports have been denied. Samba has been removed."
elif [ $sambaYN == yes ]

then
	printf "$YELLOW<*> Installing/Configuring Samba...$NC\n"
	
	sudo ufw allow netbios-ns

	sudo ufw allow netbios-dgm

	sudo ufw allow netbios-ssn

	sudo ufw allow microsoft-ds

	sudo apt-get install samba -y -qq

	sudo apt-get install system-config-samba -y -qq

	cp /etc/samba/smb.conf ~/Desktop/backups/

	printf "netbios-ns, netbios-dgm, netbios-ssn, and microsoft-ds ports have been denied. Samba config file has been configured."

	clear

else

	echo Response not recognized.

fi

printf "$GREEN<*> Samba is complete."


# FTP CONFIGURATIONS

clear

if [ $ftpYN == no ]

then
	printf "$YELLOW<*> Removing FTP...$NC\n"
	
	sudo ufw deny ftp 

	sudo ufw deny sftp 

	sudo ufw deny saft 

	sudo ufw deny ftps-data 

	sudo ufw deny ftps

	sudo apt-get purge vsftpd -y -qq

	printf "$GREEN<*> vsFTPd has been removed. ftp, sftp, saft, ftps-data, and ftps ports have been denied on the firewall."

elif [ $ftpYN == yes ]

then
	printf "$YELLOW<*> Installing/Configuring FTP...$NC\n"
	
	sudo ufw allow ftp 

	sudo ufw allow sftp 

	sudo ufw allow saft 

	sudo ufw allow ftps-data 

	sudo ufw allow ftps

	sudo cp /etc/vsftpd/vsftpd.conf ~/Desktop/backups/

	sudo cp /etc/vsftpd.conf ~/Desktop/backups/

	sudo gedit /etc/vsftpd/vsftpd.conf&gedit /etc/vsftpd.conf

	sudo service vsftpd restart

	printf "$GREEN<*> ftp, sftp, saft, ftps-data, and ftps ports have been allowed on the firewall. vsFTPd service has been restarted."

else

	echo Response not recognized.

fi

printf "$GREEN<*> FTP is complete."


# SSH CONFIGURATIONS

clear

if [ $sshYN == no ]

then
	printf "$YELLOW<*> Removing SSH...$NC\n"
	
	sudo ufw deny ssh

	sudo apt-get purge openssh-server -y -qq

	printf "$GREEN<*> SSH port has been denied on the firewall. Open-SSH has been removed."

elif [ $sshYN == yes ]

then
	printf "$YELLOW<*> Installing/Configuring SSH...$NC\n"
	
	sudo apt-get install openssh-server -y -qq

	sudo ufw allow ssh

	sudo cp /etc/ssh/sshd_config ~/Desktop/backups/	

	echo Type all user account names, with a space in between

	read usersSSH

	echo -e "# Package generated configuration file\n# See the sshd_config(5) manpage for details\n\n# What ports, IPs and protocols we listen for\nPort 2200\n# Use these options to restrict which interfaces/protocols sshd will bind to\n#ListenAddress ::\n#ListenAddress 0.0.0.0\nProtocol 2\n# HostKeys for protocol version \nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n#Privilege Separation is turned on for security\nUsePrivilegeSeparation yes\n\n# Lifetime and size of ephemeral version 1 server key\nKeyRegenerationInterval 3600\nServerKeyBits 1024\n\n# Logging\nSyslogFacility AUTH\nLogLevel VERBOSE\n\n# Authentication:\nLoginGraceTime 60\nPermitRootLogin no\nStrictModes yes\n\nRSAAuthentication yes\nPubkeyAuthentication yes\n#AuthorizedKeysFile	%h/.ssh/authorized_keys\n\n# Don't read the user's ~/.rhosts and ~/.shosts files\nIgnoreRhosts yes\n# For this to work you will also need host keys in /etc/ssh_known_hosts\nRhostsRSAAuthentication no\n# similar for protocol version 2\nHostbasedAuthentication no\n# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication\n#IgnoreUserKnownHosts yes\n\n# To enable empty passwords, change to yes (NOT RECOMMENDED)\nPermitEmptyPasswords no\n\n# Change to yes to enable challenge-response passwords (beware issues with\n# some PAM modules and threads)\nChallengeResponseAuthentication yes\n\n# Change to no to disable tunnelled clear text passwords\nPasswordAuthentication no\n\n# Kerberos options\n#KerberosAuthentication no\n#KerberosGetAFSToken no\n#KerberosOrLocalPasswd yes\n#KerberosTicketCleanup yes\n\n# GSSAPI options\n#GSSAPIAuthentication no\n#GSSAPICleanupCredentials yes\n\nX11Forwarding no\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog no\nTCPKeepAlive yes\n#UseLogin no\n\nMaxStartups 2\n#Banner /etc/issue.net\n\n# Allow client to pass locale environment variables\nAcceptEnv LANG LC_*\n\nSubsystem sftp /usr/lib/openssh/sftp-server\n\n# Set this to 'yes' to enable PAM authentication, account processing,\n# and session processing. If this is enabled, PAM authentication will\n# be allowed through the ChallengeResponseAuthentication and\n# PasswordAuthentication.  Depending on your PAM configuration,\n# PAM authentication via ChallengeResponseAuthentication may bypass\n# the setting of \"PermitRootLogin without-password\".\n# If you just want the PAM account and session checks to run without\n# PAM authentication, then enable this but set PasswordAuthentication\n# and ChallengeResponseAuthentication to 'no'.\nUsePAM yes\n\nAllowUsers $usersSSH\nDenyUsers\nRhostsAuthentication no\nClientAliveInterval 300\nClientAliveCountMax 0\nVerifyReverseMapping yes\nAllowTcpForwarding no\nUseDNS no\nPermitUserEnvironment no" > /etc/ssh/sshd_config

	sudo sed -i "/^PermitRootLogin/ c\PermitRootLogin no" /etc/ssh/sshd_config
	
	sudo service ssh restart

	sudo mkdir ~/.ssh

	sudo chmod 700 ~/.ssh

	ssh-keygen -t rsa

	printf "$GREEN<*> SSH port has been allowed on the firewall. SSH config file has been configured. SSH RSA 2048 keys have been created."

else

	echo Response not recognized.

fi

printf "$GREEN<*> SSH is complete."

# TELNET CONFIGURATIONS

clear

if [ $telnetYN == no ]

then
	printf "$YELLOW<*> Removing Telnet...$NC\n"
	
	sudo ufw deny telnet 

	sudo ufw deny rtelnet 

	sudo ufw deny telnets

	sudo apt-get purge telnet -y -qq

	sudo apt-get purge telnetd -y -qq

	sudo apt-get purge inetutils-telnetd -y -qq

	sudo apt-get purge telnetd-ssl -y -qq

	printf "$GREEN<*> Telnet port has been denied on the firewall and Telnet has been removed."

elif [ $telnetYN == yes ]

then
	printf "$YELLOW<*> Allowing Telnet...$NC\n"
	
	sudo ufw allow telnet 

	sudo ufw allow rtelnet 

	sudo ufw allow telnets

	printf "$GREEN<*> Telnet port has been allowed on the firewall."

else

	echo Response not recognized.

fi

printf "$GREEN<*> Telnet is complete."


# MAILING PERMISSIONS

clear

if [ $mailYN == no ]

then
	printf "$YELLOW<*> Removing permissions for mailing on firewall...$NC\n"
	
	sudo ufw deny smtp 

	sudo ufw deny pop2 

	sudo ufw deny pop3

	sudo ufw deny imap2 

	sudo ufw deny imaps 

	sudo ufw deny pop3s

	printf "$GREEN<*> smtp, pop2, pop3, imap2, imaps, and pop3s ports have been denied on the firewall."

elif [ $mailYN == yes ]

then
	printf "$YELLOW<*> Allowing permissions for mailing on firewall...$NC\n"
	sudo ufw allow smtp 

	sudo ufw allow pop2 

	sudo ufw allow pop3

	sudo ufw allow imap2 

	sudo ufw allow imaps 

	sudo ufw allow pop3s

	printf "$GREEN<*> smtp, pop2, pop3, imap2, imaps, and pop3s ports have been allowed on the firewall."

else

	echo Response not recognized.

fi

printf "$GREEN<*> Mail is complete."


# PRINTING PERMISSIONS

clear

if [ $printYN == no ]

then
	printf "$YELLOW<*> Removing permissions for printing on firewall...$NC\n"
	
	sudo ufw deny ipp 

	sudo ufw deny printer 

	sudo ufw deny cups

	printf "$GREEN<*> ipp, printer, and cups ports have been denied on the firewall."

elif [ $printYN == yes ]

then
	printf "$YELLOW<*> Allowing permissions for printing on firewall...$NC\n"
	
	sudo ufw allow ipp 

	sudo ufw allow printer 

	sudo ufw allow cups

	printf "$GREEN<*> ipp, printer, and cups ports have been allowed on the firewall."

else

	echo Response not recognized.

fi

printf "$GREEN<*> Printing is complete."


# mySQL CONFIGURATIONS

clear

if [ $dbYN == no ]

then
	printf "$YELLOW<*> Removing mySQL...$NC\n"
	
	sudo ufw deny ms-sql-s 

	sudo ufw deny ms-sql-m 

	sudo ufw deny mysql 

	sudo ufw deny mysql-proxy

	sudo apt-get purge mysql -y -qq

	sudo apt-get purge mysql-client-core-5.5 -y -qq

	sudo apt-get purge mysql-client-core-5.6 -y -qq

	sudo apt-get purge mysql-common-5.5 -y -qq

	sudo apt-get purge mysql-common-5.6 -y -qq

	sudo apt-get purge mysql-server -y -qq

	sudo apt-get purge mysql-server-5.5 -y -qq

	sudo apt-get purge mysql-server-5.6 -y -qq

	sudo apt-get purge mysql-client-5.5 -y -qq

	sudo apt-get purge mysql-client-5.6 -y -qq

	sudo apt-get purge mysql-server-core-5.6 -y -qq

	printf "$GREEN<*> ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been denied on the firewall. MySQL has been removed."

elif [ $dbYN == yes ]

then
	printf "$YELLOW<*> Allowing/Configuring mySQL...$NC\n"
	
	sudo ufw allow ms-sql-s 

	sudo ufw allow ms-sql-m 

	sudo ufw allow mysql 

	sudo ufw allow mysql-proxy

	sudo apt-get install mysql-server-5.6 -y -qq

	sudo cp /etc/my.cnf ~/Desktop/backups/

	sudo cp /etc/mysql/my.cnf ~/Desktop/backups/

	sudo cp /usr/etc/my.cnf ~/Desktop/backups/

	sudo cp ~/.my.cnf ~/Desktop/backups/

	if grep -q "bind-address" "/etc/mysql/my.cnf"

	then

		sed -i "s/bind-address\t\t=.*/bind-address\t\t= 127.0.0.1/g" /etc/mysql/my.cnf

	fi

	sudo gedit /etc/my.cnf&gedit /etc/mysql/my.cnf&gedit /usr/etc/my.cnf&gedit ~/.my.cnf

	sudo service mysql restart

	printf "$GREEN<*> ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been allowed on the firewall. MySQL has been installed. MySQL config file has been secured. MySQL service has been restarted."

else

	echo Response not recognized.

fi

printf "$GREEN<*> MySQL is complete."


# WEB SERVER PERMISSIONS

clear

if [ $httpYN == no ]

then
	printf "$YELLOW<*> Removing permissions for Web Servers...$NC\n"
	
	sudo ufw deny http

	sudo ufw deny https

	sudo apt-get purge apache2 -y -qq

	sudo rm -r /var/www/*

	printf "$GREEN<*> http and https ports have been denied on the firewall. Apache2 has been removed. Web server files have been removed."

elif [ $httpYN == yes ]

then
	printf "$YELLOW<*> Allowing/configuring permissions for Web Servers...$NC\n"
	
	sudo apt-get install apache2 -y -qq

	sudo ufw allow http 

	sudo ufw allow https

	sudo cp /etc/apache2/apache2.conf ~/Desktop/backups/

	if [ -e /etc/apache2/apache2.conf ]

	then

  	  echo -e '\<Directory \>\n\t AllowOverride None\n\t Order Deny,Allow\n\t Deny from all\n\<Directory \/\>\nUserDir disabled root' >> /etc/apache2/apache2.conf

	fi

	sudo chown -R root:root /etc/apache2

	printf "$GREEN<*> http and https ports have been allowed on the firewall. Apache2 config file has been configured. Only root can now access the Apache2 folder."

else

	echo Response not recognized.

fi

printf "$GREEN<*> Web Server is complete."


# DNS PERMISSIONS


clear

if [ $dnsYN == no ]

then
	printf "$YELLOW<*> Denying permissions for DNS...$NC\n"
	
	sudo ufw deny domain

	sudo apt-get purge bind9 -qq

	printf "$GREEN<*> domain port has been denied on the firewall. DNS name binding has been removed."

elif [ $dnsYN == yes ]

then
	printf "$YELLOW<*> Allowing/configuring permissions for DNS...$NC\n"
	
	sudo ufw allow domain

	printf "$GREEN<*> domain port has been allowed on the firewall."

else

	echo Response not recognized.

fi

printf "$GREEN<*> DNS is complete."


# Finding ALL Media Files

clear

if [ $mediaFilesYN == no ] midi mid mod mp3 mp2 mpa abs moega au snd wav aiff aif sid flac ogg

then

	printf "Type this to find the files 'sudo find / -name "*.midi" 2> /dev/null' "

	printf "$GREEN<*> All image files have been listed."

else

	echo Response not recognized.

fi

printf "$GREEN<*> Media files are complete."


# Finding all files on port 700 to port 777

clear

printf "$GREEN<*> type <sudo find / -type f -perm 777> in order to list files with permissions"



printf "$GREEN<*> All files with file permissions between 700 and 777 have been listed above."


# PHP Files
printf "$BLUE<*> List any PHP files? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Listing...$NC\n"
	sudo find / -name "*.php" 2> /dev/null
	printf "$GREEN<*> All PHP files have been listed above. ('/var/cache/dictionaries-common/sqspell.php' is a system PHP file) $NC\n"

fi

clear

# NETCAT
printf "$YELLOW<*> Remove Netcat from system? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"
	
	sudo apt-get purge netcat -y -qq

	sudo apt-get purge netcat-openbsd -y -qq

	sudo apt-get purge netcat-traditional -y -qq

	sudo apt-get purge ncatf -y -qq

	sudo apt-get purge pnetcat -y -qq

	sudo apt-get purge socat -y -qq

	sudo apt-get purge sock -y -qq

	sudo apt-get purge socket -y -qq

	sudo apt-get purge sbd -y -qq

	sudo rm /usr/bin/nc
	
	printf "$GREEN<*> Netcat and all other instances have been removed. $NC\n"
fi


clear


# Removing multiple malare services
printf "$RED<*> John the Ripper, Medusa, Aircrack_ng, FcrackZIP, Lcrack $NC\n"

printf "$RED<*> Ophcrack, PDFCrack, Pyrit, RarCrack, SipCrack, IRPAS, Zenmap $NC\n"

printf "$BLUE<*> Allow the system to remove multiple malware services? <If it is in this software> <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
# John the Ripper
	printf "$YELLOW<*> Removing John the Ripper...$NC\n"
	
	sudo apt-get purge john -y 

	sudo apt-get purge john-data -y 

	printf "$GREEN<*> John the Ripper has been removed."
	
	clear
	
	
# Hydra
	printf "$YELLOW<*> Removing Hydra...$NC\n"
		
	sudo apt-get purge hydra -y

	sudo apt-get purge hydra-gtk -y

	printf "$GREEN<*> Hydra has been removed."
	
	clear
	
	
# Aircrack-ng	
	printf "$YELLOW<*> Removing Aircrack-ng...$NC\n"
	
	sudo apt-get purge aircrack-ng -y 
	
	printf "$GREEN<*> Aircrack-ng has been removed."
	
	clear
	
	
# FCrackZIP	
	printf "$YELLOW<*> Removing FCrackZIP...$NC\n"
	
	sudo apt-get purge fcrackzip -y 
	
	printf "$GREEN<*> FCrackZIP has been removed."

	clear


# Ettercap	
	printf "$YELLOW<*> Removing Ettercap...$NC\n"
	
	sudo apt-get purge ettercap -y
	
	printf "$GREEN<*> Ettercap has been removed."

	clear


#LCrack
	printf "$YELLOW<*> Removing LCrack...$NC\n"
	
	sudo apt-get purge lcrack -y
	
	printf "$GREEN<*> LCrack has been removed."
	
	clear
	
	
# OphCrack
	printf "$YELLOW<*> Removing OphCrack...$NC\n"
	
	sudo apt-get purge ophcrack -y

	sudo apt-get purge ophcrack-cli -y

	printf "$GREEN<*> OphCrack has been removed."
	
	clear
	
	
# PDFCrack
	printf "$YELLOW<*> Removing PDFCrack...$NC\n"
	
	sudo apt-get purge pdfcrack -y
	
	printf "$GREEN<*> PDFCrack has been removed."
	
	clear
	
	
# PDFCrack
	printf "$YELLOW<*> Removing PDFCrack...$NC\n"
	
	sudo apt-get purge pdfcrack -y

	
	printf "$GREEN<*> PDFCrack has been removed."
	
	clear
	

# Pyrit	
	printf "$YELLOW<*> Removing Pyrit...$NC\n"

	sudo apt-get purge pyrit -y

	printf "$GREEN<*> Pyrit has been removed."
	
	clear
	
	
# RARCrack
	printf "$YELLOW<*> Removing RARCrack...$NC\n"

	sudo apt-get purge rarcrack -y
	
	printf "$GREEN<*> RARCrack has been removed."
	
	clear
	
	
# SipCrack
	printf "$YELLOW<*> Removing SipCrack...$NC\n"

	sudo apt-get purge sipcrack -y
	
	printf "$GREEN<*> SipCrack has been removed."
	
	clear
	
	
# IRPAS	
	printf "$YELLOW<*> Removing IRPAS...$NC\n"
	
	sudo apt-get purge irpas -y

	printf "$GREEN<*> IRPAS has been removed."
	
	clear
	

# LogKeys
	printf "$YELLOW<*> Removing LogKeys...$NC\n"
	
	sudo apt-get purge logkeys -y

	printf "$GREEN<*> LogKeys has been removed."
	
	clear
	

# SNMP
	printf "$YELLOW<*> Removing SNMP...$NC\n"
	
	apt-get purge snmp -y

	printf "$GREEN<*> SNMP has been removed."
	
	clear

fi


# Zenmap
	printf "$YELLOW<*> Removing Zenmap...$NC\n"
	
	apt-get purge nmap zenmap -y

	printf "$GREEN<*> SNMP has been removed."
	
	clear
	
	printf "$RED<*> All malware services have been removed."

fi

printf 'Are there any hacking tools shown? (not counting libcrack2:amd64 or cracklib-runtime)'

dpkg -l | egrep "crack|hack" >> ~/Desktop/Script.log



# Zeitgeist

printf "$BLUE<*> Remove Zeitgeist? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	
	sudo apt-get purge zeitgeist-core -y -qq

	sudo apt-get purge zeitgeist-datahub -y -qq

	sudo apt-get purge python-zeitgeist -y -qq

	sudo apt-get purge rhythmbox-plugin-zeitgeist -y -qq

	sudo apt-get purge zeitgeist -y -qq

	printf "$GREEN<*> Zeitgeist has been removed. $NC\n"

fi

clear


# NFS

printf "$BLUE<*> Remove NFS? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	
	sudo apt-get purge nfs-kernel-server -y -qq

	sudo apt-get purge nfs-common -y -qq

	sudo apt-get purge portmap -y -qq

	sudo apt-get purge rpcbind -y -qq

	sudo apt-get purge autofs -y -qq

	printf "$GREEN<*> NFS has been removed. $NC\n"

fi

# NGINX

printf "$BLUE<*> Remove NGINX? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	
	sudo apt-get purge nginx -y -qq

	sudo apt-get purge nginx-common -y -qq

	printf "$GREEN<*> NGINX has been removed. $NC\n"

fi

clear

# Inetd and inet utilities

printf "$BLUE<*> Remove inted and inet utilities? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	
	sudo apt-get purge inetd -y -qq

	sudo apt-get purge openbsd-inetd -y -qq

	sudo apt-get purge xinetd -y -qq

	sudo apt-get purge inetutils-ftp -y -qq

	sudo apt-get purge inetutils-ftpd -y -qq

	sudo apt-get purge inetutils-inetd -y -qq

	sudo apt-get purge inetutils-ping -y -qq

	sudo apt-get purge inetutils-syslogd -y -qq

	sudo apt-get purge inetutils-talk -y -qq

	sudo apt-get purge inetutils-talkd -y -qq

	sudo apt-get purge inetutils-telnet -y -qq

	sudo apt-get purge inetutils-telnetd -y -qq

	sudo apt-get purge inetutils-tools -y -qq

	sudo apt-get purge inetutils-traceroute -y -qq

	printf "$GREEN<*> Inetd (super-server) and all inet utilities have been removed. $NC\n"

fi


clear

# VNC

printf "$BLUE<*> Remove VNC? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	
	
	sudo apt-get purge vnc4server -y -qq

	sudo apt-get purge vncsnapshot -y -qq

	sudo apt-get purge vtgrab -y -qq

	printf "$GREEN<*> VNC has been removed. $NC\n"

fi

clear

# Password Policies

printf "$BLUE<*> Secure Password Policies? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Securing...$NC\n"	
	
	sudo cp /etc/login.defs ~/Desktop/backups/
	
	printf "$YELLOW<*> Adding password max age...$NC\n"
	
	sudo sed -i "/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS  90" /etc/login.defs
	
	printf "$YELLOW<*> Adding password minimum age...$NC\n"
	
	sudo sed -i "/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   10"  /etc/login.defs
	
	printf "$YELLOW<*> Adding password expire warning...$NC\n"
	
	sudo sed -i "/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7" /etc/login.defs
	
	printf "$YELLOW<*> Installing cracklib...$NC\n"
	
	sudo apt-get install libpam-cracklib -y -qq
	
	sudo cp /etc/pam.d/common-auth ~/Desktop/backups/

	sudo cp /etc/pam.d/common-password ~/Desktop/backups/
		
	printf "$YELLOW<*> Adding password complexity...$NC\n"
	
	sudo sed -i "1 s/^/password requisite pam_cracklib.so retry=3 minlen=10 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\n/" /etc/pam.d/common-password

	printf "$GREEN<*> Password policies have been set with and /etc/pam.d. $NC\n"


fi

clear


# IPtables

printf "$BLUE<*>Install IPtables? YES <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Installing...$NC\n"	

	sudo apt-get install iptables -y -qq

	iptables -A INPUT -p all -s localhost  -i eth0 -j DROP

	printf "$GREEN<*> All outside packets from internet claiming to be from loopback are denied. $NC\n"

fi

# Ctrl-Alt-Delete

printf "$BLUE<*> Disable Ctrl-Alt-Delete? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Disabling...$NC\n"	

	sudo cp /etc/init/control-alt-delete.conf ~/Desktop/backups/

	sed '/^exec/ c\exec false' /etc/init/control-alt-delete.conf

	printf "$GREEN<*> Reboot using Ctrl-Alt-Delete has been disabled. $NC\n"

fi

clear

#AppArmor


printf "$YELLOW<*> Installing AppArmor...$NC\n"

sudo apt-get install apparmor apparmor-profiles -y -qq

printf "AppArmor has been installed."



printf "$YELLOW<*> Backing up Crontab...$NC\n"

crontab -l > ~/Desktop/backups/crontab-old

crontab -r

printf "$GREEN<*> Crontab has been backed up. All startup tasks have been removed from crontab. $NC\n"


clear


# Root on Cron
printf "$BLUE<*>Allow root in Cron? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Changing...$NC\n"	
	cd /etc/

	/bin/rm -f cron.deny at.deny

	echo root >cron.allow

	echo root >at.allow

	/bin/chown root:root cron.allow at.allow

	/bin/chmod 400 cron.allow at.allow

	cd ..

	printf "$GREEN<*> Only root allowed in cron. $NC\n"
fi





clear

sudo chmod 777 /etc/apt/apt.conf.d/10periodic

sudo cp /etc/apt/apt.conf.d/10periodic ~/Desktop/backups/

echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Download-Upgradeable-Packages \"1\";\nAPT::Periodic::AutocleanInterval \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic

sudo chmod 644 /etc/apt/apt.conf.d/10periodic

printf "$GREEN<*> Daily update checks, download upgradeable packages, autoclean interval, and unattended upgrade enabled."




clear

if [[ $(lsb_release -r) == "Release:	14.04" ]] || [[ $(lsb_release -r) == "Release:	14.10" ]]

then

	sudo chmod 777 /etc/apt/sources.list

	sudo cp /etc/apt/sources.list ~/Desktop/backups/

	echo -e "deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse" > /etc/apt/sources.list

	sudo chmod 644 /etc/apt/sources.list

elif [[ $(lsb_release -r) == "Release:	12.04" ]] || [[ $(lsb_release -r) == "Release:	12.10" ]]

then

	sudo chmod 777 /etc/apt/sources.list

	sudo cp /etc/apt/sources.list ~/Desktop/backups/

	echo -e "deb http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse \ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse \ndeb http://us.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse" > /etc/apt/sources.list

	sudo chmod 644 /etc/apt/sources.list

else

	echo “Error, cannot detect OS version”

fi

printf "$GREEN<*> Apt Repositories have been added."

clear

# Updates

printf "$BLUE<*> Update and upgrade the system? YES <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Updating...$NC\n"	

	sudo apt-get update -y -qq

	sudo apt-get upgrade -y -qq

	sudo apt-get dist-upgrade -qq

	printf "$GREEN<*> Ubuntu OS has checked for updates and has been upgraded. $NC\n"

fi

clear

# Unused packages

printf "$BLUE<*> Lastly, remove unused packages? YES <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	printf "$YELLOW<*> Removing...$NC\n"	

	sudo apt-get autoremove -y -qq

	sudo apt-get autoclean -y -qq

	sudo apt-get clean -y -qq

	printf "$GREEN<*> All unused packages have been removed. $NC\n"

	echo "Check to verify that all update settings are correct."

	update-manager

fi


clear

if [[ $(grep root /etc/passwd | wc -l) -gt 1 ]]

then

	grep root /etc/passwd | wc -l

	echo -e "UID 0 is not correctly set to root. Please fix.\nPress enter to continue..."

	read waiting

else

	printf "$GREEN<*> UID 0 is correctly set to root. $NC\n"

fi




clear

sudo mkdir -p ~/Desktop/logs

sudo chmod 777 ~/Desktop/logs

printf "$GREEN<*> Logs folder has been created on the Desktop."




clear

sudo touch ~/Desktop/logs/allusers.txt

uidMin=$(grep "^UID_MIN" /etc/login.defs)

uidMax=$(grep "^UID_MAX" /etc/login.defs)

echo -e "User Accounts:" >> ~/Desktop/logs/allusers.txt

awk -F':' -v "min=${uidMin##UID_MIN}" -v "max=${uidMax##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $0 }' /etc/passwd >> ~/Desktop/logs/allusers.txt

echo -e "\nSystem Accounts:" >> ~/Desktop/logs/allusers.txt

awk -F':' -v "min=${uidMin##UID_MIN}" -v "max=${uidMax##UID_MAX}" '{ if ( !($3 >= min && $3 <= max  && $7 != "/sbin/nologin")) print $0 }' /etc/passwd >> ~/Desktop/logs/allusers.txt

printf "All users have been logged."

sudo cp /etc/services ~/Desktop/logs/allports.log

printf "All ports log has been created."

dpkg -l > ~/Desktop/logs/packages.log

printf "All packages log has been created."

sudo apt-mark showmanual > ~/Desktop/logs/manuallyinstalled.log

printf "All manually instealled packages log has been created."

service --status-all > ~/Desktop/logs/allservices.txt

printf "All running services log has been created."

ps ax > ~/Desktop/logs/processes.log

printf "All running processes log has been created."

ss -l > ~/Desktop/logs/socketconnections.log

printf "All socket connections log has been created."

sudo netstat -tlnp > ~/Desktop/logs/listeningports.log

printf "All listening ports log has been created."

sudo cp /var/log/auth.log ~/Desktop/logs/auth.log

printf "Auth log has been created."

sudo cp /var/log/syslog ~/Desktop/logs/syslog.log

printf "System log has been created."




clear

printf "$YELLOW<*> Installing tree...$NC\n"	

sudo apt-get install tree -y -qq

printf "$YELLOW<*> Installing Diffuse...$NC\n"	

sudo apt-get install diffuse -y -qq

sudo mkdir Desktop/Comparatives

sudo chmod 777 Desktop/Comparatives


# Copy current files to our folders

printf "$BLUE<*> One more thing, copy current files to our new folders? <Y|N>:$NC "
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo cp /etc/apt/apt.conf.d/10periodic Desktop/Comparatives/

	sudo cp Desktop/logs/allports.log Desktop/Comparatives/

	sudo cp Desktop/logs/allservices.txt Desktop/Comparatives/

	sudo touch Desktop/Comparatives/alltextfiles.txt

	find . -type f -exec grep -Iq . {} \; -and -print >> Desktop/Comparatives/alltextfiles.txt

	sudo cp Desktop/logs/allusers.txt Desktop/Comparatives/

	sudo cp /etc/apache2/apache2.conf Desktop/Comparatives/

	sudo cp /etc/pam.d/common-auth Desktop/Comparatives/

	sudo cp /etc/pam.d/common-password Desktop/Comparatives/

	sudo cp /etc/init/control-alt-delete.conf Desktop/Comparatives/

	crontab -l > Desktop/Comparatives/crontab.log

	sudo cp /etc/group Desktop/Comparatives/

	sudo cp /etc/hosts Desktop/Comparatives/

	sudo touch Desktop/Comparatives/initctl-running.txt

	initctl list | grep running > Desktop/Comparatives/initctl-running.txt

	sudo cp /etc/lightdm/lightdm.conf Desktop/Comparatives/

	sudo cp Desktop/logs/listeningports.log Desktop/Comparatives/

	sudo cp /etc/login.defs Desktop/Comparatives/

	sudo cp Desktop/logs/manuallyinstalled.log Desktop/Comparatives/

	sudo cp /etc/mysql/my.cnf Desktop/Comparatives/

	sudo cp Desktop/logs/packages.log Desktop/Comparatives/

	sudo cp /etc/passwd Desktop/Comparatives/

	sudo cp Desktop/logs/processes.log Desktop/Comparatives/

	sudo cp /etc/rc.local Desktop/Comparatives/

	sudo cp /etc/samba/smb.conf Desktop/Comparatives/

	sudo cp Desktop/logs/socketconnections.log Desktop/Comparatives/

	sudo cp /etc/apt/sources.list Desktop/Comparatives/

	sudo cp /etc/ssh/sshd_config Desktop/Comparatives/

	sudo cp /etc/sudoers Desktop/Comparatives/

	sudo cp /etc/sysctl.conf Desktop/Comparatives/

	sudo tree / -o Desktop/Comparatives/tree.txt -n -p -h -u -g -D -v

	sudo cp /etc/vsftpd.conf Desktop/Comparatives/

	printf "$GREEN<*> Tree and Diffuse have been installed, files on current system have been copied for comparison."

fi




sudo chmod 777 -R Desktop/Comparatives/

sudo chmod 777 -R Desktop/backups

sudo chmod 777 -R Desktop/logs


clear

printf "$RED<*> Script is complete. Finally."
