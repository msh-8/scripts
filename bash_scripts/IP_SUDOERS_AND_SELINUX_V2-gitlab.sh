#!/bin/bash
   ####################################################################################################################################
  #                                                                                                                                    #
  #                                            The Network and Sudoer configuration.                                                   #
  #                                                      For CentOS/Red Hat.							      			               #
  #                                                                                                               					   #
  #	author: MSH    contact: mostafa.shoaei@gmail.com																			Ver2.0 #
   ####################################################################################################################################
# realese note v2.0:
# The ip configuration on ubuntu distro fixed.
# The sudoers user mismatching fixed.
# Network service restart for CentOS/RedHat fixed.
# Disabling SELINUX appended for CentOS/RedHat distro.

    ###################################################################################################################################
   #                         		#note: comment for each command wrote above of it.#                                            #
   #                                                                                                                                   #
    ###################################################################################################################################
 #########################################################################################################################################
                                             ##########################################
					    #   	   The Functions.              #
 					    #                                          #
					     ##########################################
#Functions
# The following function pause the page for errors and messages and user has to press related key.#
function pause(){
	read -s -n 1 -p "$(echo -e "\n\n\npress any key to continue...\n\nPress Ctrl+c to 'exit' of script.")"
echo ""
}
# Create an array to fetch the current username list in a function and using for sudoers configuration part.#
function arraylistusers(){
for i in $(grep -E "/home/." /etc/passwd | awk -F":" '{print $1}' | grep -v -E "syslog|cups.");do
					passwdarr+=($i);done
}
#print list users function.
function userlistprint(){
for j in "${passwdarr[@]}";do echo $j ;done  | sed '/./=' | sed '/./N; s/\n/ /'
}

# Create an array to fetch the current interface list in a function and using for Network configuration part.#
function arraylistinterfaces(){
for i in $(ip a | awk 'BEGIN {FS=": "} {print $2}' | awk 'NF > 0');do
				arr+=($i);done
}
#print list interfaces function.
function interfacelistprint(){
for j in "${arr[@]}";do echo $j ; done | sed '/./=' | sed '/./N; s/\n/ /'
}

  ######################################################################################################################################

                                               #######################################
					      #     Creat the List of interfaces.     #
                                              #  Ubuntu and CentOS/Red Hat-part1      #
					       ######################################
arraylistinterfaces				
arraylistusers
#os=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | cut -d' ' -f1 | cut -d'"' -f2)
#clear
#if [[ "$os" = "ubuntu" || "$os" = "Ubuntu" ]];then
#echo $os
#elif [[ "$os" = "Centos" || "$os" = "centos" || "$os" = "Redhat" || "$os" = "redhat" ]]; then echo "Centos"
#fi
#sleep 5
#get list of interfaces and use in array#
#for i in $(ip a | awk 'BEGIN {FS=": "} {print $2}' | awk 'NF > 0')
#this related to array loop#
#do arr+=($i)
#end of array loop#
#done
#test output of array#
#echo "${arr[@]}"#
   #############################################################################################################################
                                              ##################################################
                                             #  The Sudoer and Network configuration selection. #
                                             #                                                  #
                                              ################################################## 
os=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | cut -d' ' -f1 | cut -d'"' -f2)
#The question about Network or sudoer configurations and selection could not be emtpy.# 
while true ;clear
		# If OS is ubuntu just shows the three option on screen.#
		if [[ "$os" = "ubuntu" || "$os" = "Ubuntu" ]];then
			echo -e "Configuration Selection:";sleep 0.5s;echo -e "1- Network configurations.\
				\n2- sudoer configurations.\n3- Exit"
		# If OS is centos also sudoer setting will be shown on the screen. 
		elif [[ "$os" = "CentOS" || "$os" = "centos" || "$os" = "Red" || "$os" = "red" ]];then echo "CentOS/Red Hat"
			echo -e "Configuration Selection:";sleep 0.5s;echo -e "1- Network configurations.\
				\n2- sudoer configurations.\n3- Disable SELINUX.\n4- Exit"
			fi
					sleep 0.5s

		do read -p "Please select a number: " cfgselection
		case $cfgselection in
		     # The number one is related to Network configuration and start it's scripts. 
                     1) 
   ###############################################################################################################################
  #                                                   Network Configuration part                                                  #
  #                                                      For Centos and Ubuntu                                                    #
   ###############################################################################################################################

                                               #######################################
				              #       Creat Interface list.-Part2     #
				              #	      The Interface Selection.        #
					      #    Ubuntu And CentOS/Red Hat          #
                                               #######################################
#Count the list of the interfaces and check in below condition and user could not enter higher number than.#
count=$( interfacelistprint | wc -l)
countinterface=$( interfacelistprint | wc -l)
#clear the page#
#clear
# list of interfaces use while here to prevent empty answer.#
while clear;echo "The first step: Interface selection:"
	#Puase the page one second.#
	sleep 0.5s
	# Use "for" here to convert horizontal array to vertical array.#
	#for j in "${arr[@]}"
	#for j in arraylistinterfaces
	# Use sed here to append number to each line.#
	#do echo $j ;done  | sed '/./=' | sed '/./N; s/\n/ /'
	#do echo $j ; done | sed '/./=' | sed '/./N; s/\n/ /'
	interfacelistprint
#echo "${arr[@]}"
        #Input number to select interface as $num vlue.#
	sleep 0.5;read -p "please select a number: " num
        #The following line find the input num value wether existed on the yaml file to use it later in sed command.#
	ens=$(grep "${arr[$((num - 1))]}:$" /etc/netplan/00-installer-config.yaml | wc -l)
	#Condition to check whether the $num is empty.#
	do if [[  -z $num  || $num -gt $countinterface || $num -eq 0 || $num =~ [^0-9] ]]
    #Print error if the $num will be empty#
    #then clear;echo -e "Error:\n\n\tYou have to select an option.\n\n\tThe list will be appread again.\n\n\tTo exit press CTRL+c."
    then clear;echo -e "Error:\n\n\tThe input could not be emtpy.\n\n\tThe list will be appread again.";pause
        #Print error if the $num is empty and the while for selecting interface closed here.#
	#sleep 2;clear;else break;fi;done
	#sleep 2; clear
	clear
#The following line find the input num value wether existed on the yaml file to use it later in sed command.#
#ens=$(grep "${arr[$((num - 1))]}:$" /etc/netplan/00-installer-config.yaml | wc -l)
#condition to check the selected interface has been configured or not.#
	### The following lines have been commented in new version(version 2).
	###elif [ $ens -gt 0 ];then clear #;sleep
        #echo -e " Erro:\n\t This interface has been configured.\n\t Please run the script again and select another interface.
        #The Script will be stopped."
        ###echo -e " Erro:\n\tThis interface has been configured.\n\n\tPlease select another interface.";pause
	else break;fi;done
	# End of the Condition and puase the screen.#
	#sleep 1;exit;fi
   #############################################################################################################################
                                               #######################################
                                              #  1-         OS mode Check             #
                                              #  2-     DHCP Method for Ubuntu Only   #
                                               #######################################
# The following conditions check the OS mode(Ubuntu,Centos/Red Hat)
os=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | cut -d' ' -f1 | cut -d'"' -f2)
clear
# Ubuntu OS selection
if [[ "$os" = "ubuntu" || "$os" = "Ubuntu" ]];then
# Take a backup of /etc/netplan/00-installer-config.yaml file.
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml-bak-scriptbackup-$(date +%F-%R)
# check that there is any other interface except selected interface.
second_interface_check=$(ip a | awk '{print$2}' | grep -E '^([a-z]|[A-Z])([^0-9]|[0-9]){1,6}:$' | grep -v -E "^lo|${arr[$((num - 1))]}" | awk -F: '{print$1}')
# Fetching "version" sequence line number on the /etc/netplan/00-installer-config.yaml file.
version_line_number=$(grep -n -E "version:" /etc/netplan/00-installer-config.yaml | awk -F: '{print$1}')
# Fetching selected interface and it's sequences on the  /etc/netplan/00-installer-config.yaml file.
selected_interface_line_number=$(grep -n -E "${arr[$((num - 1))]}" /etc/netplan/00-installer-config.yaml | awk -F: '{print$1}')
# if there is a single interface, then run other conditions.
if test -z $second_interface_check; then
	if [[ $version_line_number -gt $selected_interface_line_number ]];then
		 sed -i "$selected_interface_line_number,$((version_line_number -1 ))d" /etc/netplan/00-installer-config.yaml
	 elif [[ $selected_interface_line_number -gt $version_line_number ]];then
		 sed -i "$selected_interface_line_number,$d" /etc/netplan/00-installer-config.yaml
	fi	

