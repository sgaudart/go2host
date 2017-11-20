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
my ($line,$i,$index,$display,$rowname);
my %conf; # store each line of the conf file
my @dataline; # store only the current line (format array)
my %pos; # $pos{field} => return the index of the row field in the conf file
my $id="id";

START:
$i=0; # init line index
open (FD, "$conf") or die "Can't open conf : $conf\n" ; # reading
while (<FD>)
{
   $i++;
   $line=$_;
   chomp($line); # delete the carriage return
   @dataline = split(';',$line); # split current line
   
   if ($i eq 1)
   {
      $index=0; # init
      foreach $rowname (@dataline)
      {
         #print "pos{$field}=$index\n";
         $pos{$rowname}=$index;
         $index++;
      }
   }
 
   if (defined $pos{id}) { $id=$dataline[$pos{id}]; }

   # PREPATE %conf
   foreach $rowname (keys %pos)
   {
      $conf{$id}{$rowname}=$dataline[$pos{$rowname}];
   }

   # PREPARE $display
   if (defined $pos{descr}) # we have description in the conf file
   {
      $display="printf(\"%-8s %-15s %-10s \n\", $id, \"$dataline[$pos{hostname}]\", \"$dataline[$pos{descr}]\");";
   }
   else
   {
      $display="printf(\"%-8s %-15s \n\",$id,\"$dataline[$pos{hostname}]\");";
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

   if ($i eq 1) { $id=0; } # init var $id
   $id++;

}
close FD;

# Ask the ID to the user
print "Type id (or filter) : ";
my $choice = <STDIN>;
chomp $choice;
if ($choice eq "") { exit; } # no choice => exit
if (! defined $conf{$choice}{hostname}) { $filter=$choice; goto START; } # not id => filter
if (! defined $conf{$choice}{ip}) { $conf{$choice}{ip} = $conf{$choice}{hostname}; } # no known ip => use hostname for ssh


# SSH CONNECTION
if ((defined $pos{login}) && (defined $pos{password}))
{
   # connection with login/password
   #print "[DEBUG]: id=$choice => $sshpass -p $conf{$choice}{password} ssh $conf{$choice}{login}\@$conf{$choice}{ip}\n";
   exec("$sshpass -p $conf{$choice}{password} ssh $conf{$choice}{login}\@$conf{$choice}{ip}");
}
else
{
   # connection simple
   #print "[DEBUG]: id=$choice => ssh $conf{$choice}{ip}\n";
   exec("ssh $conf{$choice}{ip}");
}
