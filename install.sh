#!/bin/bash
# get username that called script
echo $SUDO_USER
ME=$SUDO_USER
ssh_setup() {
# SSH section used from Cheema
		# Check network connection
        if ! ping -c 1 fry.cs.wright.edu &> /dev/null; then
        echo "[ERROR] Not connected to WSU-Secure or Wright State VPN. Please connect before setting up SSH."
        exit 1
        fi

        # Check if ~/.ssh folder exists. If not, create it.
        if [ ! -d ~/$ME/.ssh ]; then
        echo "[INFO] Creating SSH folder..."
        mkdir -p ~/$ME/.ssh
        else
        echo "[INFO] SSH folder exists, continuing..."
        fi

        # Symbolically link authorized_keys
        ln -sf ~/$ME/dotfiles/authorized_keys ~/$ME/.ssh/authorized_keys

        # Create or update ~/.ssh/config file with an entry for fry.cs.wright.edu
        if [ ! -f ~/$Me/.ssh/config ]; then
        echo -e "Host fry\n\tUser w413jxh\n\tHostName fry.cs.wright.edu\n\tPort 22" > ~/$ME/.ssh/config
        else
        # Ensure entry doesn't already exist
        if ! grep -q "Host fry" ~/$ME/.ssh/config; then
            echo -e "\nHost fry\n\tUser w413jxh\n\tHostName fry.cs.wright.edu\n\tPort 22" >> ~/$ME/.ssh/config
        fi
		chown -R $ME:root "/home/$ME/.ssh"
    fi

        # Symbolically link config file
        ln -sf ~/$ME/dotfiles/config ~/$ME/.ssh/config
		echo "[INFO] SSH setup completed."
}

vim_setup() {
    # Ensure Vim plugin manager (Vundle) is installed
    if [ ! -d ~/$ME/.vim/bundle/Vundle.vim ]; then
        echo "[INFO] Installing Vundle..."
        git clone https://github.com/VundleVim/Vundle.vim.git ~/$ME/.vim/bundle/Vundle.vim
    else
        echo "[INFO] Vundle already installed, skipping..."
    fi

    # Ensure the Gruvbox color scheme is installed
    if [ ! -f ~/$ME/.vim/colors/gruvbox.vim ]; then
        echo "[INFO] Installing Gruvbox color scheme..."
        mkdir -p ~/$ME/.vim/colors
        curl -o ~/$ME/.vim/colors/gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
    else
        echo "[INFO] Gruvbox color scheme already installed, skipping..."
    fi

    # Ensure the vim-airline plugin is installed
    if [ ! -d ~/$ME/.vim/bundle/vim-airline ]; then
        echo "[INFO] Installing vim-airline..."
        git clone https://github.com/vim-airline/vim-airline ~/$ME/.vim/bundle/vim-airline
    else
        echo "[INFO] vim-airline already installed, skipping..."
    fi

    echo "[INFO] Vim setup completed."
}

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
		    bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p ~/anaconda3
			echo "PATH=$PATH:~/anaconda3/bin" >> ~/.profile
	        else
	 		echo "Downloading Anaconda3 installer. . ."		
			curl --progress-bar -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
		    bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p ~/anaconda3
			echo "PATH=$PATH:~/anaconda3/bin" >> ~/.profile
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
		ssh_setup
		vim_setup
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