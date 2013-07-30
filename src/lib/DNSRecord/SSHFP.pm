package DNSRecord::SSHFP;

our @ISA = qw(DNSRecord);
sub new
{
	my $class = shift;
	my $self = {
		recordType => 'SSHFP'
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub toString
{
	my $self = shift;
	return join("\t",$self->fqdn( $self->key(), enddot => 1 ), $self->type(), $self->value() );
}


1;
