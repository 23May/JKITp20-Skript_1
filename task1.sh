#!/bin/bash
# The script which creating users from .txt document with specific params
echo "----------------------Script for creating users-------------------"
echo -e "\n\n"
echo "Text document which contains users should be placed in directory src"

read -p "Enter name of the file which contains users with params: " FILE_USERS

USERS_PATH="./src/$FILE_USERS"
if [[ -f $USERS_PATH ]]; then
	IFS=$'\n'

	for LINE in `(cat $USERS_PATH)`
	do
		username=`echo "$LINE" | cut -d ":" -f1`
		user_group=`echo "$LINE" | cut -d ":" -f2`
		user_password=`echo "$LINE" | cut -d ":" -f3`
		ssl_password=`openssl passwd -1 "$user_password"`
		user_shell=`echo "$LINE" | cut -d ":" -f4`
		if ! grep $username "/etc/passwd"; then
				echo "$username was not found in the system@"
				read -p "Do you want to create a new user $username? [yes/no]" ANS_NEW
				case $ANS_NEW in
					[yY]|[yY][eE][sS])
							if [[ `grep $user_group /etc/group ` ]]; then
									echo "Group $user_group already axists in the system"
									useradd $username -s $user_shell -m -g $user_group -p $ssl_password
							else
								echo "Group $user_group doesn't exist in the system\nIt will be created!"
								groupadd $user_group
								useradd $username -s $user_shell -m -g $user_group -p $ssl_password
							fi
							echo -e "User $username was created!\n"
							;;
				[Nn][nN][Oo])
						echo -e "The creation ofuser $username will skip!\n"
						;;
				*)
						echo "Please enter [yes/no] only!\n"
						;;
		esac
		elif [[ `grep $username "/etc/passwd"` ]]; then
			echo -e "$username was found in system!\n"
			read -p "Do you want to make some changes for $username? (yes/no): " ANSWER_CHANGE
			#case $ANSWER_CHANGES in
			case $ANSWER_CHANGE in
				[yY]|[Yy][Ee][Ss])
					echo "You answered yes!";;
				[Nn]|[Nn][Oo])
					echo "You answered no!";;
				*)
					echo "You need to enter only YES/NO!!!";;
			esac
		fi
	done
	
else
	echo "$FILE_USERS doesnt't exist"
	echo "You need to create a new file!"
fi
