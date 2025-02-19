#secure-ssh.sh
#author benjamintyler367
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled form the remote repo 
#removes roots ability to ssh in 
#!/bin/bash
sudo useradd -m -d /home/${1} -s /bin/bash ${1}
sudo mkdir /home/${1}/.ssh
cd /home/benjamin/SYS-265-Tech-Journal
sudo cp /home/benjamin/SYS-265-Tech-Journal/id_rsa.pub /home/${1}/.ssh/authorized_keys
sudo chmod 700 /home/${1}/.ssh
sudo chmod 600 /home/${1}/.ssh/authorized_keys
sudo chown -R ${1}:${1} /home/${1}/.ssh

#block root ssh logon, this is to make it more secure and prevent portential attacks. 

if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
	sudo sed -i 's/^PermitRootLogin. */PermitRootLogin no/' /etc/ssh/sshd_config
else 
	echo "PermitRootLogin not found in /etc/ssh/sshd_config"
fi

# restart ssh to apply changes
sudo systemctl restart sshd.service
