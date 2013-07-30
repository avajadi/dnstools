package DNSRecord::MX;
use DNSRecord::recordDataValueHolder;
our @ISA = qw(DNSRecord DNSRecord::recordDataValueHolder);
our $NEXT_PRIORITY = 0;
sub new
{
	my $class = shift;
	my $zone = shift;
	my $initEntry = shift;
	my $self = {
		recordType => 'MX',
		priority => ( $NEXT_PRIORITY += 5 )
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub initFromString
{
	my $self = shift;
	my $name = shift;
	my $type = shift;
	my $data = shift;
	my @fields = split( /\s+/, $data );
	@{$self}{qw(priority recordData)} = @fields;
}



sub value
{
	return shift()->{recordData};
}

sub key
{
	return shift()->zoneName();
}

sub toString
{
	my $self = shift;
	return join("\t",$self->fqdn( $self->key(), enddot => 1 ), $self->type(), $self->{priority}, $self->fqdn( $self->value(), enddot => 1) );
}
# No separate LDAP entries for MX records, they are attributes on the DNSZone record
sub toLDIF
{
	return '';
}

1;
