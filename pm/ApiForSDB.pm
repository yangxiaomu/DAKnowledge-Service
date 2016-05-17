package DA::Addon::DAKnowledge::ApiForSDB.pm
##########################################
#        API FOR DA_KNOWLEDGE'S SDB      #
##########################################

use strict;
use DA::Init();

our $TABLE_BOOK = "ADDON_DAK_BOOK";
our $TABLE_USER = "ADDON_DAK_USER";
our $TABLE_CATEGORY = "ADDON_BOOK_CATEGORY";
our $TABLE_BORROW = "ADDON_DAK_BOOK_BORROW";
our $TABLE_MAP = "ADDON_DAK_BOOKMAP";
our $TABLE_NOTICE = "ADDON_DAK_NOTICE";

#新追加一本书
#入参：mode      sdb_insert_book
#     bar_code  条形码数值
#
sub sdb_insert_book {
	my ($session,$query) = @_;

	DA::Session::trans_int($session);
	eval {
		#确认是否已经有相同书籍，有：flag=1
		my $before_insert_sql = "SELECT 1 FROM $TABLE_MAP WHERE bar_code = ?";
		my $before_insert_sth = $session->prepare($before_insert_sql);
		$before_insert_sth->bind_param(1,$query->{'bar_code'},3);
		$before_insert_sth->execute();
		my $flag = $before_insert_sth->fetchrow_hashref('NAME_lc');
		$before_insert_sth->finish;

		#更新map表
		my $sql = "INSET INTO $TABLE_MAP (num,bar_code) VALUES (?,?)";
		my $sth = $session->{dbh}->prepare($sql);
		$sth->bind_param(1,int($query->{'num'}),3);
		$sth->bind_param(2,int($query->{'bar_code'}),3);
		$sth->execute();

		#有相同数据不更新book表
		if (!$flag) {
			my $sql = "INSET INTO $TABLE_BOOK (bar_code,name,abstract,owner,get_date,comment,category)"
					." VALUES (?,?,?,?,?,?,?)";
			my $sth = $session->{dbh}->prepare($sql);
			$sth->bind_param(1,int($query->{'bar_code'}),3);
			$sth->bind_param(2,$query->{'name'},1);
			$sth->bind_param(3,$query->{'abstract'},1);
			$sth->bind_param(4,$query->{'owner'},3);
			$sth->bind_param(5,$query->{'get_date'},1);
			$sth->bind_param(6,$query->{'comment'},1);
			$sth->bind_param(7,$query->{'category'},1);
			$sth->execute();
		}
	};
	if (!DA::Session::exception($session)) {
		warn "insert book $query->{'bar_code'} failed";
	}
}

#删除一本书
#入参：mode      sdb_delete_book
#	  num		内部编码
#     bar_code  条形码数值
#
sub sdb_delete_book {
	my ($session,$query) = @_;

	DA::Session::trans_int($session);
	eval {
		my $sql = "DELETE FROM $TABLE_BOOK WHERE bar_code = ?";
		my $sth = $session->{dbh}->prepare($sql);
		$sth->bind_param(1,int($query->{'bar_code'}),1);
		$sth->execute();	
	};
	if (!DA::Session::exception($session)) {
		warn "delte book $query->{'bar_code'} failed";
	}
}

#更新一本书的信息
#入参：mode      sdb_update_book
#	  num		内部编码
#     bar_code  条形码数值
# **need logic**
sub sdb_update_book {
	my ($session,$query) = @_;

	DA::Session::trans_int($session);
	eval {
		my $sql = "INSET INTO $TABLE_BOOK (bar_code,name,abstract,owner,get_date,comment,category)"
				." VALUES (?,?,?,?,?,?,?)";
		my $sth = $session->{dbh}->prepare($sql);
		$sth->bind_param(1,int($query->{'bar_code'}),3);
		$sth->bind_param(2,$query->{'name'},1);
		$sth->bind_param(3,$query->{'abstract'},1);
		$sth->bind_param(4,$query->{'owner'},3);
		$sth->bind_param(5,$query->{'get_date'},1);
		$sth->bind_param(6,$query->{'comment'},1);
		$sth->bind_param(7,$query->{'category'},1);
		$sth->execute();	
	};
	if (!DA::Session::exception($session)) {
		warn "insert book $query->{'bar_code'} failed";
	}
}

1;