# if there is another interface except selected.
elif test -n $second_interface_check; then
	# Fetching the second interface line number on the /etc/netplan/00-installer-config.yaml
	second_interface_libe_number=$(grep -n -E "$second_interface_check" /etc/netplan/00-installer-config.yaml | awk -F: '{print$1}')
	# if the version line number is greather than others. It means that the version: is located on the end of file.
	if [[ $version_line_number -gt  $selected_interface_line_number && $version_line_number -gt $second_interface_libe_number ]];then
        # check that the selected interface line number is greather than another interface. It means that the selected interface is lower than another interface.
		if [[ $selected_interface_line_number -gt $second_interface_libe_number ]]; then
			# delete the selected interface and it's sequences lines up to "version" line number of /etc/netplan/00-installer-config.yaml file.
			sed -i "$selected_interface_line_number,$((version_line_number -1 ))d" /etc/netplan/00-installer-config.yaml
	# check that the selected interface line number is less than another interface. It means that the selected interface is upper than another interface.
		elif [[ $selected_interface_line_number -lt $second_interface_libe_number ]];then
		    # delete the selected interface and it's sequences lines up to "another interdace" line number of /etc/netplan/00-installer-config.yaml file.
			sed -i "$selected_interface_line_number,$(($second_interface_libe_number -1 ))d" /etc/netplan/00-installer-config.yaml
		fi #[[$selected_interface_line_number -gt $second_interface_libe_number]#[$selected_interface_line_number-lt $second_interface_libe_number]]
	# if the version line number is less than others. It means that the version: is located above of the other.
	elif [[ $version_line_number -lt  $selected_interface_line_number && $version_line_number -lt $second_interface_libe_number ]];then
       # check that the selected interface line number is greather than another interface. It means that the selected interface is lower than another interface.
                if [[ $selected_interface_line_number -gt $second_interface_libe_number ]]; then
	              # delete the selected interface and it's sequences lines up to end of /etc/netplan/00-installer-config.yaml file.
                        sed -i "$selected_interface_line_number,$d" /etc/netplan/00-installer-config.yaml
	# check that the selected interface line number is less than another interface. It means that the selected interface is upper than another interface.
                elif [[ $selected_interface_line_number -lt $second_interface_libe_number ]];then
	   # delete the selected interface and it's sequences lines up to "another interdace" line number of /etc/netplan/00-installer-config.yaml file.
                        sed -i "$selected_interface_line_number,$(($second_interface_libe_number -1 ))d" /etc/netplan/00-installer-config.yaml
		fi ##[[$selected_interface_line_number -gt $second_interface_libe_number]] ## 4 lines above.
	fi #[[ $version_line_number -gt  $selected_interface_line_number && $version_line_number -gt $second_interface_libe_number ]]
	
	
