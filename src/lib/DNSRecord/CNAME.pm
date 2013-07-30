package DNSRecord::CNAME;

our @ISA = qw(DNSRecord);

sub new
{
	my $class = shift;
	my $initEntry = shift;
	my $zone = shift;
	my $self = {
		recordType => 'CNAME'
	};
	bless( $self, ref $class || $class );
	return $self;
}

1;
