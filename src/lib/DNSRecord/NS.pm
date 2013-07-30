package DNSRecord::NS;
use DNSRecord::zoneNameHolder;
use DNSRecord::recordDataValueHolder;

our @ISA = qw(DNSRecord DNSRecord::recordDataValueHolder);

sub new
{
	my $class = shift;
	my $nameServer = shift;
	my $self = {
		recordType => 'NS'
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub key
{
	return shift()->{zone}{name};
}

1;
