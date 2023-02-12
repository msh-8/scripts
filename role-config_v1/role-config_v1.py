#!/usr/bin/python3
#-----------------------------------
# Author: SHM
# Version: 1
# Date: 2023/02/09
#-----------------------------------
# This script is writen to\
# run ansible-playbooks\ 
# withoud any ansible knowladge requirement.
# it causes ansible become easy to use.
# This is the main script\
# you can follow the modules and modules/module_utils directory\
# to find other scripts(functions) that have been used.
# ***** Start of the script.*****
# sys function imported for sys.path.insert\
# subprocess function imported for subprocess.run
import sys,subprocess,re
# sys.path.insert could load other function\
# from specifict path.
sys.path.insert(0, 'modules/')
# Load "ntp_main_func" function from ntp_mod
from ntp_mod import ntp_main_func
pattern = r"^(1|2)$"
item_user_select = input('server configurtaion list:'\
'\n1- NTP\n2- DNS'\
'\nplease select a number: ')
rematch_item_user_select = re.match(pattern, item_user_select)
if rematch_item_user_select == None:
    raise Warning("""
                    ==================================================
                    The entered value is not acceptable.
                    You have to type only a number of the list.
                    Please run script again.
                    If there is any question, please contact to admin.
                    ==================================================
                    """)
if item_user_select == '1':
    # call ntp_main_func
    ntp_main_func()
elif item_user_select == '2':
    print ('DNS server not ok.')
# ansible_playbook_name variable\
# is defined to use in subprocess.run\
# function to run a ansible-playbook command in bash.
ansible_playbook_name = 'install_ntp.yaml'
# run "ansible-playbook" command in bash.
###run_playbook = subprocess.run(["ansible-playbook", ansible_playbook_name])
# End of the script.
