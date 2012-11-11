#!perl -T

use strict;
use warnings;
use Test::More;

if($ENV{DESKTOP_SESSION} || $ENV{DBUS_SESSION_BUS_ADDRESS}) {
    plan tests => 2;
} else {
    plan skip_all => "Keyring not available (not running under KDE/Gnome/other desktop session), skipping tests";
}


use Passwd::Keyring::KDEWallet;

my $ring = Passwd::Keyring::KDEWallet->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

ok( $ring->is_persistent eq 1, "is_persistent knows we are persistent");

