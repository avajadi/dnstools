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
	my $string = '';
	foreach my $value ( @{$self->value()} ) {
		$string .= join("\t",$self->fqdn( $self->key(), enddot => 1 ), $self->type(), $value ) . "\n";
	}
	return $string;
}

sub multiValue
{
	return 1;
}
1;
