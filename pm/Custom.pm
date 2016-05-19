package DA::Custom;
###################################################
##  INSUITE(R)Enterprise Version 1.2.0.          ##
##  Copyright(C)2001,2002 DreamArts Corporation. ##
##  All rights to INSUITE routines reserved.     ##
###################################################
use strict;
use vars '$AUTOLOAD';

# !!!!!!!!!!!!!!!!!!!!!!!! Warnings !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# DO NOT REMOVE SUBROUTINE AUTOLOAD AND DESTROY
#
# !!!!!!!!!!!!!!!!!!!!!!!! Warnings !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
sub AUTOLOAD {
    no strict "refs";
	*{$AUTOLOAD} = sub { return; };
	return;
}

sub DESTROY { }

# This line will be used for INSUITE Enterprise upgrade process.
# END OF CUSTOM (update:none) DONT'T REMOVE THIS LINE!
# DO NOT WRITE YOUR ORIGINAL METHOD UPPER LINE! 

# PRELOADED METHODS GO HERE.
use DA::Addon::DAKnowledge::ApiForAPP;
sub get_book_info {
	DA::Addon::DAKnowledge::ApiForAPP::get_book_info(@_);
}

sub get_user_info {
	DA::Addon::DAKnowledge::ApiForAPP::get_user_info(@_);
}

sub borrow_a_book {
	DA::Addon::DAKnowledge::ApiForAPP::borrow_a_book(@_);
}

sub app_insert_book {
	DA::Addon::DAKnowledge::ApiForAPP::app_insert_book(@_);
}

sub app_rate_book {
	DA::Addon::DAKnowledge::ApiForAPP::app_rate_book(@_);
}

sub get_my_borrow_books {
	DA::Addon::DAKnowledge::ApiForAPP::get_my_borrow_books(@_);
}

sub get_recent_new_books {
	DA::Addon::DAKnowledge::ApiForAPP::get_recent_new_books(@_);
}

sub get_popular_books {
	DA::Addon::DAKnowledge::ApiForAPP::get_popular_books(@_);
}


1;
