#!/usr/local/bin/perl
##############################
#    upgrade script for dak  #
##############################
use strict;

sub main {
	print "start..\n";
	&cmd("cp cgi/*.cgi /home/DreamArts/cgi-bin/custom/DAKnowledge/");
	&cmd("chmod 750 *.cgi");
	&cmd("chown iseadmin:iseadmin *.cgi");
	&cmd("cp pm/*.pm /home/DreamArts/LIB/Addon/DAKnowledge/");
	&cmd("chomd 750 *.pm");
	&cmd("chown root:root *.pm");
	print "finish..\n";
}

sub cmd {
	my ($str) = @_;

	system("$str");
}

1;