package Net::Twitter::Search;

use warnings;
use strict;
use base qw/Net::Twitter/;
use URI::Escape;

our $VERSION = '0.11';
#http://search.twitter.com/search.json?q=<query>

sub search {
    my $self = shift;
    my $query = shift;
    my $params = shift || {};

    #grab the params
    my $rpp = $params->{'rpp'} || 10;
    my $page = $params->{'page'} || 1;

    my $lang = $params->{'lang'} || undef;
    my $since_id = $params->{'since'} || undef;
    my $geocode = $params->{'since'} || undef;

    #build URL
    my $url = 'http://search.twitter.com/search.json?q=' . URI::Escape::uri_escape($query) .'&page='. $page;
    $url .= '&lang=' . URI::Escape::uri_escape($lang) if ($lang);
    $url .= '&since_id=' . URI::Escape::uri_escape($since_id) if ($since_id);
    $url .= '&geocode=' . URI::Escape::uri_escape($geocode) if ($geocode);

    #do request
    my $req = $self->{ua}->get($url);

    die 'fail to connect to twitter. maybe over Rate limit exceeded or auth error' unless $req->is_success;
    return [] if $req->content eq 'null';

    #decode the json
    my $res = JSON::Any->jsonToObj($req->content) ;

    return $res->{'results'};

}


1;

=head1 NAME

Net::Twitter::Search Twitter Search 

=head1 SYNOPSYS

  use Net::Twitter::Search;

  my $twitter = Net::Twitter::Search->new();

  my $results = $twitter->search('Albi the racist dragon');
  foreach my $tweet (@{ $results }) {
    my $speaker =  $tweet->{from_user};
    my $text = $tweet->{text};
    my $time = $tweet->{created_at};
    print "$time <$speaker> $text\n";
  }

   #you can also use any methods from Net::Twitter.
   my $twitter = Net::Twitter::Search->new(username => $username, password => $password);
   my $steve = $twitter->search('Steve');
   $twitter->update($steve .'? Who is steve?');
    
=head1 DESCRIPTION

For searching twitter - handy for bots

=head1 METHOD

=head2 search 

required parameter: query

returns: hash

=head1 EXAMPLES

Find tweets containing a word

  $results = $twitter->search('word');

Find tweets from a user:

  $results = $twitter->search('from:br3nda');

Find tweets to a user:

  $results = $twitter->search('to:serenecloud');

Find tweets referencing a user:

  $results = $twitter->search('@br3ndabot');

Find tweets containing a hashtag:

  $results = $twitter->search('#perl');

Combine any of the operators together:

  $results = $twitter->search('solaris anger from:br3nda');

 
=head1 ADDITIONAL PARAMETERS 

  The search method also supports the following optional URL parameters:
 
=head2 lang

Restricts tweets to the given language, given by an ISO 639-1 code.

  $results = $twitter->search('hello', {lang=>'en'});
  #search for hello in maori
  $results = $twitter->search('kiaora', {lang=>'mi'});


=head2 rpp

The number of tweets to return per page, up to a max of 100.

  $results = $twitter->search('love', {rpp=>'10'});

=head2 page

The page number to return, up to a max of roughly 1500 results (based on rpp * page)

  #get page 3
  $results = $twitter->search('love', {page=>'3'});

=head2 since_id

Returns tweets with status ids greater than the given id.

  $results = $twitter->search('love', {since_id=>'1021356410'});

=head2 geocode

returns tweets by users located within a given radius of the given latitude/longitude, where the user's location is taken from their Twitter profile. The parameter value is specified by "latitide,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers).

 $results = $twitter->search('coffee', {geocode=> '40.757929,-73.985506,25km'});

Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly.


=head1 SEE ALSO

L<Net::Twitter>

=head1 AUTHOR

Brenda Wallace <shiny@cpan.org>

=cut
