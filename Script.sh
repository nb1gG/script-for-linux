#! /bin/bash
clear
echo "Starting Script"
mkdir ~/Desktop/backup
cp /etc/passwd ~/Desktop/backup/
cp /etc/group ~/Desktop/backup/
cat /etc/passwd
echo "Type all users with spaces in between"
read -a users
for (( i=0; i<${#users[@]}; i++ ))
do 
	echo "Do you want to delete " ${users[i]}
	read -e yn2
	if [[ $yn2 == y ]]
	then
		userdel ${users[i]}
	else
		echo "Admin? " ${users[i]}
		read -e yn
		if [[ $yn == y ]]
		then
			gpasswd -a ${users[i]} sudo
			gpasswd -a ${users[i]} adm
			gpasswd -a ${users[i]} lp
			gpasswd -a ${users[i]} sambashare
			echo ${users[i]} " Is now admin"
		else
	
			gpasswd -d ${users[i]} adm
			gpasswd -d ${users[i]} root
			gpasswd -d ${users[i]} sudo
			gpasswd -d ${users[i]} lp
			gpasswd -d ${users[i]} sambashare
			echo ${users[i]} " Is now regular user"
		fi
		echo "R0ckwall!" | sudo passwd ${users[i]}
		echo "All passwords set to R0ckwall!"
		passwd -x90 -n10 -w7 ${users[i]}
		usermod -L ${users[i]}
		echo "passowrd policy set"
	fi
done
clear
echo "Add users?"
read newUser
for (( i=0; i<${#newUser[@]}; i++ ))
do 
	clear
	useradd ${newUser[i]}
	echo "Added" ${newUser[i]}	
	echo "admin?"
	read -e yn3
	if [[ $yn3 == y ]]
	then
		gpasswd -a ${newUser[i]} sudo
		gpasswd -a ${newUser[i]} adm
		gpasswd -a ${newUser[i]} lp
		gpasswd -a ${newUser[i]} sambashare
		echo ${newUser[i]} " Is now admin"
	else
	
		gpasswd -d ${newUser[i]} adm
		gpasswd -d ${newUser[i]} root
		gpasswd -d ${newUser[i]} sudo
		gpasswd -d ${newUser[i]} lp
		gpasswd -d ${newUser[i]} sambashare
		echo ${newUser[i]} " Is now regular user"
	fi
	echo -e "R0ckwall!\nR0ckwall!" | passwd ${newUser[i]}
	echo "All passwords set to R0ckwall!"
	passwd -x90 -n10 -w7 ${newUser[i]}
	usermod -L ${newUser[i]}
	echo "passowrd policy set"
done
clear

sudo apt-get install libpam-cracklib -y
grep "auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent " /etc/pam.d/common-auth
if [ "$?" -eq "1" ]
then	
	echo "auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent " >> /etc/pam.d/common-auth
	echo -e "password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root" >>  /etc/pam.d/common-password
fi
clear
sed -i '160s/.*/PASS_MAX_DAYS\o01130/' /etc/login.defs
sed -i '161s/.*/PASS_MIN_DAYS\o0113/' /etc/login.defs
sed -i '162s/.*/PASS_MIN_LEN\o0118/' /etc/login.defs
sed -i '163s/.*/PASS_WARN_AGE\o0117/' /etc/login.defs

sed -i 's/EXPIRE=/EXPIRE=30/' /etc/default/useradd
sed -i 's/INACTIVE=/INACTIVE=30' /etc/default/useradd

clear
sudo apt-get install ufw
ufw default deny incoming
ufw default allow outgoing
ufw logging on
ufw logging high
ufw enable
ufw deny 1337

echo "nospoof on" >> /etc/host.conf
unalias -a
usermod -L root
chmod 640 .bash_history
chmod 604 /etc/shadow
clear
cp /etc/rc.local ~/Desktop/
echo > /etc/rc.local
echo 'exit 0' >> /etc/rc.local

touch /usr/share/pam-configs/faillock
echo -e "Name: Enforce failed login attempt counter\nDefault: no\nPriority: 0\nAuth-Type: Primary\nAuth:\n	[default=die] pam_faillock.so authfail\n	sufficient pam_faillock.so authsucc"
touch /usr/share/pam-configs/faillock_notify
echo -e "Name: Notify on failed login attemps\nDefault: no\nPriority: 1024\nAuth-Type: Primary\nAuth:\n	requisite pam_faillock.so preauth
pam-auth-update
clear
: <<'END'
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
END
















