package DNSRecord;

use Net::LDAP::Entry;

use DNSRecord::A;
use DNSRecord::NS;
use DNSRecord::MX;
use DNSRecord::SOA;
use DNSRecord::CNAME;
use DNSRecord::TXT;
use DNSRecord::SPF;
use DNSRecord::SRV;
use DNSRecord::SSHFP;
use DNSRecord::AAAA;

sub fromLDAP
{
	my $class = shift;
	my $initEntry = shift;
	my $classType = 'DNSRecord::' . $initEntry->get_value('recordType');
	return $classType->new();
}

sub initFromLDAP
{
	my $self = shift;
	my $zone = shift;
	my $initEntry = shift;
	if( $zone && $initEntry ) {
		$self->{zone} = $zone;
		foreach my $f (qw(name recordData))
		{
			$self->{$f} = $initEntry->get_value($f);	
		}
	}
}

sub fqdn
{
	my $self= shift;
	my $value = shift;
	my %options = @_;
	my $minLength = $options{minLength} || 2;
	($value) = $value =~ /^(.+)\.$/ if($value =~ /\.$/);
	my @v = split( /\./, $value );
	if( @v < $minLength )
	{
		$value .= '.' . $self->{zone}{name};
	}
	if( $options{enddot} )
	{
		$value .= '.';
	}
	
	return $value ;
}

sub setZone
{
	my $self = shift;
	$self->{zone} = shift;
}

sub value
{
	return shift()->{recordData};
}

sub key
{
	return shift()->{name};	
}

sub zoneName
{
	return shift()->{zone}{name};
}

sub type
{
	return shift()->{recordType};
}

sub toString
{
	my $self = shift;
	return join("\t",$self->fqdn( $self->key(), enddot => 1 ), $self->type(), $self->fqdn( $self->value(), enddot => 1) );
}

sub fromString
{
	my $class = shift;
	my $string = shift;
	my($name,$type,$data) = $string =~ /^([^\s]+)\s+.+IN\s+([A-Z]+)\s+(.*)$/;
	my $classType = 'DNSRecord::' . $type;
	my $self = $classType->new();
	$self->initFromString( $name, $type, $data );
	return $self;
}

sub initFromString
{
	my $self = shift;
	my $name = shift;
	my $type = shift;
	my $data = shift;
	$self->{name} = $name;
	$self->{recordType} = $type;
	$self->{recordData} = $data;
}

sub toLDAPEntry
{
	my $self = shift;
	my $baseDN = shift;
	my $entry = Net::LDAP::Entry->new();
	$entry->dn( "name=$self->{name},$baseDN" );
	return $entry->add(
		objectClass => 'DNSRecord',
		name => $self->{name},
		recordData => $self->{recordData},
		recordType => $self->{recordType}
	);
}

1;
