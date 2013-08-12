use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DNSRecord',
    AUTHOR              => q{Eddie Olsson <ewt@avajadi.org>},
    VERSION_FROM        => 'lib/DNSRecord.pm',
    ABSTRACT_FROM       => 'lib/DNSRecord.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES			=> ['bin/DNSZone2bind'],
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'dnstools-*' },
);
