#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ $( id -u ) -eq 0 ]; then
	echo "You must NOT be root to run this script."
	exit
fi

USERNAME=$(logname)

# This is the script for obtaining all of the repositories needed to generate Diet Swift Linux.

get_rep ()
	{
	if [ -d "/home/$USERNAME/develop/$1" ]; then
		echo "Repository $1 already present."
	else
		cd /home/$USERNAME/develop
		git clone git@github.com:swiftlinux/$1.git
	fi
	return 0
	}

# From http://info.solomonson.com/content/setting-ssh-agent-ask-passphrase-only-once
# Start up ssh-agent to save your password.
# This allows you to download all repositories while entering your password just once.

tempfile=/tmp/ssh-agent.test
 
#Check for an existing ssh-agent
if [ -e $tempfile ]
then
    echo "Examining old ssh-agent"
    . $tempfile
fi
 
#See if the agent is still working
ssh-add -l > /dev/null
 
#If it's not working yet, just start a new one.
if [ $? != 0 ]
then
    echo "Old ssh-agent is dead..creating new agent."
 
    #Create a new ssh-agent if needed
    ssh-agent -s > $tempfile
    . $tempfile
 
    #Add the key
    ssh-add
fi    
 
#Show the user which keys are being used.
ssh-add -l

# ssh-agent is now implemented.  Now it's time to download all repositories.

get_rep 0-intro
get_rep add_help
get_rep apt
get_rep conky
get_rep control_center
get_rep iceape
get_rep icewm
get_rep installer
get_rep menu-update
get_rep mime
get_rep remove_languages
get_rep remove_packages
get_rep rox
get_rep security
get_rep slim
get_rep sylpheed
get_rep wallpaper-standard

# Now that the repositories are downloaded, it's time to delete the saved passwords.
rm -r /tmp/ssh*