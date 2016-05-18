#!/usr/local/bin/perl
##########################################
#        API FOR DA_KNOWLEDGE'S SDB      #
##########################################

BEGIN {
	use DA::Init();
	use DA::Gettext;
}

use strict;
use warnings;

my $r = shift;
&main($r);
Apache::exit();

sub main {
	my ($r) = @_;

	my $session={};
	DA::Session::get_dir($session,$r);
	my $query=Apache::Request->new($r,TEMP_DIR=>"$session->{temp_dir}");

	#Ajax request
	if ($query->param('mode') eq 'sdb_insert_book') {
		DA::Addon::DAKnowledge::ApiForSDB::sdb_insert_book($session,$query);
	} elsif ($query->param('mode') eq 'sdb_delete_book') {
		DA::Addon::DAKnowledge::ApiForSDB::sdb_delete_book($session,$query);		DA::Custom::get_book_info($session,$query);
	} elsif ($query->param('mode') eq 'sdb_update_book') {
		DA::Addon::DAKnowledge::ApiForSDB::sdb_update_book($session,$query);
	}

	$session->{dbh}->disconnect;
	Apache::exit();

}

1;
