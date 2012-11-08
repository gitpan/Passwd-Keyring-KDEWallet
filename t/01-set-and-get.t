#!perl -T

use strict;
use warnings;
use Test::More tests => 8;

use Passwd::Keyring::KDEWallet;

my $ring = Passwd::Keyring::KDEWallet->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

my $USER = 'John';
my $PASSWORD = 'verysecret';
my $DOMAIN = 'some simple domain';

$ring->set_password($USER, $PASSWORD, $DOMAIN);

ok( 1, "set_password works" );

is( $ring->get_password($USER, $DOMAIN), $PASSWORD, "get recovers");

is( $ring->clear_password($USER, $DOMAIN), 1, "clear_password removed one password" );

is( $ring->get_password($USER, $DOMAIN), undef, "no password after clear");

is( $ring->clear_password($USER, $DOMAIN), 0, "clear_password again has nothing to clear" );

is( $ring->clear_password("Non user", $DOMAIN), 0, "clear_password for unknown user has nothing to clear" );
is( $ring->clear_password("$USER", 'non domain'), 0, "clear_password for unknown domain has nothing to clear" );