fi # if test -z $second_interface_check; ## elif test -n $second_interface_check
#echo "The second interface is $second_interface_check";sleep 10
# Clear the screen.#
clear
# select IP method, use while here to force user select an option.#
while clear;echo "Second step: IP method"
	do sleep 1
        #Get an option as input to select IP method.#
	echo -e "Would you like configure DHCP or static mode:\n 1-DHCP\n 2-Static" # Input DHCP or Static configuration.
	read -p "please select a number: " mode
	# Use "case" here to select DHCP or Static method. The number 1 is DHCP and number 2 is Static mode.#
 	case $mode in
	# The DHCP mode option.#
	1)
		#test the case.#
		#echo "dhcp entekhab shode."
		#check the ethernet attribute wheter exist or not.#
		ether1=$(grep "ethernets:" /etc/netplan/00-installer-config.yaml | wc -l)
		#condition of ethernet check.#
                if [ $ether1 -gt 0 ]
                then
		        #If the ethernet exists append the interface after it.#
                        sed -i "/ethernets:$/a \    ${arr[$((num - 1))]}:" /etc/netplan/00-installer-config.yaml
                else
		        # If the ether does not exist. Following line append ethernet and then selected interface.
                        sed -i  "/network:$/a \  ethernets:" /etc/netplan/00-installer-config.yaml
                        sed -i "/ethernets:$/a \    ${arr[$((num - 1))]}:" /etc/netplan/00-installer-config.yaml
                #End of the condition.#
		fi
	    # The following line get the line number of selected interface attribute in the yaml file to use later in sed command.#
	    lnum1=$(grep -nw "${arr[$((num - 1))]}:$" /etc/netplan/00-installer-config.yaml | awk 'FS=":" {print$1}'|cut -f 1 -d :)
		# Append DHCP attribute to the "yaml file" force selected interface use DHCP method.#
	        sed -i "$lnum1 a \      dhcp4: yes" /etc/netplan/00-installer-config.yaml
		# execute netplan if user press CTR+C.
		netplan apply
		clear;echo -e "Info:\n\n\t${arr[$((num - 1))]} has been configured as DHCP mode.";pause
		# Break and close option the option 1 of.#
		break;;
   ############################################################################################################################

					      #################################################
					     # IP,Gateway,DNS configuration for Ubunut.        #
					     # The Following Configuration is just for Ubuntu. #
					      #################################################
  #############################################################################################################################
					      ########################################
					     #               Ubuntu IP                #
					     #   Input,check conditions,error,info    #
                                              ########################################
        # The static mode option.#
	2)
		# Clear the screen.
	        clear
		# Start the static mode configurations.#
		echo "IP Static Configuration mode- IP configuration."
		# Puse the page one second.#
		sleep 0.5s
		# The following line get the IP value as input.#
		while read -p "$(echo -e "Please enter your IP Address\nExample: 192.168.68.10/24\nType IP address here: ")" ip
		# The following condition check the input is not empty or wron.#
	        #do if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]{1,2}$ ]];then break
	        #do if
           #[[ $ip =~ (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\/((3[0-2]{1})|(2[0-9]{1})|(1[0-9]{1})|([0-9]{1})$) ]]
		do if
       [[ $ip =~ (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\/((3[0-2]{1})|(2[0-9]{1})|(1[0-9]{1})|([0-9]{1})$) ]]
	        then break
		#Error pritn if input is not match above condition.#
		else clear;echo\
		-e "Error:\n\n\tThe IP address should look like 192.168.68.10/24.\n\n\tThe IP Address could not be emtpy
				\n\n\tPlease type IP correctly.";pause
		clear ;fi;done #sleep 1 has been remove sleep 1;clear ;fi;done
                # Puse the screen one second.#
		#sleep 1
  #################################################################################################################################
					      ########################################
					     #             Ubuntu Gateway             #
					     #   Input,check conditions,error,info    #
                                              ########################################							
               # The following lines get the gateway value as input and checking it is not empty.#
		clear;sleep 1;while read -p "$(clear;echo\
		       	   -e "IP static configuration mode- Gateway confuration\nPlease enter the gateway ip address\
		              \nExample: 192.168.68.1\nType gateway IP address here: ")" gate
			#do if [[ $gate =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then break
	     #do if [[ $gate =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]];then break
	     do if [[ $gate =~ (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
	     then break
                         # Print error if the above condition is not met.#
			else clear;echo -e "Error:\n\n\tThe gateway should looks like 192.168.68.1\
			\n\n\tPlease type IP correctly.\
			\n\n\tThe gateway could not be emtpy." ;pause;fi;done
		# Checking there is ethernets on the yaml file. This line is related to static ip method.#
		ether2=$(grep "ethernets:" /etc/netplan/00-installer-config.yaml | wc -l)
		# Condition of ether.#
		if [ $ether2 -gt 0 ]
		then
   #################################################################################################################################
                                              ########################################
					     #         Ubuntu IP and Gateway          #
					     #         Configuration Scripts.         #
                                              ########################################
			# If ethernets exists on the yaml file the selected interface will be appended after that.#
			sed -i "/ethernets:$/a \    ${arr[$((num - 1))]}:" /etc/netplan/00-installer-config.yaml
		else
			# Else Ethernet and selected interface will be appended on yaml file.#
			sed -i  "/network:$/a \  ethernets:" /etc/netplan/00-installer-config.yaml
			sed -i "/ethernets:$/a \    ${arr[$((num - 1))]}:" /etc/netplan/00-installer-config.yaml
		#End of the ethernet condition.#
		fi
		# Find the line number of the selected interface on the yaml file.#
		lnum2=$(grep -nw "${arr[$((num - 1))]}:$" /etc/netplan/00-installer-config.yaml |
			awk 'FS=":" {print$1}'|cut -f 1 -d :)
		# Append addresses attribute for selected interface on the yaml fil#
		sed -i "$lnum2 a \      addresses:" /etc/netplan/00-installer-config.yaml
		# Append IP addresses of selected interface on the yaml fil#
		sed -i "$((lnum2 + 1)) a \      - $ip" /etc/netplan/00-installer-config.yaml
		# Append Gateway IP addresses of selected interface on the yaml fil#
		sed -i "$((lnum2 + 2)) a \      gateway4: $gate" /etc/netplan/00-installer-config.yaml
  ######################################################################################################################################
                                              ##################################################
			                     #      Name Servers Configurations.                #
			                     #             DNS1 and DNS2                        #
					     # The Following Configurations is just for UBUNTU. #
			                      ##################################################
  ######################################################################################################################################
                                              #########################################
                                             #              Ubuntu-DNS1                #
                                             #                                         #
                                              #########################################
		# Puse the screen one second.#
		#sleep 1
		# While is used here to check that user intend to configure nameservers.#
		while true;do sleep 0.5s
		  # Print a question about DNS1 configuration.
		  read -p "$(echo -e "Would you like configure the NameServer?\n 1-Yes\n 2-No\nPlease select a number: ")" dnsans
		  	# Create option to anwere the above question. It is related to the first DNS.#
			case $dnsans in
				# Option 1 of DNS 1 case.#
				1 )
					# Get input for $dns1 value.#
					clear;sleep 0.5s;read -p\
					"$(echo\
				       	-e "Please enter the primary DNS\nExample: 8.8.8.8\nType DNS1 IP address here: ")" dns1
					# the condition check that the input is like IP(DNS1).#
					#if [[ $dns1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	                                if
		    #[[ $dns1 =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]]
		    [[ $dns1 =~  (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
					then
					# Append nameservers attribute after gateway attribute on the yaml file.#
					sed -i "$((lnum2 + 3)) a \      nameservers:" /etc/netplan/00-installer-config.yaml
					# Append addresses attribute for nameservers.#
					sed -i "$((lnum2 + 4)) a \        addresses:" /etc/netplan/00-installer-config.yaml
					# Append dns1 on the yaml file.#
					sed -i "$((lnum2 + 5)) a \        - $dns1" /etc/netplan/00-installer-config.yaml
  #######################################################################################################################################
					      #########################################
					     #              Ubuntu-DNS2                #
				             #                                         #
					      #########################################
					# while is used here to ask user to configure dns2.#
	            	                while true;do sleep 0.5s
					# Print a question about DNS2 configuration.#
					read -p "$(echo -e "Would you like configure the another DNS server?
					\n 1-Yes\n 2-No\nPlease select a number: ")" dns2ans
					# Create option to answer the above question.#
					case $dns2ans in
					     # create option 1 for configure DNS2 and getting input for $dns2.#
					     1) clear;sleep 0.5s;read -p "$( echo\
						-e "Please enter secondary DNS.\
						\nExample: 8.8.8.8\nType DNS2 IP address here: " )" dns2
					        #Checking the input be same as a IP address(2).#
					        #if [[ $dns2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
				       	        if
              #[[ $dns1 =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]]
              [[ $dns2 =~  (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
	      					then
					     	# Append DNS2 after DNS1 value on the yaml file.#
					        sed -i "$((lnum2 + 6)) a \        - $dns2" /etc/netplan/00-installer-config.yaml
						# execute netplan if user press CTR+C.
						netplan apply
						clear;sleep 0.5s ;echo -e "Info:\n\n\tThe network configuration has been finished.\
								\n\n\tIP address: $ip\n\n\tGateway: $gate\
								\n\n\tDNS1 address: $dns1\
								\n\n\tDNS2 address: $dns2";pause;
						# break this option to prevent iteration the DNS2 while.#
						break
						# Else if user type excep ip address print an error(DNS2).
						else clear;echo\
				                  -e "Error:\n\n\tIP Should looks like 8.8.8.8\
						  \n\n\tPlease type IP correctly.";pause
					        # close if of DNS2 for checking wrong ip input(DNS2).#
						fi
						#close option 1 of the dns2 configuration(DNS2).#
						;;
						# Break the while if user's answer was no(DNS2).#
					     2) 	# execute netplan if user press CTR+C.
					     		netplan apply
					     		clear;sleep 0.5s;echo -e "Info:\n\n\tThe network configuration has been finished.\
								\n\n\tIP address: $ip\n\n\tGateway: $gate\
								\n\n\tDNS address: $dns1" ;pause;break;;
		                              #Clear the screen and printing the error if the asnwer was empty and-
					      #-Close the option whit ";;" at the end(DNS2).#
			                     *) clear;echo -e "Error:\n\n\tThe answer could not be empty.\
						           \n\n\tPlease answer the question." ;pause;;
				        # close the Case,While and break the while loop.This is related to case of DNS2.#
				        esac;done #;break
					# Break the option 1 of DNS1 if the above condition met.(DNS1-option1)#
					break
					# Clear and Print Error if the $dns1 is not like IP(DNS1-option1).#
					else clear;echo\
					-e "Error:\n\n\tIP Should looks like 8.8.8.8\n\n\tPlease type IP correctly.";pause
					# Puase the screen Two seconds and closing if for dns1 condition(DNS1-option1).#
					sleep 2
					# Closing the option 1 of dns1 case(DNS1-option1).#
					fi;;
				# It is option 2 of DNS1 case and will break the while.(DNS1-option2)#
				2 ) 		# execute netplan if user press CTR+C.
						netplan apply
						clear;echo -e "Info:\n\n\tThe network configuration has been finished.\
							\n\n\tIP address: $ip\n\n\tGateway: $gate";pause;break;;
				# Clear the screen, print Error if the answer was empty(DNS1-option3).#
				* ) clear; echo -e "Error:\n\n\tThe answer could not be empty.\n\n\tPlease answer the question.";pause
				# Puse the screen two seconds,close case and break while of DNS1(DNS1-option3).#
				    sleep 0.5s ;; esac;done
	# Close the option 2 of DHCP casei(DHCP-option2).
	break;;
	# clear,printing the error if the answer was empty,pausing screen two seconds,closing the * option of DHCP.(DHCP-option3)#
	*) clear;echo -e "Error:\n\n\tThe Method could not be empty.\n\n\tPlease select a number.";pause;;
	# Close case and breaking while of the DHCP case(DHCP-case-while).#
 	esac
done
#sleep 1 ;echo -e "THE END\n\tPlease check the IP of interfaces.\n\tGOOD LUCK. ";sleep 2
#clear;echo "confirmaition information"
#echo -e "your ip address: $ip\n\ngateway address: $gate"
 # for dhcp while
#sed -i "/search/i \      - $dns1:" sed.yaml
#sed -i "/search/i \      - $dns2:" sed.yaml
#cat sed.yaml
# execute netplan if user press Enter.
netplan apply

  ######################################################################################################################################
                                             #########################################
					    #           IP Method Selection.          #
					    #The DHCP Method Configuration for Centos.#
					     #########################################
                                                                                  
elif [[ "$os" = "CentOS" || "$os" = "centos" || "$os" = "Red" || "$os" = "red" ]];then #echo "CentOS/Red Hat"
cp /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]} /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}-scriptbackup-$(date +%F-%R)
while clear;echo "Second step: IP method"
	do sleep 1
        #Get an option as input to select IP method.#
	echo -e "Would you like configure DHCP or static mode:\n 1-DHCP\n 2-Static" # Input DHCP or Static configuration.
	read -p "please select a number: " mode
	# Use "case" here to select DHCP or Static method. The number 1 is DHCP and number 2 is Static mode.#
 	case $mode in
	# The DHCP mode option.#
	1)
		#test the case.#
		#echo "dhcp entekhab shode."
		#check the dhcp attribute wheter exist or not.#
		centosifcfgdhcp=$(grep "dhcp" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]} | wc -l)
		#condition of ethernet check.#
                if [ $centosifcfgdhcp -gt 0 ]
                then
		        #If dhcp has been sat on the ethernet print the following message and end script.(Method-option1)#
                        clear ;sleep 1;echo -e "Erro:\n\n\tThe selected inferface has been configured as DHCP method.\
			\n\n\tPlease try again if you intend to reconfigure ethernet as a different method.";pause; break
		else
			# Replace dchp with none or static on BOOTPROTO attribute the ifcfg.(mthod-option1)#
			sed -i -E 's/BOOTPROTO=(none|static)/BOOTPROTO=dhcp/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			# Replpace yes with no on ONBOOT attribute on the ifcfg.(mthod-option1)#
			sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			# Append "#" at the start of IPADDR attribute to disable it. For DHCP Method is necessary.(mthod-option1)#
			#sed -i "/^IPADDR/ s/./#&/" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			sed -i "/^IPADDR/d" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			# Append "#" at the start of NETMASK or PREFIX attribute to disable it.For DHCP Method is necessary.(mthod-option1)#
			#sed -i -r '/^(NETMASK|PREFIX)/ s/./#&/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			sed -i -r '/^(NETMASK|PREFIX)/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			# Append "#" at the start of GATEWAY attribute to disable it. For DHCP Method is necessary.(mthod-option1)# -
			# - close if and break the while.(mthod-option1)#
			#sed -i '/^GATEWAY/ s/./#&/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]};
			sed -i '/^GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			#sed -i '/^DNS1/ s/./#&/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			sed -i '/^DNS1/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			#sed -i '/^DNS2/ s/./#&/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			sed -i '/^DNS2/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
			systemctl restart network
			clear;echo -e "Info:\n\n\tThe DHCP method has been configured on ${arr[$((num - 1))]} .\
				\n\n\tPlease Check the interface configurations.";pause
			fi; break
    	# Close option 1(DHCP) of IP method.(method-option1)#
	;;
	# The static mode option.#
	2)
		# Clear the screen.
	        clear
		# Start the static mode configurations.#
		echo "IP Static Configuration mode- IP configuration."
  ######################################################################################################################################
                                             #########################################
					    #    IP STatic Configurations Method.     #
					    #    The IP Configuration for Centos.     #
					     #########################################
		# Puse the page one second.#
		sleep 1
		# The following line get the IP value as input.#
		while read -p "$(echo -e "Please enter your IP Address(Without Prefix)\nExample: 192.168.68.10\nType IP address here: ")" ip
		# The following condition check the input is not empty or wron.(Method-option2-static-IP)#
	        #do if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]{1,2}$ ]];then break
		# ((3[0-2]{1})|(2[0-9]{1})|(1[0-9]{1})|([0-9]{1})$)
		# The following condition check the input is not empty or wron.(Method-option2-static-IP)#
	        do if
                  [[ $ip =~ (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
	        then break
		#Error pritn if input is not match above condition.(Method-option2-static-IP)#
		else clear;echo\
		-e "Error:\n\n\tThe IP address should looks like 192.168.68.10(Without Prefix).\n\n\tThe IP Address could not be emtpy.\
			\n\n\tPlease type IP address correctly."
		pause;clear ;fi;done
  ######################################################################################################################################
                                             #########################################
					    #    IP STatic Configurations Method.     #
					    #  The Prefix Configuration for Centos.   #
					     #########################################
                # Puse the screen one second.(Method-option2-static-PREFIX)#
		sleep 1
     		# The following lines get the prefix value as input.(Method-option2-static-PREFIX)#
		while read -p "$(clear;echo -e "Prefix(just type number, without /) \nExample: 24\nType prefix number here: ")" pref
		# The following condition check the input is not empty or wron.(Method-option2-static-PREFIX)#
	    	do if [[ $pref =~ ^((3[0-2]{1})|(2[0-9]{1})|(1[0-9]{1})|([0-9]{1}))$ ]]; then break;
		else clear;echo -e "Error:\n\n\tThe Prefix number should looks like 24 (without /).\
	                   \n\n\tThe Prefix number could not be empty. \
			    \n\n\tPlease type prefix number correctly."
	# Puse the screen one second, clear the screen and close if that related to the Prefix condition.(Method-option2-static-PREFIX)#
		pause;clear;fi;done
  ######################################################################################################################################
                                             #########################################
					    #    IP STatic Configurations Method.     #
					    #  The Gateway Configuration for Centos.  #
					     #########################################
	        #The following lines get the gateway value as input and checking it is not empty or wrong.(Method-option2-static-Gateway)#
                 #Input $gate value as gateway IP address(Method-option2-static-Gateway).
		while read -p "$(clear;echo\
		       	   -e "IP static configuration mode- Gateway confuration\nPlease enter the gateway ip address\
		              \nExample: 192.168.68.1\nType gateway IP address here: ")" gate
			#do if [[ $gate =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];then break
	   #do if [[ $gate =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]];then break
	     # The condition checks the input must be same as IP address(Method-option2-static-Gateway).
	     do if [[ $gate =~ (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
	     then break
                         # Print error if the above condition is not met.(Method-option2-static-Gateway)#
			else clear;echo -e "Error:\n\n\tThe gateway should looks like 192.168.68.1\
			\n\n\tThe gateway could not be emtpy.\n\n\tPlease type gateway address correctly." ;pause ;fi;done
  ######################################################################################################################################
                                             #########################################
					    #    IP STatic Configurations Method.     #
					    # ADD IP/PREFIX and Gateway in ifcfg file #
					     #########################################
	# Check there is dhcp attribute in the ifcfg file.(Method-option2-static-configurations)#
		centosifcfgdhcp=$(grep "dhcp" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]} | wc -l)
	# Check there is IPADDR or GATEWAY attribute in the ifcfg file.(Method-option2-static-configurations)#
	centosifcfstatic=$(grep -E "^(#IPADDR|IPADDR)|^(#GATEWAY|GATEWAY)" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]} | wc -l)
	# Condition check if there is "IPADDR" or "GATEWAY" attribute in the ifcfg file.(Method-option2-static-configurations)#
		if [ $centosifcfstatic -gt 0 ];then clear
 	# Depends on above condition change BOOTPROTO value in the ifcfg file.(Method-option2-static-configurations)#
		   sed -i 's/dhcp/none/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Depends on above condition change ONBOOT value in the ifcfg file.(Method-option2-static-configurations)#
		   sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Set $IP address on the ifcfg file and remove comment of IPADDR if there is.(Method-option2-static-configurations)#
		   sed -i -r "s/(#IPADDR|IPADDR)=.*/IPADDR=$ip/" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
      	# Set $pref number on the ifcfg file and remove comment of PREFIX or SUBNET if there is.(Method-option2-static-configurations)#
		   sed -i -r "s/((#PREFIX|PREFIX)=.*|(#SUBNET|SUBNET)=.*)/PREFIX=$pref/" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Set $gate address on the ifcfg file and remove comment of GATEWAY if there is.(Method-option2-static-configurations)#
		   sed -i -r "s/(#GATEWAY|GATEWAY)=.*/GATEWAY=$gate/" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
        # Print the information of IP/Prefix and Gateway that have been setting.(Method-option2-static-configurations)#
		   echo "The IP= $ip/$pref and Gateway= $gate have been setting." ;sleep 0.5s
	# Condition check if there is "dhcp" attribute in the ifcfg file and replace with "none".(Method-option2-static-configurations)#
			elif [ $centosifcfgdhcp -gt 0 ];then
	# Depends on above condition change BOOTPROTO value in the ifcfg file.(Method-option2-static-configurations)#
				sed -i 's/dhcp/none/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Depends on above condition change ONBOOT value in the ifcfg file.(Method-option2-static-configurations)#
				sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Append "IPADDR" attribute and $IP address on the ifcfg file.(Method-option2-static-configurations)#
				sed -i "\$a IPADDR=$ip" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Append "PREFIX" attribute and $pref number on the ifcfg file.(Method-option2-static-configurations)#
				sed -i "\$a PREFIX=$pref" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
	# Append "GATEWAY" attribute and $gate address on the ifcfg file.(Method-option2-static-configurations)#
				sed -i "\$a GATEWAY=$gate" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]};fi

			#else
			#sed -i 's/dhcp/none/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}#
			#sed -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}#
			#sed -i "\$a IPADDR=$ip" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}#
			#sed -i "\$a PREFIX=$pref" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}#
			#sed -i "\$a GATEWAY=$gate" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]};fi;break;;#
    ###################################################################################################################################
                                              ########################################
                                             #   IP STatic Configurations Method.     #
                                             # DNS1 and DNS2 configuration for CentOS.#
                                              ########################################
    ###################################################################################################################################
					      ########################################
					     #         CentOS/Red Hat  DNS1           #
					     #                                        #
					      ########################################
     		lnum2=$(grep -n "GATEWAY" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]} | cut -d: -f1 )
       		# Puse the screen one second.(Method-option2-static-DNS1)#
		sleep 0.5s
		# While is used here to check that user intend to configure nameservers.(Method-option2-static-DNS1)#
		while true;do sleep 0.5s
     		# Print a question about DNS1 configuration.(Method-option2-static-DNS1)#
     		read -p "$(echo -e "Would you like to configure the NameServer?\n 1-Yes\
			   \n 2-No\nPlease select a number: ")" dnsans
     		# Create option to anwere the above question. It is related to the first DNS.(Method-option2-static-DNS1)#
     		case $dnsans in
     			# Option 1 of DNS 1 case.(Method-option2-static-DNS1)#
			1 )
				# Get input for $dns1 value.(Method-option2-static-DNS1)#
				clear;sleep 0.5s;read -p\
				"$(echo\
				-e "Please enter the primary DNS\nExample: 8.8.8.8\nType DNS1 IP address here: ")" dns1
				# the condition check that the input is like IP(DNS1).(Method-option2-static-DNS1)#
				#if [[ $dns1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
				if
		             #[[ $dns1 =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]]
			     [[ $dns1 =~  (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
				then
				# remove previous dns1 config.(Method-option2-static-DNS1)#
				sed -i '/^DNS1/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
				# Append DNS1 attribute after gateway attribute on the ifcfg file.(Method-option2-static-DNS1)#
				sed -i "$((lnum2)) a \DNS1:$dns1" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
   ###################################################################################################################################
					      ########################################
					     #         CentOS/Red Hat  DNS2           #
					     #                                        #
					      ########################################    
					# while is used here to ask user to configure dns2.(Method-option2-static-DNS2)#
	            	                while true;do sleep 0.5
					# Print a question about DNS2 configuration.(Method-option2-static-DNS2)#
					read -p "$(echo -e "Would you like configure the another DNS server?
					\n 1-Yes\n 2-No\nPlease select a number: ")" dns2ans
					# Create option to answer the above question.(Method-option2-static-DNS2)#
					case $dns2ans in
					   # create option 1 for configure DNS2 and getting input for $dns2.(Method-option2-static-DNS2)#
					     1) clear;sleep 0.5s;read -p "$( echo\
						-e "Please enter secondary DNS.\
						\nExample: 8.8.8.8\nType DNS2 IP address here: " )" dns2
					        #Checking the input be same as a IP address.(Method-option2-static-DNS2)#
					        #if [[ $dns2 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
				       	        if 
              #[[ $dns1 =~ (^(((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))\.){3})((2[0-5]{1,3})|(1[0-9]{1,3})|([0-9]{1,2}))$ ]]
              [[ $dns2 =~  (^(((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))\.){3})((2[0-5]{1,2})|(1[0-9]{1,2})|([0-9]{1,2}))$ ]]
	      					then
						# Clear the previous dns2 comfig.(Method-option2-static-DNS2)#
						sed -i '/^DNS2/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
					     	# Append DNS2 after DNS1 value on the yaml file.(Method-option2-static-DNS2)#
					    sed -i "$((lnum2 + 1))aDNS2=$dns2" /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
					    # network service will be restarted if user press CTR+C.
					    systemctl restart network
						# break this option to prevent iteration the DNS2 while.(Method-option2-static-DNS2)#
						clear;echo -e "Info:\n\n\tThe network configuration has been finished.\
								\n\n\tIP address: $ip/$pref \n\n\tGateway: $gate\
								\n\n\tDNS1 address: $dns1\
								\n\n\tDNS2 address: $dns2";pause
						break
						# Else if user type excep ip address print an error.(Method-option2-static-DNS2)#
						else clear;echo\
				                  -e "Error:\n\n\tIP Should looks like 8.8.8.8\
						  \n\n\tThe IP address could not be empty.\
						   \n\n\tPlease Type IP address correctly.";pause
					        # close if of DNS2 for checking wrong ip input.(Method-option2-static-DNS2)#
						fi
						#close option 1 of the dns2 configuration.(Method-option2-static-DNS2)#
						;;
						# Break the while if user's answer was no.(Method-option2-static-DNS2)#
					     2) 	# remove DNS2 attribute of the selected interface file.
					     		sed -i '/^DNS2/d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
							# network service will be restarted if user press CTR+C.
					     		systemctl restart network
					     		clear;echo -e "Info:\n\n\tThe network configuration has been finished.\
								\n\n\tIP address: $ip/$pref \n\n\tGateway: $gate\
								\n\n\tDNS1 address: $dns1";pause;break;;
		                              #Clear the screen and printing the error if the asnwer was empty and- 
					      #-Close the option whit ";;" at the end.(Method-option2-static-DNS2)#
			                     *) clear;echo -e "Error:\n\n\tThe IP address could not be empty.\
						           \n\n\tPlease answer the question." ;pause ;;
			     # close the Case,While and break the while loop.This is related to case of DNS2.(Method-option2-static-DNS2)#
				        esac;done #;break
					# Break the option 1 of DNS1 if the above condition met.(Method-option2-static-DNS1-Option1)#
					break
					# Clear and Print Error if the $dns1 is not like IP.(Method-option2-static-DNS1-Option1)#
					else clear;echo\
					-e "Error:\n\n\tIP Should looks like 8.8.8.8\
						  \n\n\tThe IP address could not be empty.\
						  \n\n\tPlease type IP address correctly.";pause
			# Puase the screen Two seconds and closing if for dns1 condition.(Method-option2-static-DNS1-Option1)#
					sleep 0.5s
					# Closing the option 1 of dns1 case.(Method-option2-static-DNS1-Option1)#
					fi;;
				# It is option 2 of DNS1 case and will break the while.(Method-option2-static-DNS1-Option2)#
				2 ) 	# DNS1 and DNS2 attributes will be removed because of negative answer for dns question.
					sed -i '/^DNS./d' /etc/sysconfig/network-scripts/ifcfg-${arr[$((num - 1))]}
					# network service will be restarted if user press CTR+C.	
					systemctl restart network
					clear ; echo -e "Info:\n\n\tThe network configuration has been finished.\
						\n\n\tIP address: $ip/$pref\n\n\tGateway: $gate";pause; break ;;
				# Clear the screen, print Error if the answer was empty.(Method-option2-static-DNS1-Option3)#
				* ) clear; echo -e "Error:\n\n\tThe answer could not be empty.\n\n\tPlease answer the question.";pause
		        # Puse the screen two seconds,close case and break while of DNS1.(Method-option2-static-DNS1-case and while)#	
				    sleep 0.5s ;; esac;done
		# Close the option 2 of IP Method case(Method-option2-static).
		break;;
	 #clear,printing the error if the answer was empty,pausing screen two seconds,closing the * option of DHCP.(method-option3)#
	*) clear;echo -e "Error:\n\n\tThe Method could not be empty.\n\n\tPlease select a number.";sleep 2;;
	# Close case and breaking while of the DHCP case(DHCP-case-while).#
	esac

