package Net::Twitter::Search;

use warnings;
use strict;
use base qw/Net::Twitter/;
use Array::Diff;
use Data::Dumper;

our $VERSION = '0.02';
#http://search.twitter.com/search.json?q=<query>

sub search {
    my $self = shift;
    my $query= shift;
    my $url = 'http://search.twitter.com/search.json?q=' . $query;
    my $req = $self->{ua}->get($url);

    die 'fail to connect to twitter. maybe over Rate limit exceeded or auth error' unless $req->is_success;
    return [] if $req->content eq 'null';

    my $res = JSON::Any->jsonToObj($req->content) ;
    return $res->{'results'};

}


1;

=head1 NAME

Net::Twitter::Diff - Twitter Diff

=head1 SYNOPSYS

use Net::Twitter::Search;

  my $twitter = Net::Twitter::Search->new();

  my $results = $twitter->search('hello');
  foreach my $tweet (@{ $results }) {
    my $speaker =  $tweet->{from_user};
    my $text = $tweet->{text};
    my $time = $tweet->{created_at};
    print "$time <$speaker> $text\n";
  }

    # If you want , this module use Net::Twitter as base so you can use methods Net::Twitter has.
    my $twitter = Net::Twitter::Search->new(username => $username, password => $password);
    $twitter->update('My current Status');
    
=head1 DESCRIPTION

For searching twitter - handy for bots

=head1 METHOD

=head2 diff

run search

response hash


=head1 SEE ALSO

L<Net::Twitter>

=head1 AUTHOR

Brenda Wallace <brenda@wallace.net.nz>

=cut
