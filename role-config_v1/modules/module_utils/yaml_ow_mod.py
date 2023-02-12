#!/usr/bin/python3
import yaml
from yaml.loader import SafeLoader # import safeloader to load main.yaml file.
def yaml_ow_func(user_input_dict, main_yaml_path):
    #print(user_input_dict)
    with open(main_yaml_path) as file: # import main.yaml file to a main_yaml_dict variable as a dictionary.
        main_yaml_dict = yaml.load(file, Loader=SafeLoader) # use yaml.loader to load all subsets of main.yaml file.
    #print(main_yaml_dict)
    main_yaml_dict.update(user_input_dict) # update or merge user_input_dict to main_yaml_dict dictionary(update ntp-server from user_input_dict into main_yaml_dict dictionary)
    #print(main_yaml_dict)
    #with open ('/root/msh/msh-venv/role-config/modules/module_utils/main.yaml', 'w') as convert_file:   # loop will export new created dictionary to main.yaml file.
    with open (main_yaml_path, 'w') as convert_file:   # loop will export new created dictionary to main.yaml file.
        convert_file.write(yaml.dump(main_yaml_dict)) # convert_file variable will read main_yaml_dict keys and values to write to the mentioned file.
    #return main_yaml_dict
    #print(main_yaml_dict)
    #print(user_input_dict)
