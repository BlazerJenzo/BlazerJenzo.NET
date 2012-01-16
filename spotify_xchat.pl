$user = 'user'; #enter your last.fm username here.
use HTML::Entities;
use LWP::UserAgent;
use XML::Simple;


($c1, $c2, $c3, $bg) = ('', '04', '', '');

$root = Xchat::get_info('xchatdir');


sub HTTPrequest {
	my $agent = new LWP::UserAgent;
	my $request = new HTTP::Request ('GET', @_[0]);
	$agent -> agent ('Perl 5.10 IO socket');
	my $buf = $agent -> request ($request);
	return ($buf -> content);
}

Xchat::register ('Spotify / Last.fm Now playing', '0.1', 'Alex Sorlie');
if ($user) {
	my $xml = XMLin (&HTTPrequest ("http://ws.audioscrobbler.com/2.0/user/$user/recenttracks.xml"));
	if ( $xml->{ 'track' } ) {
		Xchat::hook_command ('lastfm', 'nowplaying');
		Xchat::print ("\002Spotify / Last.fm now playing\002 version 0.1 by Alex Sorlie");
	}
	else { Xchat::print ("\00304\002last.fm error:\002 invalid username, or no track data for user!"); }
}
else { Xchat::print ("\00304\002last.fm error:\002 no username specified!"); }

sub nowplaying {
	my $xml = XMLin (&HTTPrequest ("http://ws.audioscrobbler.com/2.0/user/$user/recenttracks.xml"), ForceArray => ['track'], ForceContent => 1);
	if ($xml) {
		$track = $xml->{ 'track' }[0];
		my ($title, $artist, $album, $np) = ($track->{ 'name' }->{ 'content' }, $track->{ 'artist' }->{ 'content' }, $track->{ 'album' }->{ 'content' }, defined ($track->{ 'nowplaying' }));
		if ($title) {
			my $albumtext = "|\003$c2 Album:\003$c3 $album " if $album;
			if ($np) {
				Xchat::command ("say np: ${artist} - ${title} :: Via Spotify");
			}
			else {
				Xchat::command ("say np: ${artist} - ${title} :: Via Spotify");
			}
		}
		else {
			Xchat::print ("\002Error:\002 No tracks found in last.fm XML feed!");
		}
	}
	else {
		Xchat::print("\002Error:\002 Could not retrieve last.fm XML feed!");
	}
	return (1);
}
