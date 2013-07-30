package DNSRecord::SOA;
use DNSRecord::zoneNameHolder;
use DNSRecord::recordDataValueHolder;

our @ISA = qw(DNSRecord);

sub new
{
	my $class = shift;
	my $zone = shift;
	my $self = {
		recordType => 'SOA'
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub toString
{
	my $self = shift;
	#skagelund.se.		4838400	IN	SOA	ns.avajadi.org. hostmaster.avajadi.org. 2012071601 7200 7200 1814400 86400
	my $aea = $self->{zone}{administratorEmailAddress};
	$aea =~ s/\@/\./;
	my $soa = "$self->{zone}{name}.\tSOA $self->{zone}{authorativeNameServer} $aea ";
	$soa .= join( ' ',@{$self->{zone}}{qw(serial retry refresh expire minimum)} );
	return $soa;
}

sub initFromString
{
	my $self = shift;
	my $name = shift;
	my $type = shift;
	my $data = shift;
	$self->{name} = $name;
	my @fields = split( /\s+/, $data );
	@{$self}{qw(authorativeNameServer administratorEmailAddress serial retry refresh expire minimum)} = @fields[0..9];
}

1;
