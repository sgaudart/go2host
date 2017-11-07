#!/usr/bin/perl
#======================================================================
# Auteur : sgaudart@capensis.fr
# Date   : 29/08/2017
#======================================================================
#use strict;
#use warnings;

my $conf="hosts.conf";
my $filter = shift(@ARGV);
my $sshpass="/usr/bin/sshpass"; # path to the command sshpass
my ($line,$display,$rowname);
my %conf; # store each line of the conf file
my @dataline; # store only the current line (format array)
my %pos; # $pos{field} => return the index of the row field in the conf file
my $i=0; # count line in conf file
my $index=0; # index pour @row

START:
open (FD, "$conf") or die "Can't open conf : $conf\n" ; # reading
while (<FD>)
{
   $i++;
   $line=$_;
   chomp($line); # delete the carriage return
   @dataline = split(';',$line); # split current line
   
   if ($i eq 1)
   {
      foreach $rowname (@dataline)
      {
         #print "pos{$field}=$index\n";
         $pos{$rowname}=$index;
         $index++;
      }
   }
  
   foreach $rowname (keys %pos)
   {
      $conf{$dataline[$pos{id}]}{$rowname}=$dataline[$pos{$rowname}];
   }
   
   if (defined $pos{descr}) # we have description in the conf file
   {
      $display="printf(\"%-8s %-15s %-10s \n\", $dataline[$pos{id}], \"$dataline[$pos{hostname}]\", \"$dataline[$pos{descr}]\");";
   }
   else
   {
      $display="printf(\"%-8s %-15s \n\",$dataline[$pos{id}],\"$dataline[$pos{hostname}]\");";
   }
 
   
   if (defined $filter)
   {
      # filter case
      if ($line =~ /$filter/)
      {
         # filter match !
         eval $display;
      }
   }
   else
   {
      eval $display;
   }

}
close FD;

# Ask the ID to the user
print "Type id (or filter) : ";
my $id = <STDIN>;
chomp $id;
if ($id eq "") { exit; }
if (! defined $conf{$id}{ip}) { $filter=$id; goto START; }


# SSH CONNECTION
if ((defined $pos{login}) && (defined $pos{password}))
{
   # connection with login/password
   #print "[DEBUG]: id=$id => $sshpass -p $conf{$id}{password} ssh $conf{$id}{login}\@$conf{$id}{ip}\n";
   exec("$sshpass -p $conf{$id}{password} ssh $conf{$id}{login}\@$conf{$id}{ip}");
}
else
{
   # connection simple
   #print "[DEBUG]: id=$id => ssh $conf{$id}{ip}\n";
   exec("ssh $conf{$id}{ip}");
}
