#!perl -T

use strict;
use warnings;
use Test::Simple tests => 20;

use Passwd::Keyring::KDEWallet;

my $DOMAIN_A = 'my@@domain';
my $DOMAIN_B = 'bum trala la';
my $DOMAIN_C = 'other domain';

my $USER1 = "Paul Anton";
my $USER2 = "Gżegąź";
my $USER4 = "-la-san-ty-";

my $PWD1 = "secret-Paul";
my $PWD1_ALT = "secret-Paul2 ąąąą";
my $PWD2 = "secret-Greg";
my $PWD4 = "secret-Duke";

my $ring = Passwd::Keyring::KDEWallet->new(app=>"Passwd::Keyring::KDEWallet", group=>"Unit tests (secrets)");

ok( defined($ring) && ref $ring eq 'Passwd::Keyring::KDEWallet',   'new() works' );

$ring->set_password($USER1, $PWD1, $DOMAIN_B);
$ring->set_password($USER2, $PWD2, $DOMAIN_B);#
$ring->set_password($USER1, $PWD1_ALT, $DOMAIN_C);
$ring->set_password($USER4, $PWD4, $DOMAIN_B);

ok( 1, "set_password works" );

ok( $ring->get_password($USER1, $DOMAIN_B) eq $PWD1, "get works");

ok( $ring->get_password($USER2, $DOMAIN_B) eq $PWD2, "get works");

ok( $ring->get_password($USER1, $DOMAIN_C) eq $PWD1_ALT, "get works");

ok( $ring->get_password($USER4, $DOMAIN_B) eq $PWD4, "get works");

$ring->clear_password($USER1, $DOMAIN_B);
ok(1, "clear_password works");

ok( ! defined($ring->get_password($USER1, $DOMAIN_A)), "get works");

ok( ! defined($ring->get_password($USER2, $DOMAIN_A)), "get works");

ok( $ring->get_password($USER2, $DOMAIN_B) eq $PWD2, "get works");

ok( $ring->get_password($USER1, $DOMAIN_C) eq $PWD1_ALT, "get works");

ok( $ring->get_password($USER4, $DOMAIN_B) eq $PWD4, "get works");

ok( $ring->clear_password($USER2, $DOMAIN_B) eq 1, "clear clears");

ok( ! defined($ring->get_password($USER2, $DOMAIN_A)), "clear cleared");

ok( $ring->get_password($USER1, $DOMAIN_C) eq $PWD1_ALT, "get works");

ok( $ring->get_password($USER4, $DOMAIN_B) eq $PWD4, "get works");

ok( $ring->clear_password($USER1, $DOMAIN_C) eq 1, "clear clears");

ok( $ring->clear_password($USER4, $DOMAIN_B) eq 1, "clear clears");

ok( ! defined($ring->get_password($USER1, $DOMAIN_C)), "clear cleared");
ok( ! defined($ring->get_password($USER4, $DOMAIN_B)), "clear cleared");





