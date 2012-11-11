#!perl -T

use strict;
use warnings;
use Test::More;

if($ENV{DESKTOP_SESSION} || $ENV{DBUS_SESSION_BUS_ADDRESS}) {
    plan tests => 4;
} else {
    plan skip_all => "Keyring not available (not running under KDE/Gnome/other desktop session), skipping tests";
}


use Passwd::Keyring::KDEWallet;

my $UGLY_NAME = "Joh ## no ^^ »ąćęłóśż«";
my $UGLY_PWD =  "«tajne hasło»";
my $UGLY_REALM = '«do»–main';

my $ring = Passwd::Keyring::KDEWallet->new(app=>"Passwd::KDEWallet::Keyring unit tests", group=>"Ugly chars");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

$ring->set_password($UGLY_NAME, $UGLY_PWD, $UGLY_REALM);

ok( 1, "set_password with ugly chars works" );

ok( $ring->get_password($UGLY_NAME, $UGLY_REALM) eq $UGLY_PWD, "get works with ugly characters");

ok( $ring->clear_password($UGLY_NAME, $UGLY_REALM) eq 1, "clear clears");

