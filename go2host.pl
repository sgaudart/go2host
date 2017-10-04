#!/usr/bin/perl
#======================================================================
# Auteur : sgaudart@capensis.fr
# Date   : 29/08/2017
#======================================================================
use strict;
use warnings;

my $conf="myhosts.conf";
my $filter = shift(@ARGV);
my $sshpass="/home/sgaudart/sshpass"; # path to the command sshpass
my $line;
my ($id,$hostname,$ip,$passwd);
my %iphash;

open (FD, "$conf") or die "Can't open conf  : $conf\n" ; # reading
while (<FD>)
{
	$line=$_;
	chomp($line); # delete the carriage return
	($id, $hostname, $ip, $passwd) = split(';', $line);
	$iphash{$id}=$ip;
	#print "[DEBUG] iphash{$id}=$ip\n";
	if (defined $filter)
	{
	   # must filter
		 if ($line =~ /$filter/)
		 {
			 # filter match !
			 print "$id\t$hostname\n";
		 }
	}
	else
	{
     print "$id\t$hostname\n";
	}
}
close FD;

# Ask the ID to the user
print "Your choice:";
my $choice = <STDIN>;
chomp $choice;
if ($choice eq "") { exit; }

#print "[DEBUG]: ip=$iphash{$choice}\n";
exec("$sshpass -p $passwd ssh root\@$iphash{$choice}");
