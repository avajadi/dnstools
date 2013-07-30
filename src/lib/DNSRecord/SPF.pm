package DNSRecord::SPF;
use DNSRecord::zoneNameHolder;
use DNSRecord::recordDataValueHolder;

our @ISA=qw(DNSRecord DNSRecord::zoneNameHolder);

sub new
{
	my $class = shift;
	my $self = {
		recordType => 'SPF',
		zone => shift()
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub toString
{
	my $self = shift;
	my @r = ();
	foreach my $mxR ( @{$self->{zone}{mailServers}} )
	{
		push( @r, "a:" . $mxR );
	}
	return "$self->{zone}{name}.\t$self->{recordType}\t\"v=spf1 " . join( ' ', @r) . " -all\""; 
}

# No separate record is kept for SPF data in the LDAP directory
sub toLDIF
{
	return '';
}

1;
