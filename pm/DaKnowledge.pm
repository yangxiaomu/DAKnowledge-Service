package DA::Addon::DAKnowledge::Api.pm

use strict;
use DA::Init();

our $TABLE_BOOK = "ADDON_DAK_BOOK";
our $TABLE_USER = "ADDON_DAK_USER";
our $TABLE_CATEGORY = "ADDON_BOOK_CATEGORY";
our $TABLE_BORROW = "ADDON_DAK_BOOK_BORROW";
our $TABLE_MAP = "ADDON_DAK_BOOKMAP";
our $TABLE_NOTICE = "ADDON_DAK_NOTICE";



sub get_book_info {
	my ($session,$query) = @_;

	my $bar_code = $query->param('bar_code');
	my $sql = "SELECT * FROM $TABLE_BOOK WHERE bar_code = ?";
	my $sth = $session->{dbh}->prepare($sql);
	$sql->bind_param(1,$bar_code,3);
	$sth->execute();
	my $book_info = $sth->fetchrow_hashref('NAME_lc');
	$sth->finish();

	&return_json($session,JSON::objToJson($book_info));
}


sub return_json{
	my ($session,$json)=@_;

	$tag=DA::Charset::convert(\$tag,DA::Unicode::internal_charset(),'UTF-8');
	print "Content-length: " . length($json) . "\n";
	print "Content-type: application/json\n\n";
	print $json;
	Apache::exit();
}