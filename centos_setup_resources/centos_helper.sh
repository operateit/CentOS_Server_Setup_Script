#!/usr/bin/env bash

# reference to the config, helper and other setup scripts
source ./centos_setup_resources/centos_config.sh

get_centos_version()
{
	local centos_version
	centos_version=$(cat /etc/centos-release | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
	# Equality Comparison
	if [ "$centos_version" == "8" ]
	then
		if [[ "$(cat /etc/centos-release)" == *"Stream"* ]]; then
			centos_version="Stream release 8"
		fi
	else
		# return identified version if no match
		centos_version=$(cat /etc/centos-release | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p')
	fi
	echo "$centos_version"
}

print_setup_start_information()
{
	local start_header
	local start_footer
	start_header="\n\n${CYAN}################## Installation Start ##################\n"
	start_footer="\n########################################################\n\n${NC}"
	echo -e "${start_header}${1}${start_footer}"
	sleep "$print_sleep"
}

print_setup_finish_information()
{
	local finish_header
	local finish_footer
	finish_header="\n\n${GREEN}################## Installation Finished ##################\n"
	finish_footer="\n###########################################################\n\n${NC}"
	echo -e "${finish_header}${1}${finish_footer}"
	sleep "$print_sleep"
}

print_notification_information()
{
	local notification_header
	local notification_footer
	notification_header="\n\n${ORANGE}################## IMPORTANT NOTIFICATION ##################\n"
	notification_footer="\n###########################################################\n\n${NC}"
	echo -e "${notification_header}${1}${notification_footer}"
	sleep "$print_sleep"
}

print_devmode_information()
{
	local devmode_header
	local devmode_footer
	devmode_header="\n\n${PURPLE}################## DEVMODE NOTIFICATION ##################\n"
	devmode_footer="\n###########################################################\n\n${NC}"
	echo -e "${devmode_header}${1}${devmode_footer}"
	sleep "$print_sleep"
}

get_local_ipv4_address()
{
	local local_ipv4_address
	# SOURCE (20201122): https://stackoverflow.com/a/13322549
	# getting the actual IP address of the network interface and format output
	local_ipv4_address=$(ip a | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
	echo $local_ipv4_address
}