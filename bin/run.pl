#!/usr/bin/env perl
use 5.010;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";

use Casska::Source;
use Casska::Store;
use Casska::Parser;
use Scalar::Util qw( blessed );
use Try::Tiny;
use Config::Tiny;

my $config = Config::Tiny->read( "$Bin/../etc/config.ini" );

my $store = Casska::Store->new(
	host     => $config->{store}{host},
	keyspace => $config->{store}{keyspace},
	query    => $config->{store}{query},
	username => $config->{store}{username},
	password => $config->{store}{password},
);
my $source = Casska::Source->new(
	host  => $config->{source}{host},
	topic => $config->{source}{topic},
);
my $parser = Casska::Parser->new;

my $offset = 11051279;

while (1) {
    say "fetching ...";
    my $messages = $source->fetch($offset);
     
    if ( @$messages ) {
        foreach my $message ( @$messages ) {
            if( $message->valid ) {
                say 'offset: ', $message->offset;
                my @data = $parser->parse($message->payload);
                $store->put(@data) if @data;
            } else {
                say 'error: ', $message->error;
            }
            $offset = $message->next_offset;
        }
    }
    else {
        sleep 5;
    }
}

$store->dbh->disconnect;
