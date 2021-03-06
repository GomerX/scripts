#!/usr/bin/perl
# procdump.pl 	Jeff Ratliff	09/09/2013
#
# Script should dump all procedures for a specific database. The mysqldump
# utility does not seem to have the ability to dump just procedures and
# functions by themselves. The purpose is to compare databases on 2 different
# servers and see what the differences are. A side effect is we can easily take
# these dumps and convert them to a form that can be imported into another
# database.
#
# The data we are after is not in the specified database, it's in the
# mysql.proc table. We need the 'name', 'param_list' and 'body' fields to build
# a complete script that can be run against MySQL.
#
# Can be executed on it's own, or procdump.pl <procedure name> will dump a
# specific proc.
#
# Works OK on MySQL 5.0 and 5.1. That's all I've tested.

use strict;
use DBI;    			# for the database stuff

# Fill in the stuff in <> with real values
my $schema = 	'<database_name>';	# this is the database whose procedures you want to dump
my $DB =    	'mysql';		# doesn't change because all procs are in the mysql db
my $sqlstatement;
my $dbh; # database handle
my $sth; # statement handle
my (@row);



$dbh = &db_open($DB);

$sqlstatement="select name, type, param_list, returns, body, comment, is_deterministic from proc where db = \'$schema\'";
# Handle command line parameter
if ($ARGV[0]) {
	$sqlstatement .= " and name = \'$ARGV[0]\'";
}

$sth = &db_query($sqlstatement, $dbh);

# header
print "DELIMITER ;;\n\n";

# print procs and functions
while (@row = $sth->fetchrow_array) {
	print "DROP ", $row[1], " IF EXISTS `", $row[0], "`;;\n";
	print "CREATE ", $row[1], " `", $row[0], "`(";
	print $row[2], ")";
	if ($row[5]) {
		print " COMMENT '", $row[5], "'";
	}
	if ($row[3]) {
		print " RETURNS ", $row[3];
	}
	if ($row[6] eq 'YES') {
		print " DETERMINISTIC ";
	}
	print  "\n";
	print $row[4], ";;\n\n";
}
$sth->finish;

&db_close($dbh);



###################
##  Subroutines  ##
###################

sub db_open ($) {
# Open connection to the database.
	my $db_name = @_[0];
	my $handle;
	# Fill in the stuff in <> with real values
	my $host = 	'<hostname>';
	my $user = 	'<username>';
	my $pass = 	'<password>';

	#$dbh=DBI->connect('dbi:mysql:<database>;<host.domain>','user','password');
	$handle = DBI->connect("dbi:mysql:$db_name;$host","$user","$pass");
	return $handle
}

sub db_query($$) {
	my $query = @_[0];
	my $handle = @_[1];
	# prepare SQL statement
	my $statement = $handle->prepare($query);

	# execute statement
	$statement->execute || die "Could not execute SQL statement: $!";
	return $statement;
}

sub db_close($) {
	my $handle = @_[0];
	$handle->disconnect;
}
