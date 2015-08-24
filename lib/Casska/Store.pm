package Casska::Store;

use DBI;
use Moo;
use namespace::clean;

has 'host' => (
    is       => 'ro',
    required => 1,
);
has 'username' => (
    is       => 'ro',
    required => 1,
);
has 'password' => (
    is       => 'ro',
    required => 1,
);
has 'keyspace' => (
    is       => 'ro',
    required => 1,
);
has 'dbh' => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);
sub _build_dbh {
    my ($self) = @_;
    my $dbh = DBI->connect(
                  "dbi:Cassandra:host=" . $self->host . ";keyspace=" . $self->keyspace,
                  $self->username,
                  $self->password,
                  { RaiseError => 1 }
    );
    return $dbh;
}
has 'query' => (
    is       => 'ro',
    required => 1,
);
has 'sth' => (
    is      => 'ro',
    lazy    => 1,
    builder => 1,
);
sub _build_sth {
    my ($self) = @_;
    my $sth = $self->dbh->prepare($self->query, { Consistency => "quorum", Retries => 1 });
    return $sth;
}

sub put {
    my ($self, @data) = @_;
    $self->sth->execute(@data) or die $self->sth->errstr;
}   

1;
