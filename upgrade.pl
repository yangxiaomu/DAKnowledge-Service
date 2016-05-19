#!/usr/local/bin/perl
##############################
#    upgrade script for dak  #
##############################
use strict;

&main();

sub main {
	print "start..\n";
	&cmd("cp cgi/*.cgi /home/DreamArts/cgi-bin/custom/DAKnowledge/");
	&cmd("chmod 750 /home/DreamArts/cgi-bin/custom/DAKnowledge/*.cgi");
	&cmd("chown iseadmin:iseadmin /home/DreamArts/cgi-bin/custom/DAKnowledge/*.cgi");
	&cmd("cp pm/Api*.pm /home/DreamArts/LIB/Addon/DAKnowledge/");
	&cmd("chmod 750 /home/DreamArts/LIB/Addon/DAKnowledge/*.pm");
	&cmd("chown root:root /home/DreamArts/LIB/Addon/DAKnowledge/*.pm");

	#Custom.pm
	&cmd("cp pm/Custom.pm /home/DreamArts/LIB/");
	&cmd("chmod 644 /home/DreamArts/LIB/Custom.pm");
	&cmd("chown root:root /home/DreamArts/LIB/Custom.pm");
	print "finish..\n";
}

sub cmd {
	my ($str) = @_;

	system("$str");
}

1;
