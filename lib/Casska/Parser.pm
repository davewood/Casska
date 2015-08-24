package Casska::Parser;

use DateTime::Format::ISO8601;
use Moo;
use namespace::clean;

sub parse {
    my ($self, $payload) = @_;

    #2015-08-11T16:20:34.847059+02:00 ns10a named[10368]: queries: info: client 84.116.34.244#59893 (mccgtb.austrocontrol.at): query: mccgtb.austrocontrol.at IN A - (192.76.243.2)
    if ($payload =~ m/
			^
			(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}\+\d{2}:\d{2}) #ts
			\s
			\w+ #ns
			\s
			.*
			client\ ([\d.:a-f]+\#\d+) #client
			.*
			$
		    /xms) {
	my $dt = DateTime::Format::ISO8601->parse_datetime( $1 );
        return ($dt->strftime('%s'), $2);
    }

#    #10-Aug-2015 14:14:55.325 client 84.2.227.133#9553 (ujtdqshoyqkt.tuwien.ac.at): query: ujtdqshoyqkt.tuwien.ac.at IN A -EDC (192.76.243.2)
#    elsif ($payload =~ m/
#			^
#			(\d{2}-\w{3}-\d{4}\s\d{2}:\d{2}:\d{2}\.\d{3})
#			\s
#			client\ ([\d.:a-f]+\#\d+) #client
#			.*
#			$
#		    /xms) {
#    }
#
#    else {
#        warn "Unknown Format: $payload";
#    }

    return;
}

1;
