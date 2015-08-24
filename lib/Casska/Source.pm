package Casska::Source;

use 5.010;
use Scalar::Util qw( blessed );
use Try::Tiny;
use Kafka qw/
		$BITS64
		$DEFAULT_MAX_BYTES
/;
use Kafka::Connection;
use Kafka::Consumer;
use Moo;
use namespace::clean;

has 'host' => (
    is       => 'ro',
    required => 1,
);
has 'topic' => (
    is       => 'ro',
    required => 1,
);
has 'consumer' => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);
sub _build_consumer {
    my ($self) = @_;
    my $connection = Kafka::Connection->new( host => $self->host );
    my $consumer   = Kafka::Consumer->new( Connection => $connection );
    return $consumer;
}
 
sub info {
    say 'This is Kafka package ', $Kafka::VERSION;
    say 'You have a ', $BITS64 ? '64' : '32', ' bit system';
}
 
sub fetch {
    my ($self, $offset) = @_;
    $offset = defined $offset ? $offset : 0;
    my $messages = $self->consumer->fetch(
        $self->topic,                   # topic
        0,                              # partition
        $offset,                        # offset
        $DEFAULT_MAX_BYTES              # Maximum size of MESSAGE(s) to receive
    );
    return $messages;
}

1;
