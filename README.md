# go2host

## Presentation

The script allows to present a list of server ([from config file](https://github.com/sgaudart/go2host/blob/master/hosts.conf)) in order to connect in ssh   
The script lets you jump quickly to a server.  
You can use an argument to filter the given servers list.


## Requirement

* SSH accessibility to your servers
* Need a conf file, it must be in the format below (id,ip,descr,login,password are optionals) :  
```
(id;)hostname;(ip;descr;login;password)
100;host1;(10.0.0.1;description_with_no_space;root;supersecurepassword)
101;host2;(10.8.0.5;description_with_no_space;newlogin;supersecurepassword)
```
* ip is optionnal but hostname is compulsory, you can add the ip info that will be used preferably against the hostname
* Need to change inside the script go2host.pl about 2 variables :  
  - $conf => your conf file with hostnames and @ip (respect specific file format)
  - $sshpass => path to the binary sshpass

## Tested with 

* Perl v5.22.1

## Todo

* ~~display information in right columns (instead of tabulations)~~
* ~~possible to filter during the question : Choose an id (or filter)~~
* ~~row id optional => the script provides an id that starts at 1.~~
* manage the first row of column names (not show when filter or when no id in conf file)
* manage #tags ? (in addition to or instead of the description field)

## Utilization

**Example1 (no filter) :**
```
./go2host.pl 
101      host1
102      host2
103      host3
104      host4
401      web1
402      web2
403      web3
404      web4
Type id (or filter) : 101
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@host1 ~]# 
```
**Example2 (with filter) :**
```
./go2host.pl web or ./go2host.pl ^4
401      web1
402      web2
403      web3
404      web4
Type id (or filter) : 404
You are redirected to :
Last login: Thu Oct  5 11:14:15 2017
[root@web4 ~]# 

