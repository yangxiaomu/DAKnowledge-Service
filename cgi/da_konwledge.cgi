#!/usr/local/bin/perl
##########################################
#        API FOR DA_KNOWLEDGE            #
##########################################

BEGIN {
	use DA::Init();
	use DA::Gettext;
}

use strict;
my $r = shift;
&main($r);
Apache::exit();

sub main {
	my ($r) = @_;

	my $session={};
	DA::Session::get_dir($session,$r);
	my $query=Apache::Request->new($r,TEMP_DIR=>"$session->{temp_dir}");


	#Ajax request
	if ($query->param('mode') eq 'get_user_info') {
		DA::Addon::DaKnowledge::Api::get_user_info($session,$query);
	} elsif ($query->param('mode') eq 'get_book_info') {
		DA::Addon::DaKnowledge::Api::get_book_info($session,$query);
	} elsif ($query->param('mode') eq 'get_books_info') {
		DA::Addon::DaKnowledge::Api::get_books_info($session,$query);
	} elsif ($query->param('mode') eq 'get_recently_borrow_list') {
		#timeline
		DA::Addon::DaKnowledge::Api::get_recently_borrow_list($session,$query);	
	} elsif ($query->param('mode') eq 'update_user_info') {
		DA::Addon::DaKnowledge::Api::update_user_info($session,$query);	
	} elsif ($query->param('mode') eq 'borrow_book') {
		DA::Addon::DaKnowledge::Api::borrow_book($session,$query);
	} elsif ($query->param('mode') eq 'rate_book') {
		DA::Addon::DaKnowledge::Api::rate_book($session,$query);
	} elsif ($query->param('mode') eq 'delay_return_book') {
		DA::Addon::DaKnowledge::Api::delay_return_book($session,$query);
	}

	$session->{dbh}->disconnect;
	Apache::exit();

}

1;