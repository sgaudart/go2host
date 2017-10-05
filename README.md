# go2host

## Presentation

The script allows to present a list of server in order to connect in ssh.  
The script lets you jump quickly to a server.  


## Requirement

You need to create a config file. The configuration file (variable $conf) must be in the format:  

    id; hostname; ipaddress; login; password
    100;host1;10.0.0.1;root;supersecurepassword
    
Before executing the script, please change the variables :

* $conf => your conf file with hostnames and @ip (respect specific file format)
* $sshpass => path to the binary sshpass

## Utilization

**Example1 (no filter) :**
```
/go2host.pl 
100	host1
101	host2
102	host3
104	host4
105	web1
106	web2
107	web3
108	web4
Your choice: 100
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@host1 ~]# 
```
**Example2 (with filter) :**
```
/go2host.pl web
105	web1
106	web2
107	web3
108	web4
Your choice: 108
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@web4 ~]# 

