#!/usr/bin/env bash

# reference to the config, helper and other setup scripts
source ./centos_setup_resources/centos_config.sh
source ./centos_setup_resources/centos_helper.sh
source ./centos_setup_resources/centos_initial_setup.sh
source ./centos_setup_resources/centos_secure_sshd.sh

########### START Checking privileges ###########

# check if user has privileges to run the script
if [[ $EUID > 0 ]]; then
   print_notification_information "Please run this script as root or with the sudo command!"
   exit 1
fi

########### END Checking privileges ###########

########### START Checking CentOS version ###########

centos_version=$(get_centos_version)

# Equality Comparison
if [ "$centos_version" == "$CENTOS_822004" ]
then
	print_setup_start_information "Start installation for CentOS 822004"
elif [ "$centos_version" == "$CENTOS_832011" ]
then
	print_setup_start_information "Start installation for CentOS 832011"
elif [ "$centos_version" == "$CENTOS_STREAM8" ]
then
	print_setup_start_information "Start installation for CentOS Stream release 8"
else
    print_notification_information "No compatible CentOS version detected: $centos_version"
    exit 0
fi

########### END Checking CentOS version ###########

initial_centos_setup

# reboot in case of a new kernel
if [ "$devmode" = true ]; then
	exit 0
fi
reboot
