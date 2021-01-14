#!/usr/bin/env bash

# reference to the config, helper and other setup scripts
source ./centos_setup_resources/centos_helper.sh

initial_centos_setup()
{

if [ "$devmode" = true ]; then
	print_devmode_information "Skip - initial_centos_setup"
	return 0
fi

########### START Install Cockpit on CentOS 8 ###########

print_setup_start_information "CentOS 8 - Cockpit Web Console will get installed"

# install cockpit
dnf -y install cockpit

# start and enable the service
systemctl enable --now cockpit.socket

# activated firewalld service, allow Cockpit port to be accessed from machines within the network
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload

# access Cockpit Web Console on CentOS 8
print_setup_finish_information "Cockpit Web Console on CentOS 8 is enabled\nVisit - https://$(get_local_ipv4_address):9090 - to access it"

########### END Install Cockpit on CentOS 8 ###########

######### START install further tools and repos ###########

print_setup_start_information "Install software: vim, htop net-tools nload vnstat\nInstall repository: epel-release"

# install vim
dnf install -y vim

# add PowerTools repository
dnf config-manager --set-enabled powertools

# install development tools
dnf -y groupinstall 'Development Tools'

# enable EPEL (Extra Packages for Enterprise Linux) repository
dnf install -y epel-release

# install additional software (to check load and network)
dnf install -y htop net-tools nload vnstat

# install language packs
dnf install -y langpacks-en glibc-all-langpacks

print_setup_finish_information "Additional software and programs are installed"

########### END install further tools and repos ###########

######### START perform full system update ###########

print_setup_start_information "Performing full system update"

# perform a full system update
dnf -y  update

print_setup_finish_information "Full system update performed\n-- Rebooting the system is recommended"

######### END perform full system update ###########

########### START disabling SELinux ###########

# SOURCE (20210112): https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/using_selinux/index#changing-to-permissive-mode_changing-selinux-states-and-modes
# SOURCE (20210112): https://www.ibm.com/support/knowledgecenter/PurePower/p8ef9/p8ef9_selinux_setup.htm

print_setup_start_information "Settings SELinux to Permissive Mode"

# set SELinux to Permissive mode during this session
setenforce 0

# set SELINUX for the time of configuration to permissive
# in this stage, SELINX is active but only logs instead of enforces the settings
# this makes debugging during setup much easier as errors are not caused by SELINUX
sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config

print_setup_finish_information "SELinux is now in Permissive Mode.\nThis Permissve Mode will be persistent after reboot."
print_notification_information "SELinux is now in Permissive Mode!\nPlease install the right policies and set SELinux to Enforcing after setup!"

########### END disabling SELinux ###########

}