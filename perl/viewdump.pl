#!/usr/bin/perl
# procdump.pl 	Jeff Ratliff	09/16/2013
#
# Like my procdump script but for views. Views are in information_schema.VIEWS

use strict;
use DBI;    			# for the database stuff

my $host = shift || die "first parameter must be a database URI";
my $user =  '<username>';
my $pass =  '<password>';
my $DB = 'information_schema';
my $schema = '<schema name>'; 	# You can ignore this and take the where clause
				# out to get all views
my $sqlstatement;
my $dbh; # database handle
my $sth; # statement handle
my (@row);


&db_open($DB);

$sqlstatement="select TABLE_NAME, VIEW_DEFINITION from VIEWS where TABLE_SCHEMA = \'$schema\'";
# Handle command line parameter
if ($ARGV[0]) {
	$sqlstatement .= " and TABLE_NAME = \'$ARGV[0]\'";
}

&db_query($sqlstatement);

# print views
while (@row = $sth->fetchrow_array) {
	print "CREATE OR REPLACE VIEW `", $row[0], "` AS\n";
	print $row[1], ";\n\n";
}
$sth->finish;

&db_close;



###################
##  Subroutines  ##
###################

sub db_open ($db_name) {
# Open connection to the database. This relies on global variables,
# which is a bad idea. I should remember how to pass by refernce in Perl and
# fix this.
	my $db_name = @_[0];

	#$dbh=DBI->connect('dbi:mysql:<database>;<host.domain>','user','password');
	$dbh = DBI->connect("dbi:mysql:$db_name;$host","$user","$pass");
}

sub db_query($query) {
	my $query = @_[0];
	# prepare SQL statement
	$sth = $dbh->prepare($query);

	# execute statement
	$sth->execute || die "Could not execute SQL statement: $!";
}

sub db_close() {
	$dbh->disconnect;
}
