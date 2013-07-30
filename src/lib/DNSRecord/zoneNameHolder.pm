package DNSRecord::zoneNameHolder;

sub setZone
{
	my $self = shift;
	$self->{zone} = shift;
	$self->{name} = $self->{zone}{name};
}

1;
