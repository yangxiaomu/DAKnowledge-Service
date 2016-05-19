package DA::Addon::DAKnowledge::ApiForAPP;
##########################################
#        API FOR DA_KNOWLEDGE'S APP      #
##########################################
use strict;
use warnings;

#use DA::Init();

# require Exporter;

# our @ISA = qw(Exporter);

# our %EXPORT_TAGS = ( 'all' => [ qw(get_book_info) ]);
# our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
# our @EXPORT = (@{ $EXPORT_TAGS{'all'} } );
# our $VERSION = '0.01';

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

	&return_json($session,$book_info);
}

sub borrow_a_book {
	my ($session,$query) = @_;

	my $num = $query->param('num');
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
		my $sql = "UPDATE $TABLE_BORROW SET rate=?,comment=?"
				." WHERE bar_code=?";
		my $sth = $session->{dbh}->prepare($sql);
		$sth->bind_param(1,int($query->param('rate')),1);
		$sth->bind_param(2,$query->param('comment'),3);
		$sth->bind_param(3,$query->param('bar_code'),1);
		$sth->execute();
	};
	if (!DA::Session::exception($session)) {
		warn "insert book $query->{'bar_code'} failed";
	}
}

#获取我的借阅一览
#入参：mode      get_my_borrow_books
#     mid       用户id  
#
sub get_my_borrow_books {
	my ($session,$query) = @_;

	my $sql = "SELECT A.name,A.rate,A.category,B.* FROM $TABLE_BOOK A,$TABLE_BORROW B WHERE A.bar_code=B.bar_code"
			 ." AND mid = ? ORDER BY B.status";
	my $sth = $session->{dbh}->prepare($sql);
	$sth->bind_param(1,int($query->param('mid')),3);
	$sth->execute();
	my $data;
	while (my $book_data = $sth->fetchrow_hashref('NAME_lc')) {
		$data->{$book_data->{num}} = $book_data;
	}
	&return_json($session,$data);
}


#获取新上架的书籍一览
#入参：mode       get_recent_new_books
#     start_date YYYY/MM/DD
#	  limit		 获取几本
sub get_recent_new_books {
	my ($session,$query) = @_;

	my ($condition,$limit);
	# 如果有开始时间的话，获取开始时间到当前时间的数据
	if ($query->param('start_date')) {
		$condition = "WHERE get_date > ?";
	}
	if ($query->param('limit')) {
		$limit = "limit $query->param(limit)";
	}
	my $sql = "SELECT * FROM $TABLE_BOOK $condition ORDER BY get_date desc $limit";
	my $sth = $session->{dbh}->prepare($sql);
	if ($query->param('start_date')) {
		$sth->bind_param(1,$query->param('start_date'),1);
	}
	$sth->execute();
	my $data;
	while (my $book_data = $sth->fetchrow_hashref('NAME_lc')) {
		$data->{$book_data->{bar_code}} = $book_data;
	}
	&return_json($session,$data);	
}

#获取借阅次数最多的书籍一览
#入参：mode       get_popular_books
#     start_date YYYY/MM/DD	
#     limit      请求数据条数
sub get_popular_books {
	my ($session,$query) = @_;

	my ($condition,$limit);
	# 如果有开始时间的话，获取开始时间到当前时点的数据
	if ($query->param('start_date')) {
		$condition = "AND start_date > ?";
	}
	if ($query->param('limit')) {
		$limit = "limit $query->{limit}";
	}
	my $sql = "SELECT * FROM $TABLE_BOOK A, $TABLE_BORROW B WHERE "
			 ."A.bar_code = B.bar_code $condition ORDER BY A.borrow_times desc $limit";
	my $sth = $session->{dbh}->prepare($sql);
	if ($query->('start_date')) {
		$sth->bind_param(1,$query->param('start_date'),1);
	}
	$sth->execute();
	my $data;
	while (my $book_data = $sth->fetchrow_hashref('NAME_lc')) {
		$data->{$book_data->{bar_code}} = $book_data;
	}
	&return_json($session,$data);
}

#
# 图片位置 /home/Dreamarts/data/master/MID/DAK/avater.jpg
#                                            background.jpg
# 书籍图片保存路径 /home/Dreamarts/data/DAK/BOOK_NUM/thumb.jpg 
# 												  original.jpg
#

sub get_user_info {
	my ($session,$query) = @_;

	my $sql = "SELECT * FROM $TABLE_USER WHERE mid = ?";
	my $sth = $session->{dbh}->prepare($sql);
	$sth->bind_param(1,int($query->param('mid')),3);
	$sth->execute();
	my $user_data = $sth->fetchrow_hashref('NAME_lc');
	$sth->finish;

	&return_json($user_data);
}

sub return_json{
	my ($session,$data)=@_;

	my $json = JSON::objToJson($data);
warn Data::Dumper->Dump([$json]);
	$json=DA::Charset::convert(\$json,DA::Unicode::internal_charset(),'UTF-8');
	print "Content-length: " . length($json) . "\n";
	print "Content-type: application/json\n\n";
	print $json;
	Apache::exit();
}

1;
