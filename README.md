# go2host

## Presentation

The script allows to present a list of server in order to connect in ssh.  
The script lets you jump quickly to a server and show you a list of servers.  



## Requirement

You need to create a config file. The configuration file (variable $conf) must be in the format:  

    id; hostname; ipaddress; root_password
    
Before executing the script, please change the variables :

* $conf => your conf file with hostnames and @ip (respect specific file format)
* $sshpass => path to the binary sshpass
