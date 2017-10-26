# go2host

## Presentation

The script allows to present a list of server in order to connect in ssh.  
The script lets you jump quickly to a server.  


## Requirement

* SSH accessibility to your servers
* Need a conf file, it must be in the format below (descr,login,password are optionals) :  
```
id; hostname; ipaddress; (descr; login; password)
100;host1;10.0.0.1;(description_with_no_space;root;supersecurepassword)
```
* Need to change inside the script go2host.pl about 2 variables :  
  - $conf => your conf file with hostnames and @ip (respect specific file format)
  - $sshpass => path to the binary sshpass

## Todo

* ~~display information in right columns (instead of tabulations)~~
* ~~possible to filter during the question : Choose an id (or filter)~~
* row id optional => the script provides an id that starts at 100
* management of #tags (in addition to or instead of the description field)

## Utilization

**Example1 (no filter) :**
```
/go2host.pl 
100      host1
101      host2
102      host3
104      host4
105      web1
106      web2
107      web3
108      web4
Type id (or filter) : 100
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@host1 ~]# 
```
**Example2 (with filter) :**
```
/go2host.pl web
105      web1
106      web2
107      web3
108      web4
Type id (or filter) : 108
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@web4 ~]# 

