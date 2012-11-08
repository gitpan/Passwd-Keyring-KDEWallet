#!perl -T

use strict;
use warnings;
use Test::Simple tests => 4;

use Passwd::Keyring::KDEWallet;

my $UGLY_NAME = "Joh ## no ^^ »ąćęłóśż«";
my $UGLY_PWD =  "«tajne hasło»";
my $UGLY_DOMAIN = '«do»–main';

my $ring = Passwd::Keyring::KDEWallet->new(app=>"Passwd::KDEWallet::Keyring unit tests", group=>"Ugly chars");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

$ring->set_password($UGLY_NAME, $UGLY_PWD, $UGLY_DOMAIN);

ok( 1, "set_password with ugly chars works" );

ok( $ring->get_password($UGLY_NAME, $UGLY_DOMAIN) eq $UGLY_PWD, "get works with ugly characters");

ok( $ring->clear_password($UGLY_NAME, $UGLY_DOMAIN) eq 1, "clear clears");

