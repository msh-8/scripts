#!/usr/bin/python3
#-----------------------------------
# name: ans_while_module
# Author: SHM
# Version: 1
# Date: 2023/02/12
#-----------------------------------
# Description:
#   This function input a variable\
#   named "user_input_ip" as a ip\
#   then check it with regex pattern\
#   finnaly return it's value\
#   to be used in another script.
# ***** Start of script. *****
# re module to use regex\
# time module to use time.sleep
import re,time
# function is called ip_while_func written\
# to get a value from user and checking\
# entered value with regex pattern.\
# As a result, returns value, if it is matched\
# with pattern else repeat procidure\
# until regex pattern passes the valeu.
def ip_error_func(tg_srv_input_msg):
    # get the value from user.
    user_input_ip = input('Please enter your {} server '\
    'ip ( for example 172.20.8.5 ):'.format(tg_srv_input_msg))
    # The entered value will be matched with regex pattern.
    #pattern = r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
    pattern = r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b"
    regex_check_user_input_ip = \
    re.match(pattern,user_input_ip)
    if regex_check_user_input_ip is None:
        raise Warning("""
                        ==================================================
                        The entered value is not acceptable.
                        You have to type only ip.
                        for example, 172.20.8.5
                        Please run script again.
                        If there is any question, please contact to admin.
                        ==================================================
                        """)
    # return value of user_input_answer as function output.
    return user_input_ip
