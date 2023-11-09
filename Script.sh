#! /bin/bash
clear
echo "Starting Script"
#mkdir ~/Desktop/backup
#cp /etc/passwd ~/Desktop/backup/
#cp /etc/group ~/Desktop/backup/
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
echo "Disabling Guest Account"
echo allow-guest=false >> /etc/lightdm/lightdm.conf
sleep .5















