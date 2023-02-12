#!/usr/bin/python3
#-----------------------------------
# name: ans_while_module
# Author: SHM
# Version: 1
# Date: 2023/02/09
#-----------------------------------
# Description of script:
# This function input a variable\
# named "user_input_answer" as "y or n"\
# character,then check it with regex pattern\
# finnaly return it's value \
# to be used in another script.
# ***** Start of the script. *****
# re module to use regex\
# time module to use time.sleep
import re,time
# function is called ans_while_func written\
# to get a value from user and checking\
# entered value with regex pattern.\
# As a result, returns value, if it is matched\
# with pattern else repeat procidure\
# until regex pattern passes the valeu.
def ans_while_func(tg_srv_input_msg):
    # get the value from user. 
    user_input_answer = \
    input('Would you like to add additional {} '\
    'server?( please enter \'y\' or \'n\' )'\
    .format(tg_srv_input_msg))
    # The entered value will be matched with regex pattern.
    pattern = r"^(y|n)$"
    regex_check_user_input_answer \
    = re.match(pattern,user_input_answer)
    # Loop will be worked unless\
    # regex_check_user_input_answer will be none.
    while regex_check_user_input_answer is None:
            #os.system('clear')
            # If the entered value is not matched with\ 
            # regex pattern the followin error will be appeared.
            print ('Error\nOnly y or n keywords are acceptable.')
            # pause the screen.
            time.sleep(1)
            # iterate to get the value.
            user_input_answer = input('Would you like to add'\
            'additional {} server?( please enter \'y\' or \'n\' )'\
            .format(tg_srv_input_msg))
            # repeat to check value with regex pattern.
            regex_check_user_input_answer = \
            re.match(pattern,user_input_answer)
    # return value of user_input_answer as function output.
    return user_input_answer
# ***** End of the script. *****
