#!/usr/bin/perl

use strict;
use Net::Twitter::Diff;
use Getopt::Long qw(GetOptions);
use Pod::Usage;
use Term::Prompt;

my $username;
my $password;
my $help = 0;
my $sync = 0;

my $result = GetOptions('help' => \$help, 'username=s' => \$username, 'password=s' => \$password, 'sync' => \$sync);

pod2usage(-exitval => 0, -verbose => 2) if($help);
pod2usage(-exitval => 1, -verbose => 1) unless $username && $password; 


print "Retrieving those you follow, and those that follow you for user $username \n";
my $twit = Net::Twitter::Diff->new(  username => $username, password => $password);
my $res = $twit->diff();


foreach my $person (@{ $res->{not_following} }) {
	my $value = prompt('a', "Add $person y/n", '', 'n') unless $sync;
	if ($sync or $value eq 'y') {
 		print "Adding $person\n";
		$twit->follow($person);
	);
}

foreach my $person (@{ $res->{not_followed }}) {
	my $value = prompt('a', "Remove $person y/n", '', 'n') unless $sync;
	if ($sync or $value eq 'y') {
 		print "Removing $person\n";
		$twit->stop_following($person);
	}
}

__END__

=head1 NAME

following.pl - review your followers and followed on Twitter 

=head1 SYNOPSIS

  following.pl --username=<username> --password=<password>

=head1 OPTIONS

  -? --help Verbose help 

=head1 DESCRIPTION

Review who is following you, and choose to reciprocate, and who is not following you and choose to stop following them.

=head1 EXAMPLES

  ./following.pl --username=DreadPirateRoberta --password=asyouwish

=head1 CREDIT

use Net::Twitter::Diff from cpan.org

=cut
