package DA::Addon::DAKnowledge::ApiForAPP;
##########################################
#        API FOR DA_KNOWLEDGE'S APP      #
##########################################
use strict;
use warnings;

use DA::Init();

our $TABLE_BOOK = "ADDON_DAK_BOOK";
our $TABLE_USER = "ADDON_DAK_USER";
our $TABLE_CATEGORY = "ADDON_BOOK_CATEGORY";
our $TABLE_BORROW = "ADDON_DAK_BOOK_BORROW";
our $TABLE_MAP = "ADDON_DAK_BOOKMAP";
our $TABLE_NOTICE = "ADDON_DAK_NOTICE";

#获取一本书的信息json
#入参：mode      get_book_info
#     bar_code  条形码数值
#
sub get_book_info {
	my ($session,$query) = @_;

	my $bar_code = $query->param('bar_code');
	my $sql = "SELECT * FROM $TABLE_BOOK WHERE bar_code = ?";
	my $sth = $session->{dbh}->prepare($sql);
	$sth->bind_param(1,$bar_code,3);
	$sth->execute();
	my $book_info = $sth->fetchrow_hashref('NAME_lc');
	$sth->finish();

	&return_json($session,JSON::objToJson($book_info));
}

#新增一本书 献书
#入参：mode      insert_book
#     bar_code  条形码数值
#
sub app_insert_book {
	my ($session,$query) = @_;

	DA::Addon::ApiForSDB::sdb_insert_book($session,$query);
}

#对书籍进行评分，以及发布读后感
#入参：mode      update_book
#     bar_code  
#
sub app_rate_book {
	my ($session,$query) = @_;

	DA::Session::trans_int($session);
	eval {
		my $sql = "UPDATE $TABLE_BORROW SET comment=?,category=?,rate=?,borrow_times=?"
				." WHERE bar_code=?";
		my $sth = $session->{dbh}->prepare($sql);
		$sth->bind_param(1,int($query->{'bar_code'}),3);
		$sth->bind_param(2,$query->{'name'},1);
		$sth->bind_param(3,$query->{'abstract'},1);
		$sth->bind_param(4,$query->{'owner'},3);
		$sth->bind_param(5,$query->{'get_date'},1);
		$sth->bind_param(6,$query->{'comment'},1);
		$sth->bind_param(7,$query->{'category'},1
		$sth->execute();	
	};
	if (!DA::Session::exception($session)) {
		warn "insert book $query->{'bar_code'} failed";
	}
}

sub get_my_borrow_books {
	my ($session,$query) = @_;

	my $sql = "SELECT A.name,A.rate,A.category,B.* FROM $TABLE_BOOK A,$TABLE_BORROW B WHERE A.bar_code=B.bar_code"
			 ." AND mid = ?";
	my $sth = $session->{dbh}->prepare($sql);
	$sth->bind_param(1,int($query->{'mid'}),3);
	$sth->execute();
	my $data;
	while (my $book_data = $sth->fetchrow_hashref('NAME_lc')) {
		$data->{$book_data->{num}} = $book_data;
	}
	&return_json($session,JSON::objToJson($data));
}


sub return_json{
	my ($session,$json)=@_;

warn Data::Dumper->Dump([$json]);
	$json=DA::Charset::convert(\$json,DA::Unicode::internal_charset(),'UTF-8');
	print "Content-length: " . length($json) . "\n";
	print "Content-type: application/json\n\n";
	print $json;
	Apache::exit();
}

1;