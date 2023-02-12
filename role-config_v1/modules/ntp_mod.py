#!/usr/bin/python3
#-----------------------------------
# name: ntp_nodule
# Author: SHM
# Version: 1
# Date: 2023/02/09
#-----------------------------------
# Description:
#   This module is written to puts\
#   taken values in a dictionary\
#   and finally writes the created\
#   dictionary to the ansible values file.
# ***** Start of the script. *****
# sys function imported for sys.path.insert\
# os function imported for clear the page.
import sys,os
# sys.path.insert could load other function\
# from specifict path.
sys.path.insert(0, 'modules/module_utils')
# Load "ip_while_func" function from\
# "ip_while_mod" module.
#from ip_while_mod import ip_while_func
from ip_error_mod import ip_error_func
# Load "ans_while_func" function from\
# "ans_while_mod" module.
#from ans_while_mod import ans_while_func
from ans_error_mod import ans_error_func
# Load "yaml_ow_func" function from\
# "yaml_ow_mod" module.
from yaml_ow_mod import yaml_ow_func
# ntp_main_func has been defined to use in\
# the main script(role-config.py).
def ntp_main_func():
    # define a dictionary with 'ntp_server' as a 
    # empty key to append subsets key and values later.
    ntp_user_input_dict = {'ntp_server':{}}
    # ntp_main_yaml_path variable has been defined\
    # to use in yaml_ow_func function.
    ntp_main_yaml_path= '/root/msh/msh-venv/role-config/main.yaml'
    # define ntp_ask variable as 0 for check it in while.
    ntp_ask = 0
    # ntp_server_counter variable is defined to use in 
    # "ntp_server_key" variable to make ntp_server_key 
    # like "server1", "server2","server3", etc.
    ntp_server_counter = 1
    # This function use to clear the page at first.
    os.system('clear')
    # loop will continue unless ntp_ask will not be 0.
    while ntp_ask == 0  :
        # ntp_tg_srv_input_msg variable is defined to use in\ 
        # ip_while_func function to change "Please enter your {} server"\
        # message based on entered string.
        # note: It causes change the mentioned message dynamicly.
        ntp_tg_srv_input_msg = 'NTP'
        # ntp_user_input_ip variable is defined to use in\ 
        # ntp_user_input_dict\as a value of ntp_server_key\ 
        # and the value of that comes from the ip_while_func function.
        ntp_user_input_ip = ip_error_func(ntp_tg_srv_input_msg)
        # ntp_user_input_answer variable will be used in the following if\
        # its value comes from the ans_while_func function.
        ntp_user_input_answer = ans_error_func(ntp_tg_srv_input_msg)
        # The condition check the user input answer.
        if ntp_user_input_answer == 'n':
            # ntp_ask value will be increased\
            # if the above condion is true.
            ntp_ask = 1
        # ntp_user_inout_ip value will be changed\
        # as the following format:\ 
        # server 172.20.8.5" or "server 172.20.8.6"\
        # actually, server will be appended before\
        # the ntp_user_input_ip value.
        ntp_user_input_ip = 'server {}'.format(ntp_user_input_ip)
        # ntp_server_key valeu will be changed\
        # as the following format:\
        # "server1:" or "server2:" or "server3:"\
        # actually ntp_server_counter will be increased\
        # a unit in each loop cycle.
        ntp_server_key = 'server{}'.format(ntp_server_counter)
        # the ntp_server_key as a key and ntp_user_input_ip\
        # as its value will be appended to ntp_user_input_dict\ 
        # as the subset of 'ntp_server' key, for example:\
        # ntp_user_input_dict = 
        #       {'ntp_server':
        #               {'server1':'server 172.20.8.5', 
        #               'server2':'server 172.20.8.6'}}
        ntp_user_input_dict['ntp_server'][ntp_server_key] = ntp_user_input_ip
        # ntp_server_counter will be increased in each loop cycle.
        ntp_server_counter +=1
    # yaml_ow_func function is used to open "main.yaml" file and writing\
    # the valeu of ntp_user_input_dict on "main.yaml" file.
    yaml_ow_func(ntp_user_input_dict, ntp_main_yaml_path)
# ***** End of the script. *****
