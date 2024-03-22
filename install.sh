#!/bin/bash
# get username that called script
echo $SUDO_USER
ME=$SUDO_USER

# check if effective user id is 0 (root)

if [[ "$(id -u)" -eq 0 ]]; then
	echo "Script is running as root"
	# check if apt is package manager
	# if apt is package manager and you run which apt it will specify a path to where its stored
	echo $(which apt)
	if [[ -n "$(which apt)" ]]; then
		echo "apt is installed exactly as specified."
		apt-get update && apt-get install -y \
		    vim \
		    git \
		    nudoku \
			nmap \
			dnsutils \
			libgl1-mesa-glx \
			libegl1-mesa \
			libxrandr2 \
			libxrandr2 \
			libxss1 \
			libxcursor1 \
			libxcomposite1 \
			libasound2 \
			libxi6 \
			libxtst6
		if [[ -e $(ls Anaconda3*.sh 2> /dev/null | head -1) ]]; then
			echo "Anaconda3 installer found, running it. . ."
		    bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /home/$ME/anaconda3
			echo "PATH=$PATH:~/anaconda3/bin" >> /home/$ME/.profile
	        else
	 		echo "Downloading Anaconda3 installer. . ."		
			curl --progress-bar -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
		    bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /home/$ME/anaconda3
			echo "PATH=$PATH:/home/$ME/anaconda3/bin" >> /home/$ME/.profile
		fi
		if [[ -e $(ls aws/install.sh 2> /dev/null | head -1) ]]; then
		    echo "AWS installer found, running it. . ."
			bash ./aws/install -i /home/$ME/aws/ -b /home/$ME/aws/bin
			echo "PATH=$PATH:/home/$ME/aws/bin" >> /home/$ME/.profile
	        else
	 		echo "Downloading AWS-CLI installer. . ."		
			curl --progress-bar -O "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
            unzip awscli-exe-linux-x86_64.zip
            bash ./aws/install -i /home/$ME/aws/ -b /home/$ME/aws/bin
			echo "PATH=$PATH:/home/$ME/aws/bin" >> /home/$ME/.profile
		fi
		cd ~
		ln -sf /home/$ME/ceg2410s24-jhoward08/DotFiles/.gitconfig /home/$ME/.gitconfig
		touch /home/$ME/ceg2410s24-jhoward08/DotFiles/.gitignore
		echo "/home/$ME/ceg2410s24-jhoward08/Anaconda3-2024.02-1-Linux-x86_64.sh" >> /home/$ME/ceg2410s24-jhoward08/DotFiles/.gitignore
		echo "/home/$ME/ceg2410s24-jhoward08/awscli-exe-linux-x86_64.zip" >> /home/$ME/ceg2410s24-jhoward08/DotFiles/.gitignore
		echo "/home/$ME/ceg2410s24-jhoward08/configure.sh" >> /home/$ME/ceg2410s24-jhoward08/DotFiles/.gitignore
		echo 'alias ls="ls -lah"' >> /home/$ME/.bashrc
		echo 'alias rm="rm -i"' >> /home/$ME/.bashrc
                chown -R $ME:root "/home/$ME/anaconda3"
		chown -R $ME:root "/home/$ME/aws"
	else
		echo "apt is not installed at the specified location."
	fi
		# install packages with apt
else
	echo "Script is not running as root, exiting..." 1>&2
	exit 1
fi