done
#systemctl restart NetworkManager
# network service will be restarted if user press Enter.
systemctl restart network
fi;;
                                              ##############################################
                                             #            IP Configuration Part.            #
                                             # End of the Centos IP configurations scripts. #
                                              ##############################################
 #####################################################################################################################################
                                              ########################################                                        
                                             #        Sudoer Configuration Part       #
                                             #         CMD Alias Configuration        #
                                              ########################################
	# Option 3 of the configuration selection.(Configuration-Option2-Sudoer Configurations start)#      
	2)
		# The following conditions check the OS mode(Ubuntu,Centos/Red Hat)
		#sudo useradd -s /bin/bash -d /home/$user/ -m -U $user
		#grep -E "/home/." /etc/passwd | awk -F":" '{print $1}' | grep -v -E "syslog|cups."
		#cp /etc/sudoers /etc/sudoers-scriptbackup-$(date +%F-%R)
		cmdnum=$(sudo grep -E -n 'Cmnd.*alias | Command.*Aliases' /etc/sudoers | awk -F":" '{print$1}')
		chksu=$(grep -i "cmnd_alias su" /etc/sudoers | wc -l)
		rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
		osmodesudo=$(awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | cut -d' ' -f1 | cut -d'"' -f2)
		# Create an array to keep the current username list.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					#for i in $(grep -E "/home/." /etc/passwd | awk -F":" '{print $1}' | grep -v -E "syslog|cups.");do
					# passwdarr+=($i);done
		while true;clear ;echo "sudoer Configurations Part:"; sleep 1
				 echo -e "Username selection:\n 1- Select from current usernames.\
					\n 2- Create new one.";sleep 0.5s
		do read -p "Please select a number: " usrselect
     #####################################################################################################################################
					      #########################################
					     #        Sudoer Configuration Part        #
					     #    Current username configurations.     #
					      #########################################
	       #The case of Option 2 that related to sudoer configuration.(Configuration-Option2-Sudoer Configurations-option2-case)
			case $usrselect in
                        # The Option 1 of user selection case(select from current usernames) that-# 
				#-related to option 2(sudoer configuration part) of configuration selection.#
				#(Configuration-Option2-Sudoer Configurations-user selection-option1)#
				1)
		# Create an array to keep the current username list.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					# for i in $(grep -E "/home/." /etc/passwd | awk -F":" '{print $1}' | grep -v -E "syslog|cups.");do
					# passwdarr+=($i);done
			# While is used here to avoid empty answer.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					while clear; echo "list of current users:";sleep 0.5s
		#Count the list of the current usernames and the next condition check that user answer not higher number than the list.#
			countuser=$( userlistprint | wc -l)
			# Create a list of the current usernames.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
				userlistprint
					#for j in "${passwdarr[@]}";do
					# sed is used here to append number to each line.#
       					#echo $j ;done  | sed '/./=' | sed '/./N; s/\n/ /';sleep 0.5s
			
					read -p "Please select a number: " usrnum
				# The following condition is used here to check that user answer in above list is empty or not.-#
				# - The "do" is related to the four above lines while.
				# (Configuration-Option2-Sudoer Configurations-user selection-option1)#
						do if [[ -z $usrnum || "$usrnum" -gt "$countuser" || "$usrnum" = "0" ]];then clear; 
							echo -e "Error:\n\n\tThe answer could not be empty.\
							      \n\n\tPlease select a correct number from list.";pause;else break;fi;done
     # Check the selected username is membership of sudo|wheel group.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					chksudogrp=$(id ${passwdarr[$((usrnum - 1))]} | grep -E "wheel|sudo" | wc -l)
					#chksudofile=$(grep -E "^${passwdarr[@]}.*ALL\s*$" /etc/sudoers | wc -l)# this is my mistake.
					chksudofile=$(grep -E "(^${passwdarr[$((usrnum - 1))]}.*ALL\s*#)|(^${passwdarr[$((usrnum - 1))]}.*ALL\s*[^#]$)" /etc/sudoers | wc -l)
					#chksudofilesu=$(grep -E "^${passwdarr[@]}.*ALL.*\!SU" /etc/sudoers | wc -l)# this is my mistake.
					chksudofilesu=$(grep -E "^${passwdarr[$((usrnum - 1))]}.*ALL.*SU\s*" /etc/sudoers | wc -l)
 #If selected user was membered of (sudo|wheel) will be removed from.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					 #if [[ $chksudogrp -gt 0 || $chksudofile -gt 0 ]];then
                                           while true 
						clear;
						#echo -e "The selected user is membered of the sudoer group\
						#\n\nWould you like to remove(limit) it?\
						#\n 1- Yes(limited Sudoer)\n 2- No(Unlimited Sudoer)";sleep 1
						echo -e "Which sudoer group should be the user membered of?\
							\n 1- Yes(limited sudoer)\n 2- No(Unlimited Sudoer)";sleep 1
						do
						read -p "Please select a number: " sudolimit
						case $sudolimit in
 					   # The option 1 of Limit sudoer condition.-#
					   #(Configuration-Option2-Sudoer Configurations-user selection-option1-limit sudoer-option1)#
							1)
  					  # this condition will remove user depends on the OS mode.-#
					  #(Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
					   			if [[ $osmodesudo = "Ubuntu" ]];then
					  # This command will remove user from sudo group in ubuntu.-#
					  # (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
			      					gpasswd -d ${passwdarr[$((usrnum - 1))]} "sudo"
					 # This command will remove user from sudoer file if there is.-#
					 # (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
								sed -i -r "/^${passwdarr[$((usrnum - 1))]}.*ALL/d" /etc/sudoers
					 # This condition will add SU alias in sudoers file if there is not.-#
					 # (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
								if [ $chksu -eq 0 ];then
									sed -i "$cmdnum a Cmnd_Alias SU = /bin/su root, /bin/su -, /bin/su, /usr/bin/su - root, /usr/bin/passwd, \!/usr/bin/passwd \[\%user\]\*, /usr/bin/passwd root, /bin/\* /etc/sudoers, /usr/bin/\* /etc/sudoers, /bin/\* sudoers, /usr/bin/\* sudoers, /usr/bin/sudo /usr/bin/su, /usr/bin/sudo /usr/bin/su \–, /usr/sbin/visudo, /sbin/visudo, /usr/bin/\* /etc/pam.d/\*, /usr/bin/\* sudo-i, /usr/bin/\* allowsudo-iusers, /usr/bin/yum update sudo, /usr/bin/yum remove sudo, /usr/bin/yum erase sudo, /usr/bin/rpm -e sudo, /usr/bin/\* /etc/shadow, /usr/bin/\* shadow, /usr/bin/\* /etc/sudoers.d/\*, /usr/bin/\* /etc/sudoers\*/\*, /usr/bin/sudo /bin/bash, /bin/bash, /usr/bin/\* sudoer\*, /usr/bin/\* /etc/sudo\*, /usr/bin/\* sudo.\*, /bin/csh, /bin/ksh, /bin/zsh, /usr/bin/\* /usr/bin/sudoedit, /usr/bin/sudoed\*, /usr/bin/\* sudoers.\*.\*, /usr/bin/\* /etc/sudoers.\*, /usr/bin/\* /etc/sudo.conf, /usr/bin/\* /etc/pam.d/sudo, /bin/sh, /bin/sudo \*			######This line added by *Platform Team* script#####" /etc/sudoers ;fi
					# This command will append selected user as a limited user in sudoers file if there is not.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
									if [ $chksudofilesu -eq 0 ]; then
										rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
										sed -i -E "$rootsudonum a ${passwdarr[$((usrnum - 1))]}  ALL\=(ALL)  NOPASSWD\: ALL ,\!SU	 ######This line added by *Platform Team* script#####" /etc/sudoers
				        # This command will print info that the selected user has been limited sudoer user.#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
					                                        clear;echo -e "Info:\n\n\t${passwdarr[$((usrnum - 1))]} has been configured as a limited sudoer user sinc now.";sleep 2;fi;break 2 
				        # if the above condition(Ubuntu OS) is no met, The following scripts will be ran.
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
					  			#else
					elif [[ "$osmodesudo" = "CentOS" || "$osmodesudo" = "centos" || "$osmodesudo" = "Red" || "$osmodesudo" = "red" ]]; then
					# This command will remove user from wheel group in CentOS/Red Hat.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)# 	
									gpasswd -d ${passwdarr[$((usrnum - 1))]} wheel
					# This command will remove user from sudo group in ubuntu.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
									sed -i -r "/^${passwdarr[$((usrnum - 1))]}.*ALL/d" /etc/sudoers
					# This condition will add SU alias in sudoers file if there is not.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
									if [ $chksu -eq 0 ];then
										sed -i "$cmdnum a Cmnd_Alias SU = /bin/su root, /bin/su -, /bin/su, /usr/bin/su - root, /usr/bin/passwd, \!/usr/bin/passwd \[\%user\]\*, /usr/bin/passwd root, /bin/\* /etc/sudoers, /usr/bin/\* /etc/sudoers, /bin/\* sudoers, /usr/bin/\* sudoers, /usr/bin/sudo /usr/bin/su, /usr/bin/sudo /usr/bin/su \–, /usr/sbin/visudo, /sbin/visudo, /usr/bin/\* /etc/pam.d/\*, /usr/bin/\* sudo-i, /usr/bin/\* allowsudo-iusers, /usr/bin/yum update sudo, /usr/bin/yum remove sudo, /usr/bin/yum erase sudo, /usr/bin/rpm -e sudo, /usr/bin/\* /etc/shadow, /usr/bin/\* shadow, /usr/bin/\* /etc/sudoers.d/\*, /usr/bin/\* /etc/sudoers\*/\*, /usr/bin/sudo /bin/bash, /bin/bash, /usr/bin/\* sudoer\*, /usr/bin/\* /etc/sudo\*, /usr/bin/\* sudo.\*, /bin/csh, /bin/ksh, /bin/zsh, /usr/bin/\* /usr/bin/sudoedit, /usr/bin/sudoed\*, /usr/bin/\* sudoers.\*.\*, /usr/bin/\* /etc/sudoers.\*, /usr/bin/\* /etc/sudo.conf, /usr/bin/\* /etc/pam.d/sudo, /bin/sh, /bin/sudo \*			######This line added by *Platform Team* script#####" /etc/sudoers;fi
					# This command will append selected user as a limited user in sudoers file if there is not.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
									if [ $chksudofilesu -eq 0 ]; then
										rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
										sed -i -E "$rootsudonum a ${passwdarr[$((usrnum - 1))]}  ALL\=(ALL)  NOPASSWD\: ALL ,\!SU	 ######This line added by *Platform Team* script#####" /etc/sudoers
				        # This command will print info that the selected user has been limited sudoer user.#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
					                                        clear;echo -e "Info:\n\n\t${passwdarr[$((usrnum - 1))]} has been configured as a limited sudoer user sinc now.";pause;fi;break 2 
					# Close above if (Ubuntu or Centos OS check)and break the while.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-limited sudoer-option1)#
								fi;break;;	  
					# print a Message if unlimited option is selected.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-unlimited sudoer-option2)#
							2)
					# check that if there the !SU record of selected user is on the sudoers file, then removes it.  
							if [[ $chksudofilesu -gt 0 ]];then 
								sed -i -r "/^${passwdarr[$((usrnum - 1))]}.*ALL.*SU\s*/d" /etc/sudoers
							fi
		sed -i -E "$rootsudonum a ${passwdarr[$((usrnum - 1))]}  ALL\=(ALL)  NOPASSWD\: ALL         ######This line added by *Platform Team* script#####" /etc/sudoers
							clear; echo -e "Info:\
							\n\n\t${passwdarr[$((usrnum - 1))]} is unlimited Sudoer";pause;break 2;;
					# Print an error if empty keyword is pressed.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1-unlimited sudoer-option*)#
							*)clear; echo -e "Error:\n\n\tThe Answer could not be empty\
								\n\n\tPlease select a number" ;pause;;esac;done
					# The followind condition check if there the SU is not on the sudoer file then append it.-#
					# - The following condition is related to the current user selection that is not a sudoers user.-#
					# - If there SU alias is not, the following condition is met.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1)#
					if [ $chksu -eq 0 ];then
					#cmdnum=$(grep -E -n 'Cmnd.*alias | Command.*Aliases' /etc/sudoers | awk -F":" '{print$1}')
					#clear; echo -e "$cmdnum";sleep 5
							#cp /etc/sudoers /etc/sudoers.bak-script-$(date +%F-%R)
							sed -i "$cmdnum a Cmnd_Alias SU = /bin/su root, /bin/su -, /bin/su, /usr/bin/su - root, /usr/bin/passwd, \!/usr/bin/passwd \[\%user\]\*, /usr/bin/passwd root, /bin/\* /etc/sudoers, /usr/bin/\* /etc/sudoers, /bin/\* sudoers, /usr/bin/\* sudoers, /usr/bin/sudo /usr/bin/su, /usr/bin/sudo /usr/bin/su \–, /usr/sbin/visudo, /sbin/visudo, /usr/bin/\* /etc/pam.d/\*, /usr/bin/\* sudo-i, /usr/bin/\* allowsudo-iusers, /usr/bin/yum update sudo, /usr/bin/yum remove sudo, /usr/bin/yum erase sudo, /usr/bin/rpm -e sudo, /usr/bin/\* /etc/shadow, /usr/bin/\* shadow, /usr/bin/\* /etc/sudoers.d/\*, /usr/bin/\* /etc/sudoers\*/\*, /usr/bin/sudo /bin/bash, /bin/bash, /usr/bin/\* sudoer\*, /usr/bin/\* /etc/sudo\*, /usr/bin/\* sudo.\*, /bin/csh, /bin/ksh, /bin/zsh, /usr/bin/\* /usr/bin/sudoedit, /usr/bin/sudoed\*, /usr/bin/\* sudoers.\*.\*, /usr/bin/\* /etc/sudoers.\*, /usr/bin/\* /etc/sudo.conf, /usr/bin/\* /etc/pam.d/sudo, /bin/sh, /bin/sudo \*			######This line added by *Platform Team* script#####" /etc/sudoers
			# The followind condition check if there selected user !SU attribute is not on the sudoer file then append it.-#
					# - The following condition is related to the current user selection that is not a sudoers user.-#
					# (Configuration-Option2-Sudoer Configurations-user selection-option1)#
						if [ $chksudofilesu -eq 0 ]; then
							rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')	
							sed -i -E "$rootsudonum a ${passwdarr[$((usrnum - 1))]}  ALL\=(ALL)  NOPASSWD\: ALL ,\!SU	 ######This line added by *Platform Team* script#####" /etc/sudoers 
						echo -e "Info:\n\n\tThe ${passwdarr[$((usrnum - 1))]} user has been configured as a limited sudoer user sinc now.";pause;
						# If the above condition(a top line) is not met, Print a message.-#
						# The following command inform that the current selected user is limited right now.-#
						# (Configuration-Option2-Sudoer Configurations-user selection-option1)#
						#else clear; echo "User limit shode hastesh hamin alan If in IF";sleep 5;fi
						else clear; echo "The ${passwdarr[$((usrnum - 1))]} is a restricted sudoer user right now";sleep 5;fi
				 # - The following condition is related to the current user selection that is not a sudoers user.-#
		   # -The followind condition check if there selected user !SU attribute is not on the sudoer file then append it.-#
		                 # (Configuration-Option2-Sudoer Configurations-user selection-option1)#
					elif [ $chksudofilesu -eq 0 ]; then
					rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
					sed -i -E "$rootsudonum a ${passwdarr[$((usrnum - 1))]}  ALL\=(ALL)  NOPASSWD\: ALL ,\!SU	 ######This line added by *Platform Team* script#####" /etc/sudoers
					echo -e "Info:\n\n\tThe ${passwdarr[$((usrnum - 1))]} user has been configured as a limited sudoer user sinc now.";pause;
       			      # If the above condition(Limited Or unlimited-$chksudogrp and $chksudofile) is not met, Print a message.-#
						# The following command inform that the current selected user is limited right now.-#
						# (Configuration-Option2-Sudoer Configurations-user selection-option1)#
    					else clear; echo -e "Erro:The ${passwdarr[$((usrnum - 1))]} is membered of limited sudoers group."; pause
		# close if that related to $chksu condition.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					  
					   	#esac;done
   # close if that related to $chksudogrp and $chksudofile condition.(Configuration-Option2-Sudoer Configurations-user selection-option1)#
					fi;break;;
                                 # $chkusrsu checks that the selected user wheter exist on the sudoers file.-#
			         #-(Configuration-Option2-Sudoer Configurations-user selection-option1)#
				#chkusrsu=$(grep -i -E "test.*su" /etc/sudoers | wc -l)
					# condition checks if selected user exists remove and append desired line.-#
					#-(Configuration-Option2-Sudoer Configurations-user selection-option1)# 
					#if [ $chkusrsu  ]

	###################################################################################################################################
					      #########################################
					     #         Sudoer Confiuration Part        #
					     #            Create a new user.           #
					      #########################################
				# Option 2 of sudoer configuration.
				2) 
				 # While used here to check that the answer is not empty or wrong.-#
				 #-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection)#
					while true ;echo -e "sudoer Configurations Part:\nsudoer mode selection:";sleep 0.5
				 # The question about user selection(limited or unlimited).-#
				 #-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection)#
						     echo -e "\n\nThe next step is create a new user name.\n\n";sleep 0.5
					echo -e "Which sudoer group should be the new user membered of?\
						    \n 1- Limited Sudoer(!SU).\n 2- Unlimited Sudoer."
				 # Input the number that related to the above question.-#
				 #-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection)#
					do sleep 0.5s; read -p "please select an option: " sudoermode
			         # The case used here to create options of above question-#
				 #-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection)#
					 case $sudoermode in
				 # The option 1 that related to limited sudoer(!SU)-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
						1) 
				 # While used here to check that the answer is not empty or wrong-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
						    while true; clear; echo -e "sudoer Configurations Part:\n\nCreate user step:";sleep 0.5
				 # Request from user to type a username for creating a new username.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					echo -e "Create a new user:\n In this step you have to create a user and providing a password."
				# Input username to create it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					sleep 0.5s; read -p "please enter the username here: " username
				# condition check that input is not empty-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					chkusername=$(awk -F":" '{print $1}' /etc/passwd | grep -E "^$username$" | wc -l)
					do if [ -z $username ];then
				# Print the error if above condition is met(if empty answer).-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					 	clear;echo -e "Error:\n\n\tThe username could not be empty.\
							\n\n\tPlease Type a username."; pause
				# condition to check that the typed username wheter exist.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					elif [ $chkusername -gt 0 ];then
				# print error if above condition is met.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					     	clear;sleep 0.5s;echo -e "Erro:\n\n\tThe user $username already exists.\
						     \n\n\tPlease enter the different user name";pause
				# If above condition is not met then create the new username and password.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
							else
							useradd -s /bin/bash -d /home/$username/ -m -U $username
						# Input the desired password.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
				   		clear; sleep 0.5s ;echo -e "In this page you must provide a password for entered user."
							sleep 1s;passwd $username
				# Fetch record of new user in sudoers(unlimited record) file if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
				 chksudofilenewusr=$(grep -E "(^$username.*ALL\s*#)|(^$username.*ALL\s*[^#]$)" /etc/sudoers | wc -l)
				# Fetch record of new user in sudoers file (limited record) if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
				 chksudofilesunewusr=$(grep -E "^$username.*ALL.*SU\s*" /etc/sudoers | wc -l)
                                 # Find line number of root user record in sudoers file to append new user after it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
				 rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
				# Find line number of cmnd or command alias depends on OS to append su allias record after it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					cmdnum=$(sudo grep -E -n 'Cmnd.*alias | Command.*Aliases' /etc/sudoers | awk -F":" '{print$1}')
				# Fetch record of SU alias in sudoers file if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
					chksu=$(grep -i "cmnd_alias su" /etc/sudoers | wc -l)
						# Check that if there !SU attribute for new user is not on the sudoers file,then add it.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
							if [ $chksudofilesunewusr -eq 0 ]; then
							sed -i -E "$rootsudonum a $username  ALL\=(ALL)  NOPASSWD\: ALL ,\!SU	 ######This line added by *Platform Team* script#####" /etc/sudoers;fi
					# Check that if there SU command alias is not on the sudoers file, then add it.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
							if [ $chksu -eq 0 ];then
									sed -i "$cmdnum a Cmnd_Alias SU = /bin/su root, /bin/su -, /bin/su, /usr/bin/su - root, /usr/bin/passwd, \!/usr/bin/passwd \[\%user\]\*, /usr/bin/passwd root, /bin/\* /etc/sudoers, /usr/bin/\* /etc/sudoers, /bin/\* sudoers, /usr/bin/\* sudoers, /usr/bin/sudo /usr/bin/su, /usr/bin/sudo /usr/bin/su \–, /usr/sbin/visudo, /sbin/visudo, /usr/bin/\* /etc/pam.d/\*, /usr/bin/\* sudo-i, /usr/bin/\* allowsudo-iusers, /usr/bin/yum update sudo, /usr/bin/yum remove sudo, /usr/bin/yum erase sudo, /usr/bin/rpm -e sudo, /usr/bin/\* /etc/shadow, /usr/bin/\* shadow, /usr/bin/\* /etc/sudoers.d/\*, /usr/bin/\* /etc/sudoers\*/\*, /usr/bin/sudo /bin/bash, /bin/bash, /usr/bin/\* sudoer\*, /usr/bin/\* /etc/sudo\*, /usr/bin/\* sudo.\*, /bin/csh, /bin/ksh, /bin/zsh, /usr/bin/\* /usr/bin/sudoedit, /usr/bin/sudoed\*, /usr/bin/\* sudoers.\*.\*, /usr/bin/\* /etc/sudoers.\*, /usr/bin/\* /etc/sudo.conf, /usr/bin/\* /etc/pam.d/sudo, /bin/sh, /bin/sudo \*			######This line added by *Platform Team* script#####" /etc/sudoers ;fi
						#echo "Shart bargharar shod.";fi;pause
							#fi;done;;
				# Print a message that the new username has been created.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option1)#
     clear;echo -e "info:\n\n\tThe user $username has been created and membered of limited sudoer(!SU) users.";pause;break;fi;done;break;;
						 #Option 2 	
						2)
							 # While used here to check that the answer is not empty or wrong-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
							 while clear; echo -e "sudoer Configurations Part:\n\nCreate user step:";sleep 0.5
					 # Request from user to type a username for creating a new username.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					echo -e "Create a new user:\n In this step you have to create a user and providing a password."
					# Input username to create it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					sleep 0.5s; read -p "please enter the username here: " username
				# condition check that input is not empty-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					chkusername=$(awk -F":" '{print $1}' /etc/passwd | grep -E "^$username$" | wc -l)
						do if [ -z $username ];then
				# Print the error if above condition is met(if empty answer).-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					 	clear;echo -e "Error:\n\n\tThe username could not be empty.\
							\n\n\tPlease Type a username."; pause
				# condition to check that the typed username wheter exist.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					elif [ $chkusername -gt 0 ];then 
				# print error if above condition is met.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					     	clear;sleep 0.5s;echo -e "Erro:\n\n\tThe user $username already exists.\
						     \n\n\tPlease enter the different user name";pause
		# If above condition is not met then create the new username and password.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
							else 
							useradd -s /bin/bash -d /home/$username/ -m -U $username
				   		clear; sleep 0.5s ;echo -e "In this page you must provide a password for entered user."
						# Input the desired password.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
							sleep 1s;passwd $username
				# Fetch record of new user in sudoers(unlimited record) file if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
			         chksudofilenewusr=$(grep -E "(^$username.*ALL\s*#)|(^$username.*ALL\s*[^#]$)" /etc/sudoers | wc -l)
				# Fetch record of new user in sudoers file (limited record) if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
				 chksudofilesunewusr=$(grep -E "^$username.*ALL.*SU\s*" /etc/sudoers | wc -l)
                                 # Find line number of root user record in sudoers file to append new user after it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
				rootsudonum=$(grep -E -n 'root.*ALL' /etc/sudoers | awk -F":" '{print $1}')
				# Find line number of cmnd or command alias depends on OS to append su allias record after it.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					cmdnum=$(sudo grep -E -n 'Cmnd.*alias | Command.*Aliases' /etc/sudoers | awk -F":" '{print$1}')
				# Fetch record of SU alias in sudoers file if there is.-#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
					chksu=$(grep -i "cmnd_alias su" /etc/sudoers | wc -l)
		# Check that if there !SU attribute for new user is not on the sudoers file,then add it.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#		
							if [ $chksudofilenewusr -eq 0 ]; then
							sed -i -E "$rootsudonum a $username  ALL\=(ALL)  NOPASSWD\: ALL		######This line added by *Platform Team* script#####" /etc/sudoers;fi
					# Check that if there SU command alias is not on the sudoers file, then add it.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
							if [ $chksu -eq 0 ];then
									sed -i "$cmdnum a Cmnd_Alias SU = /bin/su root, /bin/su -, /bin/su, /usr/bin/su - root, /usr/bin/passwd, \!/usr/bin/passwd \[\%user\]\*, /usr/bin/passwd root, /bin/\* /etc/sudoers, /usr/bin/\* /etc/sudoers, /bin/\* sudoers, /usr/bin/\* sudoers, /usr/bin/sudo /usr/bin/su, /usr/bin/sudo /usr/bin/su \–, /usr/sbin/visudo, /sbin/visudo, /usr/bin/\* /etc/pam.d/\*, /usr/bin/\* sudo-i, /usr/bin/\* allowsudo-iusers, /usr/bin/yum update sudo, /usr/bin/yum remove sudo, /usr/bin/yum erase sudo, /usr/bin/rpm -e sudo, /usr/bin/\* /etc/shadow, /usr/bin/\* shadow, /usr/bin/\* /etc/sudoers.d/\*, /usr/bin/\* /etc/sudoers\*/\*, /usr/bin/sudo /bin/bash, /bin/bash, /usr/bin/\* sudoer\*, /usr/bin/\* /etc/sudo\*, /usr/bin/\* sudo.\*, /bin/csh, /bin/ksh, /bin/zsh, /usr/bin/\* /usr/bin/sudoedit, /usr/bin/sudoed\*, /usr/bin/\* sudoers.\*.\*, /usr/bin/\* /etc/sudoers.\*, /usr/bin/\* /etc/sudo.conf, /usr/bin/\* /etc/pam.d/sudo, /bin/sh, /bin/sudo \*			######This line added by *Platform Team* script#####" /etc/sudoers ;fi
						#echo "Shart bargharar shod.";fi;pause
							#fi;done;;
					# Print a message that the new username has been created.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option2)#
      clear;echo -e "info:\n\n\tThe user $username has been created and membered of sudoer(Unlimited) users.";pause;break;fi;done;break;;
						
						 #end of option 2
						  #;;
					# Print an error if the answer is empty or wrong.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option2 new user-sudoer mode selection-option*)#
						*)clear;echo -e "Error:\n\n\tAnswer the question could not be empty.\
						\n\n\tPlease select an option."; pause;;
					# end of case for sudoer mode selection of create a new user.
					  esac;done;break;;
					# Print an error if the answer is empty or wrong.#
		#-(Configuration-Option2-Sudoer Configurations-user selection-option*)#
					#clear;echo $chksudo;sleep 3;;
			      *) clear; sleep 0.5s ;echo -e "Error:\n\n\tAnswer the question could not be empty.\
							\n\n\tPlease select an option.";pause;;
		         
                        # Close option2 of sudoer Configurations Part(line 556) and also it's While.-#
			#(Configuration-Option2-Sudoer Configurations-user selection-case-while)#
			esac;break;done;;	
	# Option 3 of the configuration selection.(Configuration-Option3)#	 
	3) 
		# this option has been sriten just for CentOS/RHEL distro, if OS is CentOS/RHEL the SELINUX will be disabled.
		if [[ "$os" = "ubuntu" || "$os" = "Ubuntu" ]];then
		clear;exit # on the ubuntu OS cuases exit of script.
		# if the OS is CentOS/RHEL the SELINUX will be disabled. Moreover, before any changes backup of config file will be taken.
		elif [[ "$os" = "CentOS" || "$os" = "centos" || "$os" = "Red" || "$os" = "red" ]];then
			# take a backup of config file before any changes.
			cp /etc/selinux/config /etc/selinux/config-bak-scriptbackup-$(date +%F-%R)
			# change to any mode to disabled mode.
			sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
		   	clear
	echo -e "Info:\n\n\tThe configuration has been setting successfully.Please pay attention that,selinux will not be effected,unless reboot the system.";pause
		fi
	  	;;	
	4) clear;exit;;
      	# Option 3,clear the screen,print error if the answer has been empty.-
      	# -close Option 3 of configuration selection-.(Configuration-option4)#
     	*) clear;sleep 0.5s;echo -e "Error:\n\n\tThe input could not be empty.\n\n\tPlease select a number.";pause;; #sleep 2 => pause 
# Close the case related to the configuration selection.(Configuration-case and while)
#unset $passwdarr
esac;done
