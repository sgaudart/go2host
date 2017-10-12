#!/usr/bin/perl
#======================================================================
# Auteur : sgaudart@capensis.fr
# Date   : 29/08/2017
#======================================================================
use strict;
use warnings;

my $conf="hosts.conf";
my $filter = shift(@ARGV);
my $sshpass="/home/sgaudart/sshpass"; # path to the command sshpass
my $line;
my @row;
my @data;
my ($id,$hostname,$ip,$login,$passwd);
my ($id_pos,$hostname_pos,$descr_pos,$ip_pos,$login_pos,$password_pos); # position of each row in conf file
my %sshdata;
my $i=0; # count line in conf file
my $index=0; # index pour @row

open (FD, "$conf") or die "Can't open conf  : $conf\n" ; # reading
while (<FD>)
{
   $i++;
   $line=$_;
   chomp($line); # delete the carriage return
   
   if ($i eq 1)
   {
      @row = split(';',$line);
      # first line => we feed vars *_pos
      foreach my $field (@row)
      {
         #print "row[$index]=$field\n";
         if ($field eq "id") { $id_pos=$index; }
         if ($field eq "hostname") { $hostname_pos=$index; }
         if ($field eq "descr") { $descr_pos=$index; }
         if ($field eq "ip") { $ip_pos=$index; }
         if ($field eq "login") { $login_pos=$index; }
         if ($field eq "password") { $password_pos=$index; }

         $index++;
      }
   }

   #($id, $hostname, $ip, $login, $passwd) = split(';', $line);
   @data = split(';',$line);

   $sshdata{$data[$id_pos]}{ip}=$data[$ip_pos];
   $sshdata{$data[$id_pos]}{login}=$data[$login_pos];
   $sshdata{$data[$id_pos]}{password}=$data[$password_pos];
   #print "[DEBUG] iphash{$id}=$ip\n";
   if (defined $filter)
   {
      # must filter 
      if ($line =~ /$filter/)
      {
         # filter match !
         print "$data[$id_pos]\t$data[$hostname_pos]\n";
      }
   }
   else
   {
      print "$data[$id_pos]\t$data[$hostname_pos]\n";
   }
}
close FD;

# Ask the ID to the user
print "Your choice:";
my $choice = <STDIN>;
chomp $choice;
if ($choice eq "") { exit; }

#print "[DEBUG]: choice=$choice sshdata{$choice}{ip}=$sshdata{$choice}{ip}\n";
exec("$sshpass -p $sshdata{$choice}{password} ssh $sshdata{$choice}{login}\@$sshdata{$choice}{ip}");
