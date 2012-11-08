package Passwd::Keyring::KDEWallet;

use warnings;
use strict;
#use parent 'Keyring';
use Net::DBus;
use Carp;

=head1 NAME

Passwd::Keyring::KDEWallet - Password storage implementation based on KDE Wallet.

=head1 VERSION

Version 0.2001

=cut

our $VERSION = '0.2001';

our $APP_NAME = "Passwd::Keyring";
our $FOLDER_NAME = "Perl-Passwd-Keyring";

=head1 SYNOPSIS

KDE Wallet based implementation of L<Passwd::Keyring>.

    use Passwd::Keyring::KDEWallet;

    my $keyring = Passwd::Keyring::KDEWallet->new(app=>"My beautiful app", group=>"My app web passwords");

    $keyring->set_password("John", "verysecret", "my-pseudodomain");
    # And later, on next run maybe
    my $password = $keyring->get_password("John", "my-pseudodomain");
    # plus
    $keyring->clear_password("John", "my-pseudodomain");

Note: see L<Passwd::Keyring::Auto::KeyringAPI> for detailed comments on
keyring method semantics (this document is installed with
Passwd::Keyring::Auto package).

=head1 SUBROUTINES/METHODS

=head2 new

Initializes the processing. Croaks if kwallet does not 
seem to be available.

=cut

sub new {
    my ($cls, %args) = @_;

    my $self = {};
    $self->{app} = $args{app} || 'Passwd::Keyring::KDEWallet';
    $self->{group} = $args{group} || 'Passwd::Keyring::default';
    bless $self;

    #$self->{bus} = Net::DBus->find()
    $self->{bus} = Net::DBus->session()
      or croak("KWallet not available (can't access DBus)");
    my $kwallet_svc = $self->{bus}->get_service('org.kde.kwalletd')
      or croak("KWallet not available (can't access KWallet, likely kwalletd not running)");
    $self->{kwallet} = $kwallet_svc->get_object('/modules/kwalletd', 'org.kde.KWallet')
      or croak("Kwallet not available (can't find wallet)");
    $self->_open_if_not_open();

    unless($self->{kwallet}->hasFolder($self->{handle}, $self->{group}, $self->{app})) {
        $self->{kwallet}->createFolder($self->{handle}, $self->{group}, $self->{app})
          or croak("Failed to create $self->{group} folder (app $self->{app})");
    }

    return $self;
}

sub _open_if_not_open {
    my $self = shift;

    if($self->{handle}) {
        if($self->{kwallet}->isOpen($self->{handle})) {
            return;
        }
    }
    my $net_wallet = $self->{kwallet}->networkWallet()
      or croak("Kwallet not available (can't access network wallet");
    $self->{handle} = $self->{kwallet}->open($net_wallet, 0, $self->{app})
      or croak("Failed to open the KDE wallet");
}

=head2 set_password(username, password, domain)

Sets (stores) password identified by given domain for given user 

=cut

sub set_password {
    my ($self, $user_name, $user_password, $domain) = @_;
    $self->_open_if_not_open();
    my $status = $self->{kwallet}->writePassword(
        $self->{handle}, $self->{group}, "$domain || $user_name", $user_password, $self->{app});
    if($status) { # non-zero means failure
        croak("Failed to save the password (status $status, user name $user_name, domain $domain, handle $self->{handle}, group $self->{group})");
    }
}

=head2 get_password($user_name, $domain)

Reads previously stored password for given user in given app.
If such password can not be found, returns undef.

=cut

sub get_password {
    my ($self, $user_name, $domain) = @_;
    $self->_open_if_not_open();
    my $reply = $self->{kwallet}->readPassword(
        $self->{handle}, $self->{group}, "$domain || $user_name", $self->{app});
    # In case of missing passsword we get empty string. I do not know
    # whether it is possible to distinguish missing password from empty password,
    # but empty passwords are exotic enough to ignore.
    return undef if ! defined($reply) or $reply eq '';
    return $reply;
}

=head2 clear_password($user_name, $domain)

Removes given password (if present)

=cut

sub clear_password {
    my ($self, $user_name, $domain) = @_;
    $self->_open_if_not_open();
    my $status = $self->{kwallet}->removeEntry(
        $self->{handle}, $self->{group}, "$domain || $user_name", $self->{app});
    if($status == 0) {
        return 1;
    } else {
        # TODO: classify failures
        return 0;
    }
}

=head2 is_persistent

Returns info, whether this keyring actually saves passwords persistently.

(true in this case)

=cut

sub is_persistent {
    my ($self) = @_;
    return 1;
}

=head1 AUTHOR

Marcin Kasperski

Approach inspired by L<http://www.perlmonks.org/?node_id=869620>.

=head1 BUGS

Please report any bugs or feature requests to 
issue tracker at L<https://bitbucket.org/Mekk/perl-keyring-kdewallet>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Passwd::Keyring::KDEWallet

You can also look for information at:

L<http://search.cpan.org/~mekk/Passwd-Keyring-KDEWallet/>

Source code is tracked at:

L<https://bitbucket.org/Mekk/perl-keyring-kdewallet>

=head1 LICENSE AND COPYRIGHT

Copyright 2010-2012 Marcin Kasperski.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut


1; # End of Passwd::Keyring::KDEWallet


