package DNSZone;

use strict;
use warnings;

#use Net::IDN::Encode ':all';
use Net::LDAP::Entry;

use DNSRecord;
use DNSRecord::SPF;
use DNSRecord::NS;
use DNSRecord::SOA;

sub new
{
	my $class = shift;
	my $self = {
		records => []
	};
	bless( $self, ref $class || $class );
	return $self;
}

sub initFromLDAP
{
	my $self = shift;
	$self->{name} = shift;
	my $initEntry = shift;
	my @entries = @_;
	foreach my $f (qw(administratorEmailAddress authorativeNameServer serial))
	{
		$self->{$f} = $initEntry->get_value($f);
	}
	my $defaults = {};
	@{$defaults}{qw(retry refresh expire minimum)} = qw(7200 7200 1814400 86400);

	while ( my ($k,$v) = each( %{$defaults} ) )
	{
		$self->{$k} = $initEntry->get_value($k) || $v;
	}
	
	# SOA
	$self->addRecords( DNSRecord::SOA->new() );

	# Name servers
	my $nameServers = $initEntry->get_value('nameServer',asref => 1 )||[];
	$self->{nameServers} = $nameServers;
	foreach my $ns ( @{$nameServers} ) 
	{
		my $nameServer = DNSRecord::NS->new();
		$nameServer->setValue( $ns );
		$self->addRecords( $nameServer );
	}

	# Authorative Name Server last, for load cap
	my $nameServer = DNSRecord::NS->new();
	$nameServer->setValue( $self->{authorativeNameServer} );
	$self->addRecords( $nameServer );

	# Mail servers
	my $mailServers = $initEntry->get_value('mailServer',asref => 1 )||[];
	$self->{mailServers} = $mailServers;
	foreach my $ms ( @{$mailServers} ) 
	{
		# Default behaviour for new is to increment NEXT_PRIORITY
		my $mailServer = DNSRecord::MX->new();
		$mailServer->setValue( $ms );
		$self->addRecords( $mailServer );
	}

	# SPF Record is generated from zone object and its MX records
	$self->addRecords( DNSRecord::SPF->new( $self ) );

	# All entries from LDAP
	foreach my $entry ( @entries ) 
	{
		my $record = DNSRecord->fromLDAP($entry);
		$record->initFromLDAP( $self, $entry );
		$self->addRecords( $record );
	}
}

sub consolidate
{
	my $self = shift;
	for( my $i = (@{$self->{records}} - 1) ; $i > -1 ; $i-- )
	{
		my $record = @{$self->{records}}[$i];
		my $type = $record->{recordType};
		next unless( $type eq 'SOA' || $type eq 'NS' || $type eq 'MX' );
		if( $type eq 'SOA' )
		{
			foreach my $f (qw(administratorEmailAddress authorativeNameServer serial))
			{
				$self->{$f} = $record->{$f};
			}
			$self->{administratorEmailAddress} =~ s/\./\@/;
		} elsif( $type eq 'MX' ) {
			push( @{$self->{mailServers}}, $record->value() );
		} else {
			push( @{$self->{nameServers}}, $record->value() );
		}
		splice( @{$self->{records}}, $i, 1 );
	}
}

sub isValid
{
	my $self = shift;
	return $self->{serial} || 0;
}

sub toString
{
	my $self = shift;
	my @string = ();
	foreach my $rr ( @{$self->{records}} )
	{
		push( @string, $rr->toString() );	
	}
	return join( "\n", @string ) . "\n";
}

sub toLDAP
{
	my $self = shift;
	my $baseDN = shift;
	my $dn = "name=$self->{name},$baseDN";
	my $entry = Net::LDAP::Entry->new();
	$entry->dn( $dn );
	$entry->add(
		nameServer => $self->{nameServers},
		mailServer => $self->{mailServers},
		objectClass => 'DNSZone'
	);
	foreach my $f (qw(administratorEmailAddress serial name authorativeNameServer))
	{
		$entry->add( $f => $self->{$f} );
	}
	my @ldapEntries = ( $entry );
	foreach my $record ( @{$self->{records}} )
	{
		push( @ldapEntries, $record->toLDAPEntry( $dn ) );
	}
	return @ldapEntries;
}

sub qualifyDomainName
{
	my( $self, $name ) = @_;
	return $name if( $name =~ /\.$/ );
	return $name . '.' . $self->{name} . '.';
}

sub addRecords
{
	my $self = shift;
	foreach my $record ( @_ )
	{

		push( @{$self->{records}}, $record );
		$record->setZone( $self );
	}
}

sub setName
{
	my $self = shift;
	$self->{name} = shift;
}

sub getRecords
{
	my $self = shift;
	my $rType = shift;
	my @records = ();
	foreach my $record ( @{$self->{records}} ) 
	{
		push(@records, $record ) if( $record->{recordType} eq $rType );
	}
	return @records;
}

sub buildSPFRecord
{
	my $self = shift;
	my @r = ();
	foreach my $mxR ( $self->getRecords( 'MX' ) )
	{
		push( @r, "a:" . $mxR->fqdn('name',enddot => 0 ) );
	}
	return "$self->{name}.\tTXT \"v=spf1 " . join( ' ', @r) . " -all\""; 
}

1;
