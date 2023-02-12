#!/usr/bin/python3
import time,json,re,yaml   # import time for pause the screen, json for json dump, re for regexp
from yaml.loader import SafeLoader # import safeloader to load main.yaml file.
#import ruamel.yaml
#import json
#import re
#server = 'server'
dic = {'ntp_server':{}} # define dic with 'ntp_server' as a empty key to append the values later.
ask = 0  # define ask variable as 0 for check it in while.
counter = 1 # define counter to use it in number of server key in dictionary.
while ask == 0  :  # loop will continue unless ask will not be 0.
    ip = input('please enter your ip:') # define ip variable to get value from end user. 
    check_ip = re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$",ip) #define check_ip variable to check regex of input of ip variable.
    #print(check_ip)    # test
    #time.sleep(2) #pause screen 2 seconds. #test
    #server = 'server'
    while check_ip is None:  # loop will be worked until check_ip will not be none.
            print ('Error\nthis option is required, please enter ip address.') # Error if check_ip will be not passed.
            time.sleep(2) #pause screen 2 seconds.
            ip = input('please enter your ip:') # define ip variable againg untill check_ip will be none.
            check_ip = re.match(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$",ip) #check regex of input of ip variable.
    ans = input('do you want to add another?(please enter \'y\' or \'n\')') # define ans variable to force the end user to answer question.
    check_ans = re.match(r"^y|n$",ans) #check regex of input of ans variable.
    #print(test2)
    while check_ans is None: # loop will be worked unless check_ans will be none.
            print ('Error\nthis option is required, please answer the question.')
            time.sleep(0.5) #pause screen 2 seconds.
            ans = input('do you want to add another server?(please enter \'y\' or \'n\')') # define ans variable again untill check_ans will be none.
            check_ans = re.match(r"^y|n$",ans) # check regex of ans variable input ubtil chech_ans will be none.
        #print ('please enter your servers\'s ip address again.')
        #time.sleep(2) #pause screen 2 seconds.
        #dic = {}
        #continue
        #print (dic)
    if ans == 'n':
        ask = 1
    ip = 'server {}'.format(ip) # append server before ip same as main.yaml file(for example "server1: server 1.1.1.1").
    server = 'server{}'.format(counter) #define as key in dictionary and using format to assign a number to server variable.
    dic['ntp_server'][server] = ip # define dic as a dictionary to assign key(server) and value(ip).
    counter +=1 # icreasing a unint to counter to use in number of dictionary key.

#print (dic)
#with open ('json.json', 'w') as convert_file:   # loop will create a file as 'json.json' name in current directory.
 #   convert_file.write(yaml.dump(dic)) # convert_file variable will read dic keys and values to write to the mentioned file.
with open('main.yaml') as file: # import main.yaml file to a data variable as a dictionary.
        data = yaml.load(file, Loader=SafeLoader) # usw yaml.loader to load all subsets of main.yaml file.
        #print(data)
#data.update(dic)
#print('data dictionary =',data)
#print('-------------------------------------------------------------------------------')
#print('-------------------------------------------------------------------------------')
#print('dic dictionary =', dic)
#print('-------------------------------------------------------------------------------')
#print('-------------------------------------------------------------------------------')
data.update(dic) # update or merge dic to data dictionary(update ntp-server from dic into data dictionary)
#print('updated dictionary = ',data)
with open ('main.yaml', 'w') as convert_file:   # loop will export new created dictionary to main.yaml file.
    convert_file.write(yaml.dump(data)) # convert_file variable will read data keys and values to write to the mentioned file.
