#!/usr/bin/python3
#-----------------------------------
# Author: SHM
# Version: 1
# Date: 2023/02/07
#-----------------------------------
# Start of the script.
import time,json,re,yaml,os,subprocess   # import time for pause the screen, json for json dump, re for regexp
from yaml.loader import SafeLoader # import safeloader to load main.yaml file.
user_input_dict = {'ntp_server':{}} # define a dictionary with 'ntp_server' as a empty key to append the values later.
ask = 0  # define ask variable as 0 for check it in while.
server_counter = 1 # define counter to use it in number of "server_key" key in dictionary.
os.system('clear')
while ask == 0  :  # loop will continue unless ask will not be 0.
    user_input_ip = input('Please enter your NTP server ip ( for example 172.20.8.5 ):') # define user_input_ip variable to get value from end user. 
    regex_check_user_input_ip = re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$",user_input_ip) #define check_ip variable to check regex of input of user_input_ip variable.
    # start of the test.
    #print(check_ip)    # test
    #time.sleep(2) #pause screen 1 seconds. #test
    # end of the test.
    while regex_check_user_input_ip is None:  # loop will be worked until check_ip will not be none.
            #os.system('clear')
            print ('Error\nOnly ipv4 address model is acceptable.') # Error if check_ip will be not passed.
            time.sleep(1) #pause screen 1 seconds.
            #os.system('clear')
            user_input_ip = input('Please enter your NTP server ip ( for example 172.20.8.5 ):') # define user_input_ip variable againg untill check_ip will be none.
            regex_check_user_input_ip = re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$",user_input_ip) #check regex of input of user_input_ip variable.
    #os.system('clear')
    #time.sleep(0.5)
    user_input_answer = input('Would you like to add additional NTP server?( please enter \'y\' or \'n\' )') # define user_input_answer variable to force the end user to answer question.
    regex_check_user_input_answer = re.match(r"^y|n$",user_input_answer) #check regex of input of user_input_answer variable.
    while regex_check_user_input_answer is None: # loop will be worked unless regex_check_user_input_answer will be none.
            #os.system('clear')
            print ('Error\nOnly y or n keywords are acceptable.')
           # time.sleep(1) #pause screen 1 seconds.
           # os.system('clear')
            time.sleep(0.2)
            user_input_answer = input('Would you like to add additional NTP server?( please enter \'y\' or \'n\' )') # define user_input_answer variable again untill regex_check_user_input_answer will be none.
            regex_check_user_input_answer = re.match(r"^y|n$",user_input_answer) # check regex of user_input_answer variable input ubtil chech_ans will be none.
    if user_input_answer == 'n':
        ask = 1
    user_input_ip = 'server {}'.format(user_input_ip) # append server before ip same as main.yaml file(for example "server1: server 1.1.1.1").
    server_key = 'server{}'.format(server_counter) #define as key in dictionary and using format to assign a number to server_key variable.
    user_input_dict['ntp_server'][server_key] = user_input_ip #  assign key(server_key) and value(user_input_ip) to user_input_dict dictionary.
    server_counter +=1 # icreasing a unint to counter to use in number of server_key variable.
#start of the test.
#with open ('json.json', 'w') as convert_file:   # loop will create a file as 'json.json' name in current directory.
 #   convert_file.write(yaml.dump(dic)) # convert_file variable will read dic keys and values to write to the mentioned file.
# end of the test.
with open('main.yaml') as file: # import main.yaml file to a main_yaml_dict variable as a dictionary.
        main_yaml_dict = yaml.load(file, Loader=SafeLoader) # use yaml.loader to load all subsets of main.yaml file.
main_yaml_dict.update(user_input_dict) # update or merge user_input_dict to main_yaml_dict dictionary(update ntp-server from user_input_dict into main_yaml_dict dictionary)
with open ('main.yaml', 'w') as convert_file:   # loop will export new created dictionary to main.yaml file.
    convert_file.write(yaml.dump(main_yaml_dict)) # convert_file variable will read main_yaml_dict keys and values to write to the mentioned file.
run_playbook = subprocess.run(["ansible-playbook", "install_ntp.yaml"]) # run ansible-playbook install_ntp.yaml command in bash.
# End of the script.
