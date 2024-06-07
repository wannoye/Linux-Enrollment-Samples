# Linux Enrollment Samples

## "access.yml" Ansible Playbook

Used to create access scripts for each device in the inventory.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Jinja template 'access.j2'

### Usage:

```ansible-playbook access.yml -i inventory --ask-vault-pass```

## "audit.yml" Ansible Playbook

Complets an audit of devices in inventory prior to enrollment.<br/>
Shell scripts are pushed to the devices to create a report.<br/>
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

## "enrollment.yml" Ansible Playbook

Satisfies enrollment prerequisites for monitoring and support for Linux servers.<br/>
Required packages are installed. Configuration files are created or updated as needed.<br/>
Accounts and an access group is configured.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Python2/3 scripts to collect device types for SNMP collection <Files Omitted>
 - Jinja templates for configuration files <Files Omitted>

### Usage:

```ansible-playbook enrollment.yml -i inventory --ask-vault-pass```

## "qa.yml" Ansible Playbook

Completes QA tests against devices in inventory after enrollment.<br/>
Shell scripts are pushed to the devices to create a report.<br/>
The report is pulled back to the bastion and remote files cleaned up.<br/>
Local bastion qa output is then appended to the existing report.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Jinja templates for shell scripts:
     - qa_local.sh.j2
     - qa_remote.sh.j2

### Usage:

```ansible-playbook qa.yml -i inventory --ask-vault-pass```

## "syslog_search.sh" Bash Script

Created to confirm remote logging was configured correctly and is functioning.<br/>
The devices in the inventory file are searched in the 'syslog' file and archive directories.<br/>
Archive files required the use of 'bzcat' to unzip while searching.<br/>
The first 3 log files per device name are saved to a report.

### Requires:

 - An 'inventory' file in the same directory as the script
 - A syslog file located at '/var/log/syslog' 
 - Zipped archive files located at '/home/archive/logs/YYYY/MM'

 ### Usage:

 ```./syslog-search.sh # Optional[-h]```

## "add_fw_rule.yml" Ansible Playbook

Adds a firewall rule for SNMP traffic as needed.<br/>
Utilizes UWF for ubuntu and creates a rich rule for RedHat based servers.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault

### Usage:

```ansible-playbook add_fw_rule.yml -i inventory --ask-vault-pass```

## "setup_accounts.yml" Ansible Playbook

Written to accomplish user account creation and modification tasks prior to enrollment.<br/>
A new account is created for management and added to the access group.<br/>
The existing ansible_user account is added to the access group and password reset. 

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault<br/>
 
 Note: Hashed passwords can be created with the command 'mkpasswd -m sha512crypt'

### Usage:

```ansible-playbook setup_accounts.yml -i inventory --ask-vault-pass```

## "clamav.yml" Ansible Playbook

Installs Clam antivirus and completes all needed configuration.<br/>
The playbook tests if a proxy is needed and makes the configuration changes if so.<br/>
A scan of '/home' directories is completed to confirm functionality.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - 'clamdscan.sh.j2' Jinja template to configure scan frequency and scope in cron

### Usage:

```ansible-playbook clamav.yml -i inventory --ask-vault-pass```

## "qualys.yml" Ansible Playbook

Installs the Qualys Cloud Agent then registers and activates the devices.

### Requires:

 - An 'inventory' file in the same directory as the playbook
 - The 'group_vars/all.yml' file filled out and encrypted with ansible-vault
 - Qualys installer '.deb' and '.rpm' packages <Files Omitted>

### Usage:

```ansible-playbook qualys.yml -i inventory --ask-vault-pass```