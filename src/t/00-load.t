#!perl -T

use Test::More tests => 13;

BEGIN {
    use_ok( 'DNSRecord' ) || print "Bail out!\n";
    use_ok( 'DNSZone' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::recordDataValueHolder' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::A' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::NS' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::MX' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::SOA' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::CNAME' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::TXT' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::SPF' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::SRV' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::SSHFP' ) || print "Bail out!\n";
    use_ok( 'DNSRecord::AAAA' ) || print "Bail out!\n";
}

diag( "Testing DNSRecord $DNSRecord::VERSION, Perl $], $^X" );
