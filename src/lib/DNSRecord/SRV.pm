package DNSRecord::SRV;

our @ISA = qw(DNSRecord);
sub new
{
	my $class = shift;
	my $self = {
		recordType => 'SRV'
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub toString
{
	my $self = shift;
	return join("\t",$self->fqdn( $self->key(), enddot => 1, minLength => 3 ), $self->type(), $self->value() );
}


1;
