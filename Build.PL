use 5.006;
use strict;
use warnings;
use Module::Build;
use ExtUtils::PkgConfig;

my $builder = Module::Build->new(
    module_name         => 'Passwd::Keyring::KDEWallet',
    dynamic_config      => 1,
    license             => 'perl',
    dist_author         => q{Marcin Kasperski <Marcin.Kasperski@mekk.waw.pl>},
    dist_version_from   => 'lib/Passwd/Keyring/KDEWallet.pm',
    build_requires => {
        'Module::Build' => '0.19', # xs
        'ExtUtils::CBuilder' => 0,
        'Test::More' => 0,
        'Test::Pod::Coverage' => '1.0.8',
    },
    requires => {
        'perl' => 5.006,
        'Net::DBus' => 0,
    },
    add_to_cleanup      => [ 'Passwd-Keyring-KDEWallet-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
