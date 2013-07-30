package DNSRecord::recordDataValueHolder;
sub setValue
{
	my $self = shift;
	$self->{recordData} = shift;
}
1;
