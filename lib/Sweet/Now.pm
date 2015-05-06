
__END__

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $yyyy = $year+1900;
$mon++;
my $mm = sprintf "%02d",$mon;
my $dd = sprintf "%02d",$mday;
my $hh = sprintf "%02d",$hour;
my $mi = sprintf "%02d",$min;
my $ss = sprintf "%02d",$sec;

say "$yyyy$mm$dd$hh$mi$ss";


