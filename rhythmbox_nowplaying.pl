#!/usr/bin/perl -w

Xchat::register("Rhythmbox Now Playing script for XChat", "0.1", "Rhythmbox Now Playing script for XChat" , "");
Xchat::hook_command("np", "nowPlaying");

sub nowPlaying
{
	# Check if a rhythmbox process exists.	
	if (`ps -C rhythmbox` =~ /rhythmbox/) {
		# Check if rhythmbox streams music
		$title = `rhythmbox-client --print-playing-format %st`;
		if (length $title > 1) {
			$title = `rhythmbox-client --print-playing-format %st\\ -\\ %tt`;
		} else {
			$title = `rhythmbox-client --print-playing-format %ta\\ -\\ %tt`;
		}
		
		# Send out now playing line
		chop $title;
		Xchat::command("me is listening to: " . $title);
	} else {
		Xchat::print("Rhythmbox is not running.");
	}
}

