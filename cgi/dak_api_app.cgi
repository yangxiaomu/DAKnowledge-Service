#!/usr/local/bin/perl
##########################################
#        ApiForAPP FOR DA_KNOWLEDGE'S APP      #
##########################################

BEGIN {
	use DA::Init();
	use DA::Gettext;
	use DA::Addon::DAKnowledge::ApiForAPP;
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
	
	if (!$query->param('mode')) {
		warn "Error:there is no mode in query";
		Apache::exit();
	}
warn "1";

	#Ajax request
	if ($query->param('mode') eq 'get_user_info') {
		DA::Addon::DAKnowledge::ApiForAPP::get_user_info($session,$query);
	} elsif ($query->param('mode') eq 'get_book_info') {
warn "2";
		#DA::Addon::DAKnowledge::ApiForAPP::get_book_info($session,$query);
		DA::Custom::get_book_info($session,$query);
	} elsif ($query->param('mode') eq 'get_books_info') {
		DA::Addon::DAKnowledge::ApiForAPP::get_books_info($session,$query);
	} elsif ($query->param('mode') eq 'get_recently_borrow_list') {
		#timeline
		DA::Addon::DAKnowledge::ApiForAPP::get_recently_borrow_list($session,$query);	
	} elsif ($query->param('mode') eq 'update_user_info') {
		DA::Addon::DAKnowledge::ApiForAPP::update_user_info($session,$query);	
	} elsif ($query->param('mode') eq 'borrow_book') {
		DA::Addon::DAKnowledge::ApiForAPP::borrow_book($session,$query);
	} elsif ($query->param('mode') eq 'rate_book') {
		DA::Addon::DAKnowledge::ApiForAPP::rate_book($session,$query);
	} elsif ($query->param('mode') eq 'delay_return_book') {
		DA::Addon::DAKnowledge::ApiForAPP::delay_return_book($session,$query);
	} else {
		warn "Error:mode is illegal\n";
	}

	$session->{dbh}->disconnect;
	Apache::exit();

}

1;
