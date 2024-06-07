# Linux Enrollment Samples

## "access.yml" Ansible Playbook:
Playbook used to create access scripts for each device in the inventory.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Jinja template 'access.j2'

### Usage:

```ansible-playbook access.yml -i inventory --ask-vault-pass```

## "audit.yml" Ansible Playbook:
Playbook used to audit devices in inventory prior to enrollment.
Shell scripts are pushed to the devices to create a report.
The report is pulled back to the bastion and remote files cleaned up.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Jinja templates for shell scripts:
     - rhel_audit.sh.j2
     - suse_audit.sh.j2
     - ubuntu_audit.sh.j2

### Usage:

```ansible-playbook audit.yml -i inventory --ask-vault-pass```

## "enrollment.yml" Ansible Playbook:
Playbook used to satisfy enrollment prerequisites for monitoring and support for Linux servers.
Required packages are installed. Configuration files are created or updated as needed.
Accounts and an access group is configured.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Python2/3 scripts to collect device types for SNMP collection <Files Omitted>
 - Jinja templates for configuration files <Files Omitted>

### Usage:

```ansible-playbook enrollment.yml -i inventory --ask-vault-pass```

## "qa.yml" Ansible Playbook:
Playbook used to qa devices in inventory after enrollment.
Shell scripts are pushed to the devices to create a report.
The report is pulled back to the bastion and remote files cleaned up.
Local bastion qa output is then appended to the existing report.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Jinja templates for shell scripts:
     - qa_local.sh.j2
     - qa_remote.sh.j2

### Usage:

```ansible-playbook qa.yml -i inventory --ask-vault-pass```

## "syslog_search.sh" Bash Script:
Script was created to confirm log remote logging was configured correctly. 
The devices in the inventory file are searched for in the 'syslog' log file and archive directories.
Archive files required the use of 'bzcat' to unzip while searching.
The first 3 log files per device name are saved to a report. 
Once logs are found, the script moves on to the next device in the inventory list.

### Requires:

 - An 'inventory' file in the same directory as the script
 - A syslog file located at '/var/log/syslog' 
 - Zipped archive files located at '/home/archive/logs/YYYY/MM'

 ### Usage:

 ```./syslog-search.sh # Optional[-h]```

## "add_fw_rule.yml" Ansible Playbook:
Simple playbook to add a firewall rule for SNMP traffic when needed.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault

### Usage:

```ansible-playbook add_fw_rule.yml -i inventory --ask-vault-pass```

## "setup_accounts.yml" Ansible Playbook:
Playbook written to accomplish user account tasks prior to enrollment. 
A new account is created for management and added to the access group. 
The existing ansible_user account is added to the access group and password reset. 

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Hashed passwords can be created with the command 'mkpasswd -m sha512crypt'

### Usage:

```ansible-playbook setup_accounts.yml -i inventory --ask-vault-pass```

## "clamav.yml" Ansible Playbook:
Playbook written to install Clam antivirus. 
All needed configuration is completed including setting an optional proxy.
A scan of '/home' directories is completed to confirm functionality.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - 'clamdscan.sh.j2' Jinja template to configure scan frequency and scope in cron

### Usage:

```ansible-playbook clamav.yml -i inventory --ask-vault-pass```

## "qualys.yml" Ansible Playbook:
Playbook written to install the Qualys Cloud Agent.
Installer files are copied to remote devices and installed. 
Devices are registered and activated.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Qualys installer '.deb' and '.rpm' packages <Files Omitted>

### Usage:

```ansible-playbook qualys.yml -i inventory --ask-vault-pass```