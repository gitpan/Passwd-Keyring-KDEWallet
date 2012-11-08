#!perl -T

use strict;
use warnings;
use Test::Simple tests => 2;

use Passwd::Keyring::KDEWallet;

my $ring = Passwd::Keyring::KDEWallet->new;

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

ok( $ring->is_persistent eq 1, "is_persistent knows we are persistent");

