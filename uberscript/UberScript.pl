#!/usr/bin/perl
#
# Flashy's uber script. irc-flash@digdilem.org - poke Flash_ at irc.freenet.org - #xchat
# If used in your own work, please include my name in it somewhere, thanks.
#
# Should work with X-Chat, all versions since 2.4.5 (Current: 2.6.6). Requires Perl plugin and installed version or Perl(*nix) or Activeperl(Windows)
# 2.4.5 introduces the /menu commands which UberScript makes much use of. If you don't see menus, that's why.
# 
# Flash-Uberscript. Does many many things to make your enjoyment of IRC better. 
# Random slaps, gives. Hide join/parts/nick changes, now playing, triggers, greetings, auto-op etc etc. 
#
# To install, copy to your xchat working directory (Linux: ~/.xchat2  Windows: c:\Documents and settings\username\Application Data\X Chat2 )
# Including all text files.
#
# v.1.0 - Initial Working release.
# v.1.1b - Secondary release. (Some minor errors)
# v.1.1c - More minor bugfixes. Turned off warnings.
# v.1.1e - /ubergive and /uberslap rewritten. Big CTCP response bug fixed. More bugfixes. 
# 
##################################
#
#  Please see the readme for details of use, or /USET for quick info once loaded
#use strict;
#use warnings;  # I think I've ironed out all the undef bugs, but to save complaints I'm a turning these off. 
use Xchat qw( :all );
#
##################################
# Change this or you won't be able to edit the config files by clicking a button.
my $uber_editor = "notepad"; # Example Windows editor for Friends/trigger textfiles - Notepad is a safe bet on Windows systems
#my $uber_editor= = "xjed"; # Example linux editor for Friends/trigger textfiles
##################################
#  Initial values. In most cases may be changed whilst in use using the menu system or /uset. 
# NOTE: If you change any of the following, you WILL NEED TO /uber_rehash to reload this script!
#  You may safely leave these alone, but change if you wish.
##################################
# Cosmetic 
my $uber_buttons = 1;	# Add user buttons for some useful strings
my $uber_menu = 1;			# Add pulldown menu
# For a cleaner IRC
my $uber_hide_joinpart = 0;	# Hide Joins/parts 
my $uber_hide_nickchanges = 0;  # Hide Nick changes. 
my $uber_hide_modechanges = 0;  # Hide mode changes.  (+o, +v etc)
my $uber_hidejunk = 0; # Toggles the following "junk" strings on/off  (NOTE! Also requires uber_triggers_enabled to work!)
my @uber_junkstrings = ("Now Playing","np: ","listens to:","laying:"," is streaming:"," is away "); # List of strings which if found in a line, are hidden (Case sensitive and NOT changeable from within X-chat)
# Peak settings !peak
my $uber_peak_enabled = 1;	# Toggle !peak monitoring/response
my $uber_peak_announce = 0;	# If enabled, announces to the channel when a new peak is achieved.
my $uber_peak_datfile="uber/ChannelPeaks.dat"; # File to store peak info
# Changing your quit messages
my $uber_random_quits = 1; # Toggle whether to use random quit messages
my $uber_quit_messages = "uber/quits.txt"; # File to contain quit messages (One per line)
# Changing your part messages
my $uber_random_parts = 1; # Toggle whether to use random part messages
my $uber_part_messages = "uber/parts.txt"; # File to contain part messages (One per line)
# The Trigger response system.
my $uber_triggers_enabled = 1; # Global trigger on/off (Can be a performance hit on slow computers with many busy channels to run this)
my $uber_trigger_macro_scanning = 1; # This checks each line for macros (your name, channel etc). This can be quite cpu-intensive so unset this if you don't need macros for incoming text and notice xchat is using a lot of cpu.
my $uber_triggerfile = "uber/triggers.txt"; # Textfile containing Triggers.
# The Greetings system
my $uber_greetings_enabled = 1; # Global trigger for Greetings. Small performance hit, but required for auto-op/voice and greetings.
my $uber_greetingfile = "uber/welcome.txt"; # Configuration file for the Greeting system. (See file for details)
# If you're using Quakenet, you may like to Auth with Q automatically. If so, add your details below
my $uber_Q_auth_toggle = 0; # Toggle Q authing on or off
my $uber_Q_auth_name = "AuthName"; # Your Q AuthName
my $uber_Q_auth_pass = "PASSWORD"; # Your Q Password
# Random CTCP version replies
my $uber_ctcp_versions = 1; # Toggle on and off the random ctcp replies.
my $uber_ctcp_announcements = 1; # Toggle whether you're informed when somebody CTCP versions you.
my $uber_ctcp_version_file = "uber/versions.txt"; # Text file containing various ctcp versions
# Away Message Options
my $uber_away_randoms=1; # Toggle whether to use a new away reason every time. 
my $uber_away_random_file = "uber/awayreasons.txt"; # Text file containing reasons for being away.
# Private Message/Query (PM) Options
my $uber_pm_autoreply = 1; # Whether to auto-reply to the first line of a PM when you're not /away
my $uber_pm_autoreply_away = 1; # Whether to auto-reply to the first line of a PM when you're /away
my $uber_pm_autoreply_message = "Auto-Reply: Hello %n. Please leave your message (Don't just say \"You there?\" and expect a reply)"; # Message to post. NO COMMAS!
# Fun stuff
my $uber_sillystuff_enabled = 1; # Toggle whether to respond to !slap, !give and !quote triggers
# Invited
my $uber_invites_autojoin = 1; # Join channels automatically when invited
my $uber_invites_autothanks = 1; # Respond automatically to inviter telling them yes thanks, or no thanks - depending on _autojoin setting
# Regaining your nick on join
my $uber_regain_nick = 1; # Will keep attempting to regain your primary nick for this server if it isn't already set to.
# Session-Saving
my $uber_session_saving = 1; # Global toggle to save your session every few minutes, and will reconnect automatically on start.
my $uber_session_throttle = 500; # Number of milliseconds to throttle channel-joining. (Uberscript will pause this long between trying to join each channel)
my $uber_session_config = "uber/session.cfg"; # File containing session information.
# Various files X-Chat expects to find.
my $uber_slapfile = "uber/slaps.txt";  # Textfile containing slap strings (one per line)
my $uber_givefile = "uber/gives.txt";  # Textfile containing slap strings (one per line)
my $uber_quotesfile = "uber/quotes.txt"; # DEFAULT quote file - used with !quote or /uber_quote is triggered without a filename.
# Settings related to the favourites list.
my $uber_favourites = 1; # Global enable/disable setting
my $uber_favouritesfile = "uber/favourites.txt"; # Text file containing them
my $uber_fav_buttons = 1; # Whether to add user buttons for addfav and delfav
# Quickstrings setup
my $uber_quickstrings = 1; # Global toggle
my $uber_quickstringsfile = "uber/quickstrings.txt"; # Text file containing quickstrings
# System Menu (Adds a bunch of toggled options from Xchat's set)
my $uber_system_menu = 1; # Turn it on or off
##################################
# The following cannot be changed from within X-chat, you need to change here and /reload the script. (Or /reloadall)
my @uber_ignore_channels =("#fn'#debian","#ignore_chan1","#fn'#perl","#of'#debian-uk","#ignore_chan2","#fn'#XChat"); # Comma-seperated list of channels where output is blocked. 
#	^ (This still allows blocking of joins/parts etc - but won't output or respond to triggers. For channels where you'll get glared at for being spammy)
my $uber_selffile = "UberScript.pl"; # Name of this script
##################################
# Begin script. -------- DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ------------
#
# Declare some globals.
my $uber_path=Xchat::get_info('xchatdir') . '/'; # Windows is just as happy with / as linux is.
my $uber_version="1.1e";
my $uber_nick= ' '; # Pre-declares
my $uber_line= ' ';
my $uber_orig_line= ' ';
my $uber_chan= ' ';
my @uber_greetings=(); # Array containing greetings data.
my $uber_greetings_filesize=0; # Used to monitor size of greetings file and reload if changed.
my @uber_triggers= (); # Array containing triggers
my $uber_triggers_filesize=0; # Used to monitor size of triggers file and reload if changed.
my @uber_favlist=(); # Array containing list of favourites
my @uber_quicklist=(); # Array containing list of quickstrings
my $utmpline=  ' '; # Junk string called by various things
my $utmp_ignore_next=0; # To prevent my own lines resetting data
my $uber_last_pmer = ' '; # Nick of last person to pm me
my @uber_offon=('Off','On');
my $uber_regaining_nick=0; # Used so I don't flood trying to get nick back
my $uber_ison_timer=0;
my $uber_session_timer=0;
my $uber_session_cycle = 30000; # Number of ms between calls to session_saver()
my $uber_ison_cycle = 60000; # Number of ms between calls to session_saver(). 60000 = 1/minute
my $uber_tempfile=$uber_path ."Uber_tempfile.tmp"; # Temporary file to use.
#
# Main monitoring loop, calls sub-functions depending on value.
Xchat::register( "Flashy's Uberscript V.$uber_version", $uber_version, "Uberscript", "" );
uber_msg("\002\00317Loaded Flashy's Uberscript V.$uber_version http://digdilem.org/");
Xchat::hook_print('Channel Message', "uber_ctrl"); # Check incoming text for triggers
Xchat::hook_print('Channel Action Hilight', "uber_ctrl"); # Check incoming text with my nick in it.
Xchat::hook_print('Your Message', "uber_ctrl"); #'Check my outgoing stuff for triggers too
Xchat::hook_print('Channel Action',"uber_ctrl"); # Don't forget emotes
# Command hooks
Xchat::hook_command('uset', "uber_uset"); 
Xchat::hook_command('uberslap', "uber_slap"); 
Xchat::hook_command('ubergive', "uber_give"); 
Xchat::hook_command('uberquote', "uber_quote"); 
Xchat::hook_command('uberpeak', "uber_peak_response");
Xchat::hook_command('uberload', "uber_load_config");
Xchat::hook_command('uber_rehash',"uber_rehash_config");
Xchat::hook_command('uc',"uber_colour");
Xchat::hook_command('away',"uber_away"); # Hook existing
Xchat::hook_command('addfav',"uber_addfav"); # Add favourite
Xchat::hook_command('delfav',"uber_delfav"); # Del favourite
Xchat::hook_command('addquick',"uber_addquick"); # Add Quickstring
Xchat::hook_command('delquick',"uber_delquick"); # Del Quickstring
Xchat::hook_command('showquicks',"uber_showquicks"); # Show all quickstrings
# Some small routines to get around not being able to use getstr in the menus
Xchat::hook_command('uber_getstr_editor',"uber_getstr_editor");
Xchat::hook_command('uber_getstr_autoreply',"uber_getstr_autoreply");
Xchat::hook_command('uber_getstr_filename',"uber_getstr_filename");
Xchat::hook_command('uber_regain_nick',"uber_regain_nick");
Xchat::hook_command('uber_reloadsession',"uber_session_saver_reload");
Xchat::hook_command('uber_dialog',"uber_dialog"); # Simply output a message
# Server hooks
Xchat::hook_server('303', "uber_ison_handler" ); # Watch to regain my nick 
# Print hooks
Xchat::hook_print( "Join", "uber_join_filter");     # Hook Joins
Xchat::hook_print( "Part", "uber_part_filter");		# Hook Parts
Xchat::hook_print( "Quit", "uber_part_filter");		# Hook Parts
Xchat::hook_print( "Change Nick", "uber_nickchanger_filter");       # Hook Nick Changes
Xchat::hook_print( "Raw Modes", "uber_modechanger_filter");       # Hook Nick Changes
Xchat::hook_print( "Server Text", "uber_server_watch"); # Watch for server messages
Xchat::hook_print( "CTCP Generic", "uber_random_ctcp_version_respond"); # Watch for CTCP VERSION events
Xchat::hook_print( "Private Message to Dialog", "uber_pm_watch"); # Watch for private messages
Xchat::hook_print( "Invited","uber_invites"); # When invited, respond

uber_startup(); # Call startup checks

sub uber_ctrl {  # Main loop, checked each line on each channel. Checks for control commands and also for triggers
		if ($utmp_ignore_next eq 0) {  # If currently overriding, return.
			$uber_nick = $_[0][0];
			$uber_line = $_[0][1];
			$uber_orig_line = $_[0][1];
			$uber_chan = Xchat::get_info('channel');
		}		
		foreach (@uber_ignore_channels) { # If in ignore channels list, abort
			if ($uber_chan eq $_) { return Xchat::EAT_NONE; } 
			}
		if ($uber_nick) { Xchat::strip_code ($uber_nick); }
		if ($uber_line) { Xchat::strip_code ($uber_line); }
		my @uber_words = split(/ /,$uber_line);
		my $utmpline=undef;
		# These ones hard-coded as require arguments 
		if (lc($uber_words[0]) eq '!slap') { uber_slap('trigger',$uber_nick,$uber_words[1]); }
		if (lc($uber_words[0]) eq '!give') { uber_give('trigger',$uber_nick,$uber_words[1]); }
		if (lc($uber_words[0]) eq '!quote') { uber_quote('trigger',$uber_nick,$uber_words[1]); }

		if ($uber_triggers_enabled eq 1) { # Main resource-hungry loop. Checks every line that arrives.
			if ($uber_hidejunk eq 1) { # Remove any lines that contain junk strings
				foreach (@uber_junkstrings) {if ($uber_line =~ /$_/i) {  return Xchat::EAT_XCHAT; } }
				}
				# Reload triggerfile if required
				uber_load_triggers(); # Reload if required

			# Compare incoming string against triggers
			foreach  (@uber_triggers) {
				chomp;
				if ($_) {
					my ($ut_string,$ut_chan,$ut_action) = split(/\|/);
						if ((!$ut_chan) or (!$uber_chan)) { } else {
							if ((lc($ut_chan) eq lc($uber_chan)) or ($ut_chan eq '*')) {   # Matches channel
								if ($uber_trigger_macro_scanning ne 0) { # Expand strings
									$ut_string = uber_parse($ut_string);
									}
								if ($uber_line =~ /$ut_string/i) {  # Matches trigger
									uber_command($ut_action);
									}
							}
						}
					}
				}
			}
	}

sub uber_remove_buttons {
	Xchat::command("delbutton UberSlap");  
	Xchat::command("delbutton UberGive");
	Xchat::command("delbutton UberTriggers"); 
	Xchat::command("delbutton AddFav");
	Xchat::command("delbutton DelFav");
	}

sub uber_add_buttons {
	Xchat::command("addbutton Uberslap uberslap %s");
	Xchat::command("addbutton Ubergive ubergive %s");
	Xchat::command("addbutton UberTriggers exec $uber_editor $uber_path$uber_triggerfile");
	if ($uber_fav_buttons) {
		Xchat::command("addbutton AddFav addfav");
		Xchat::command("addbutton DelFav delfav");
		}
	}

sub uber_remove_menu {
	Xchat::command("menu DEL UberScript");
	Xchat::command("menu DEL Favourites");
	}

sub uber_add_menu {
	Xchat::command("menu DEL UberScript"); # Remove old first
	# Add top-level
	Xchat::command("menu ADD UberScript");
	# Filtering Section
	Xchat::command("menu ADD \"UberScript/Filtering\"");
	Xchat::command("menu -t$uber_hide_joinpart ADD \"UberScript/Filtering/Hide Joins, Parts & Quits\"  \"uset uber_hide_joinpart\"  \"uset uber_hide_joinpart\"");
	Xchat::command("menu -t$uber_hide_nickchanges ADD \"UberScript/Filtering/Hide Nick Changes\"  \"uset uber_hide_nickchanges\"  \"uset uber_hide_nickchanges\"");
	Xchat::command("menu -t$uber_hide_modechanges ADD \"UberScript/Filtering/Hide Mode Changes\"  \"uset uber_hide_modechanges\"  \"uset uber_hide_modechanges\"");
	Xchat::command("menu -t$uber_hidejunk ADD \"UberScript/Filtering/Hide Junk Strings\"  \"uset uber_hidejunk\"  \"uset uber_hidejunk\"");
	# Peak Section
	Xchat::command("menu ADD \"UberScript/Channel Peaks\"");
	Xchat::command("menu -t$uber_peak_enabled ADD \"UberScript/Channel Peaks/Enable Channel Peak\"  \"uset uber_peak_enabled\"  \"uset uber_peak_enabled\"");
	Xchat::command("menu -t$uber_peak_announce ADD \"UberScript/Channel Peaks/Enable Peak Announcement\"  \"uset uber_peak_announce\"  \"uset uber_peak_announce\"");
	Xchat::command("menu ADD \"UberScript/Channel Peaks/Announce Channel peak now\" \"uberpeak\"");
	# Silly Section
	Xchat::command("menu ADD \"UberScript/Fun Stuff\"");
	Xchat::command("menu ADD \"UberScript/Fun Stuff/Enable Fun Stuff ($uber_offon[$uber_sillystuff_enabled])\"  \"uset uber_sillystuff_enabled\"  \"uset uber_sillystuff_enabled\"");
	Xchat::command("menu ADD \"UberScript/Fun Stuff/Change Slaps File\"  \"uber_getstr_filename uber_slapfile $uber_slapfile\""); # Can't show file, screws up menu if /
	Xchat::command("menu ADD \"UberScript/Fun Stuff/Change Gives File\"  \"uber_getstr_filename uber_givefile $uber_givefile\""); # Can't show file, screws up menu if /
	Xchat::command("menu ADD \"UberScript/Fun Stuff/Change Quotes File\"  \"uber_getstr_filename uber_quotesfile $uber_quotesfile\""); # Can't show file, screws up menu if /
	# Trigger Section
	Xchat::command("menu ADD \"UberScript/Triggers\"");
	Xchat::command("menu -t$uber_triggers_enabled ADD \"UberScript/Triggers/Enable Triggers\"  \"uset uber_triggers_enabled\"  \"uset uber_triggers_enabled\"");	
	Xchat::command("menu -t$uber_trigger_macro_scanning ADD \"UberScript/Triggers/Expand Macros in incoming text\"  \"uset uber_trigger_macro_scanning\"  \"uset uber_trigger_macro_scanning\"");
	Xchat::command("menu ADD \"UberScript/Triggers/Edit Triggers\"      \"exec $uber_editor $uber_path$uber_triggerfile\"");
	# Network Section.
	Xchat::command("menu ADD \"UberScript/Network\"");
	Xchat::command("menu -t$uber_ctcp_versions ADD \"UberScript/Network/Random CTCP Versions\"  \"uset uber_ctcp_versions\"  \"uset uber_ctcp_versions\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit CTCP Versions\" \"exec $uber_editor $uber_path$uber_ctcp_version_file\"");
	Xchat::command("menu -t$uber_ctcp_announcements ADD \"UberScript/Network/Be told when CTCP Versioned\"  \"uset uber_ctcp_announcements\"  \"uset uber_ctcp_announcements\"");
	Xchat::command("menu -t$uber_Q_auth_toggle ADD \"UberScript/Network/Quakenet Authing\"  \"uset uber_Q_auth_toggle\"  \"uset uber_Q_auth_toggle\"");
	Xchat::command("menu -t$uber_regain_nick ADD \"UberScript/Network/Regain Nick\"  \"uset uber_regain_nick\"  \"uset uber_regain_nick\"");
	# Session Section.
	Xchat::command("menu ADD \"UberScript/Sessions\"");
	Xchat::command("menu -t$uber_session_saving ADD \"UberScript/Sessions/Session Saving Enabled\"  \"uset uber_session_saving\"  \"uset uber_session_saving\"");
	# Favourites Section
	Xchat::command("menu ADD \"UberScript/Favourites\"");
	Xchat::command("menu -t$uber_favourites ADD \"UberScript/Favourites/Favourites List Enabled\"  \"uset uber_favourites\"  \"uset uber_favourites\"");
	Xchat::command("menu -t$uber_fav_buttons ADD \"UberScript/Favourites/Favourites Buttons\"  \"uset uber_fav_buttons\"  \"uset uber_fav_buttons\"");
	Xchat::command("menu -t$uber_quickstrings ADD \"UberScript/Favourites/Quickstrings Enabled\"  \"uset uber_quickstrings\"  \"uset uber_quickstrings\"");
	Xchat::command("menu ADD \"UberScript/Favourites/Show Quickstrings\"  \"showquicks\"");	
	# Away 
	Xchat::command("menu ADD \"UberScript/Away\"");
	Xchat::command("menu -t$uber_away_randoms ADD \"UberScript/Away/Enable Random Away Reasons\" \"uset uber_away_randoms\"  \"uset uber_away_randoms\"");
	Xchat::command("menu ADD \"UberScript/Away/Edit Away File\"      \"exec $uber_editor $uber_path$uber_away_random_file\"");
	# PM Section
	Xchat::command("menu ADD \"UberScript/AutoReply\"");
	Xchat::command("menu -t$uber_pm_autoreply ADD \"UberScript/AutoReply/PM AutoReply (Here)\" \"uset uber_pm_autoreply\"  \"uset uber_pm_autoreply\"");
	Xchat::command("menu -t$uber_pm_autoreply_away ADD \"UberScript/AutoReply/PM AutoReply (Away)\" \"uset uber_pm_autoreply_away\"  \"uset uber_pm_autoreply_away\"");
	Xchat::command("menu ADD \"UberScript/AutoReply/Change AutoReply String '$uber_pm_autoreply_message'\"  \"uber_getstr_autoreply\"");
	# Invites Section
	Xchat::command("menu ADD \"UberScript/Invites\"");
	Xchat::command("menu -t$uber_invites_autojoin ADD \"UberScript/Invites/Join on Invite\" \"uset uber_invites_autojoin\" \"uset uber_invites_autojoin\"");
	Xchat::command("menu -t$uber_invites_autothanks ADD \"UberScript/Invites/Thank on Invite\" \"uset uber_invites_autothanks\" \"uset uber_invites_autothanks\"");
	# Edit Section
	Xchat::command("menu ADD \"UberScript/Edit Files\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Change Editor-$uber_editor\"  \"uber_getstr_editor\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Slaps\"         \"exec $uber_editor $uber_path$uber_slapfile\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Gives\"         \"exec $uber_editor $uber_path$uber_givefile\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Greetings\"     \"exec $uber_editor $uber_path$uber_greetingfile\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Quits\" \"exec $uber_editor $uber_path$uber_quit_messages\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Parts\" \"exec $uber_editor $uber_path$uber_part_messages\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Favourites\" \"exec $uber_editor $uber_path$uber_favouritesfile\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit Quickstrings\" \"exec $uber_editor $uber_path$uber_quickstringsfile\"");
	Xchat::command("menu ADD \"UberScript/Edit Files/Edit UberScript.pl\" \"exec $uber_editor $uber_path$uber_selffile\"");
	# Misc Section
	Xchat::command("menu ADD \"UberScript/Misc\"");
	Xchat::command("menu -t$uber_random_quits ADD \"UberScript/Misc/Enable Random Quits\"  \"uset uber_random_quits\"  \"uset uber_random_quits\"");
	Xchat::command("menu -t$uber_random_parts ADD \"UberScript/Misc/Enable Random Parts\"  \"uset uber_random_parts\"  \"uset uber_random_parts\"");
	Xchat::command("menu -t$uber_greetings_enabled ADD \"UberScript/Misc/Enable Greetings\"  \"uset uber_greetings_enabled\"  \"uset uber_greetings_enabled\"");
	Xchat::command("menu -t$uber_system_menu ADD \"UberScript/Misc/System Menu\"  \"uset uber_system_menu\"  \"uset uber_system_menu\"");
	
	# 
	Xchat::command("menu ADD \"UberScript/-");
	# Some Quotes
	Xchat::command("menu ADD \"UberScript/Quotes\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Monty Python\"         \"uberquote quotes/python.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/BOFH\"         \"uberquote quotes/bofh.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Discworld\"         \"uberquote quotes/disc.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Duke Nukem\"         \"uberquote quotes/duke.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Facts\"         \"uberquote quotes/facts.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Morbid Facts\"         \"uberquote quotes/morbid.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Family Guy\"         \"uberquote quotes/familyguy.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Jokes\"         \"uberquote quotes/jokes.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Similes\"         \"uberquote quotes/metaphor.txt\"");
	Xchat::command("menu ADD \"UberScript/Quotes/Stephen Wright\"         \"uberquote quotes/wright.txt\"");
	#
	Xchat::command("menu ADD \"UberScript/-");
	# 	Add favourites
	uber_favmenu_redraw();
}

sub uber_uset {
	my $uset_whole_line = $_[1][1];
	chomp $uset_whole_line;
	# Before we go further, stop if line contains bad things
	if ($uset_whole_line =~ /,/) { uber_msg("Input contains a comma, this will break the config file. Please retry."); return Xchat::EAT_XCHAT; }
	my $uset_cmd = $_[0][1];
	my $uset_val1 = $_[0][2];  
	my $uset_val2 = $_[0][3];
	my $uber_reloadmenu=0;
	my $uber_knownstring=0;
	if (!$uset_cmd) { # Called without argument, show list.
		uber_msg("Uberscript's Uset called with no arguement, showing list."); 
		uber_msg("To change Toggles - /USET function");
		uber_msg("--------------------------------------------");
		uber_msg("\002uber_buttons\002 = $uber_buttons  (Toggle userlist buttons)");
		uber_msg("\002uber_menu\002 = $uber_menu  (Toggle Top menu)");
		uber_msg("\002uber_path\002 = $uber_path  (Path to textfiles)");
		uber_msg("\002uber_editor\002 = $uber_editor  (Editor to use with edit buttons)");
		uber_msg("\002uber_triggers_enabled\002 = $uber_triggers_enabled  (Toggle Triggers)");
		uber_msg("\002uber_trigger_macro_scanning\002 = $uber_trigger_macro_scanning  (Expand macros in incoming text)");
		uber_msg("\002uber_triggerfile\002 = $uber_triggerfile  (Text file containing triggers)");
		uber_msg("\002uber_ignore_channels\002 = @uber_ignore_channels  (Comma-seperated list of channels to ignore)");
		uber_msg("\002uber_hide_joinpart\002 = $uber_hide_joinpart  (Toggle whether Joins/Parts are shown)");
		uber_msg("\002uber_hide_nickchanges\002 = $uber_hide_nickchanges  (Toggle whether Nick Changes are shown)");
		uber_msg("\002uber_hide_modechanges\002 = $uber_hide_modechanges  (Toggle whether mode Changes are shown)");
		uber_msg("\002uber_hidejunk\002 = $uber_hidejunk (Toggles whether Junk strings are shown)");
		uber_msg("\002uber_junkstrings\002 = @uber_junkstrings (List of strings to filter as Junk (See above))");
		uber_msg("\002uber_peak_enabled\002 = $uber_peak_enabled  (Enable Channel Peak monitoring)");
		uber_msg("\002uber_peak_announce\002 = $uber_peak_announce  (Enable Channel Peak Announcements)");
		uber_msg("\002uber_peak_datfile\002 = $uber_peak_datfile  (Channel Peak Datafile)");		
		uber_msg("\002uber_random_quits\002 = $uber_random_quits  (Toggle Random Quits)");
		uber_msg("\002uber_quit_messages\002 = $uber_quit_messages  (File of random quit messages)");
		uber_msg("\002uber_random_parts\002 = $uber_random_parts  (Toggle Random Parts)");
		uber_msg("\002uber_part_messages\002 = $uber_part_messages  (File of random part messages)");
		uber_msg("\002uber_greetings_enabled\002 = $uber_greetings_enabled  (Toggle the Greetings and Auto-Op/Voice system)");
		uber_msg("\002uber_greetingfile\002 = $uber_greetingfile  (The Greeting system configuration file)");
		uber_msg("\002uber_Q_auth_toggle\002 = $uber_Q_auth_toggle  (Toggle Quakenet Authing)");
		uber_msg("\002uber_Q_auth_name\002 = $uber_Q_auth_name  (Quakenet Auth Name)");
		uber_msg("\002uber_Q_auth_pass\002 = *******  (Quakenet Auth Password)");
		uber_msg("\002uber_ctcp_versions\002 = $uber_ctcp_versions  (Toggle random CTCP Version replies)");
		uber_msg("\002uber_ctcp_version_file\002 = $uber_ctcp_version_file  (Random CTCP Version file)");
		uber_msg("\002uber_ctcp_announcements\002 = $uber_ctcp_announcements  (Be told when somebody CTCP's you)");
		uber_msg("\002uber_away_randoms\002 = $uber_away_randoms  (Random Away Messages)");
		uber_msg("\002uber_away_random_file\002 = $uber_away_random_file  (Random Away File)");
		uber_msg("\002uber_pm_autoreply\002 = $uber_pm_autoreply  (PM Autoreply (Here))");
		uber_msg("\002uber_pm_autoreply_away\002 = $uber_pm_autoreply_away  (PM Autoreply (Away))");
		uber_msg("\002uber_pm_autoreply_message\002 = $uber_pm_autoreply_message  (PM Autoreply Message)");
		uber_msg("\002uber_invites_autojoin\002 = $uber_invites_autojoin  (Toggle Autojoin on Invite)");
		uber_msg("\002uber_invites_autothanks\002 = $uber_invites_autothanks  (Toggle Thanks on Invite)");
		uber_msg("\002uber_regain_nick\002 = $uber_regain_nick  (Regain Nick)");
		uber_msg("\002uber_sillystuff_enabled\002 = $uber_sillystuff_enabled  (Toggle Silly Stuff)");
		uber_msg("\002uber_slapfile\002 = $uber_slapfile  (Text file containing slaps)");
		uber_msg("\002uber_givefile\002 = $uber_givefile  (Text file containing gives)");
		uber_msg("\002uber_session_saving\002 = $uber_session_saving  (Toggle Session Saving)");
		uber_msg("\002uber_session_throttle\002 = $uber_session_throttle  (Session Saver Throttle value)");
		uber_msg("\002uber_quotesfile\002 = $uber_quotesfile  (Default Quotes file)");
		uber_msg("\002uber_favouritesu\002 = $uber_favourites  (Toggle Favourites List)");
		uber_msg("\002uber_favouritesfile\002 = $uber_favouritesfile  (Favourites File)");
		uber_msg("\002uber_fav_buttons\002 = $uber_fav_buttons  (Toggles Favourites buttons)");
		uber_msg("\002uber_quickstrings\002 = $uber_quickstrings  (Quickstrings Toggle)");
		uber_msg("\002uber_quickstringsfile\002 = $uber_quickstringsfile  (Quickstrings filename)");
		uber_msg("\002uber_system_menu\002 = $uber_system_menu  (Toggle System menu)");
		uber_msg("--------------------------------------------");
		uber_msg("Useful commands for UberScript");
		uber_msg("\002/uber_rehash\002 = Deletes saved configuration and restarts script using script-defaults");
		uber_msg("\002/uc Stuff\002 = Says Stuff in pretty colours");
		uber_msg("--------------------------------------------");
		} else {
		# Simple toggles:
		if (lc($uset_cmd) eq 'uber_buttons') { if ($uber_buttons eq 0) { $uber_buttons=1; uber_add_buttons(); } else { $uber_buttons=0; uber_remove_buttons(); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_menu') {  if ($uber_menu eq 0) { $uber_menu=1; uber_add_menu(); } else { $uber_menu=0; uber_remove_menu(); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_hide_joinpart') {  if ($uber_hide_joinpart eq 0) { $uber_hide_joinpart=1; uber_msg("Joins/parts now Hidden"); } else { $uber_hide_joinpart=0; uber_msg("Joins/parts now Shown"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_hide_nickchanges') {  if ($uber_hide_nickchanges eq 0) { $uber_hide_nickchanges=1; uber_msg("Nick Changes now Hidden"); } else { $uber_hide_nickchanges=0; uber_msg("Nick Changes now Shown"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_hide_modechanges') {  if ($uber_hide_modechanges eq 0) { $uber_hide_modechanges=1; uber_msg("Mode Changes now Hidden"); } else { $uber_hide_modechanges=0; uber_msg("Mode Changes now Shown"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_hidejunk') {  if ($uber_hidejunk eq 0) { $uber_hidejunk=1; uber_msg("Junk strings now Hidden"); } else { $uber_hidejunk=0; uber_msg("Junk strings now Shown"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_peak_enabled') {  if ($uber_peak_enabled eq 0) { $uber_peak_enabled=1; uber_msg("Channel peaks now monitored"); } else { $uber_peak_enabled=0; uber_msg("Channel peaks unmonitored"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_random_quits') {  if ($uber_random_quits eq 0) { $uber_random_quits=1; uber_msg("Random Quits now active"); uber_pick_random_quit(); } else { $uber_random_quits=0; uber_msg("Random quits unset"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_random_parts') {  if ($uber_random_parts eq 0) { $uber_random_parts=1; uber_msg("Random Part Messages now active"); uber_pick_random_part(); } else { $uber_random_parts=0; uber_msg("Random Part Messages now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_greetings_enabled') {  if ($uber_greetings_enabled eq 0) { $uber_greetings_enabled=1; uber_msg("Greeting system now active"); } else { $uber_greetings_enabled=0; uber_msg("Greeting system inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_peak_announce') {  if ($uber_peak_announce eq 0) { $uber_peak_announce=1; uber_msg("Peak Announcements now active"); } else { $uber_peak_announce=0; uber_msg("Peak Announcements now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_q_auth_toggle') {  if ($uber_Q_auth_toggle eq 0) { $uber_Q_auth_toggle=1; uber_msg("Quakenet Authing now active"); } else { $uber_Q_auth_toggle=0; uber_msg("Quakenet Authing now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_ctcp_versions') {  if ($uber_ctcp_versions eq 0) { $uber_ctcp_versions=1; uber_msg("Random CTCP Versions now active"); } else { $uber_ctcp_versions=0; uber_msg("Random CTCP Versions now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_ctcp_announcements') {  if ($uber_ctcp_announcements eq 0) { $uber_ctcp_announcements=1; uber_msg("CTCP VERSIONs announced"); } else { $uber_ctcp_announcements=0; uber_msg("CTCP VERSIONS now hidden"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_away_randoms') {  if ($uber_away_randoms eq 0) { $uber_away_randoms=1; uber_msg("Random Aways now active"); } else { $uber_away_randoms=0; uber_msg("Random Aways now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_pm_autoreply') {  if ($uber_pm_autoreply eq 0) { $uber_pm_autoreply=1; uber_msg("PM Autoreply (Here) now active"); } else { $uber_pm_autoreply=0; uber_msg("PM Autoreply (Here) now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_pm_autoreply_away') {  if ($uber_pm_autoreply_away eq 0) { $uber_pm_autoreply_away=1; uber_msg("PM Autoreply (Away) now active"); } else { $uber_pm_autoreply_away=0; uber_msg("PM Autoreply (Away) now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_triggers_enabled') {  if ($uber_triggers_enabled eq 0) { $uber_triggers_enabled=1; uber_msg("Triggers now active"); } else { $uber_triggers_enabled=0; uber_msg("Triggers now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_sillystuff_enabled') {  if ($uber_sillystuff_enabled eq 0) { $uber_sillystuff_enabled=1; uber_msg("Fun Stuff now active"); } else { $uber_sillystuff_enabled=0; uber_msg("Fun Stuff now inactive"); } $uber_reloadmenu=1;  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_invites_autojoin') {  if ($uber_invites_autojoin eq 0) { $uber_invites_autojoin=1; uber_msg("Will now join channels when invited"); } else { $uber_invites_autojoin=0; uber_msg("Will now NOT join channels when invited"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_invites_autothanks') {  if ($uber_invites_autothanks eq 0) { $uber_invites_autothanks=1; uber_msg("Will now thank user on invite"); } else { $uber_invites_autothanks=0; uber_msg("Will now not thank user on invite"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_regain_nick') {  if ($uber_regain_nick eq 0) { $uber_regain_nick=1; uber_msg("Nick Regain now active"); $uber_ison_timer=Xchat::hook_timer($uber_ison_cycle,"uber_regain_nick");  uber_regain_nick(); } else { $uber_regain_nick=0; uber_msg("Nick Regain now inactive"); Xchat::unhook($uber_ison_timer); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_trigger_macro_scanning') {  if ($uber_trigger_macro_scanning eq 0) { $uber_trigger_macro_scanning=1; uber_msg("Incoming macro scanning now active"); } else { $uber_trigger_macro_scanning=0; uber_msg("Incoming macro scanning now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_favourites') {  if ($uber_favourites eq 0) { $uber_favourites=1; uber_msg("Favourites List now active"); } else { $uber_favourites=0; uber_msg("Favourites List now inactive"); } uber_favmenu_redraw(); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_quickstrings') {  if ($uber_quickstrings eq 0) { $uber_quickstrings=1; uber_msg("Quickstrings now active"); } else { $uber_quickstrings=0; uber_msg("Quickstrings now inactive"); } uber_favmenu_redraw(); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_fav_buttons') {  if ($uber_fav_buttons eq 0) { $uber_fav_buttons=1; uber_msg("Favourites Buttons now active"); } else { $uber_fav_buttons=0; uber_msg("Favourites Buttons now inactive"); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_system_menu') {  if ($uber_system_menu eq 0) { $uber_system_menu=1; uber_msg("System Menu now active"); uber_draw_system_menu(); } else { $uber_system_menu=0; uber_msg("System Menu now inactive"); uber_remove_system_menu(); }  $uber_knownstring=1;}
#		if (lc($uset_cmd) eq '___________') {  if ($___________ eq 0) { $___________=1; uber_msg("___________ now active"); } else { $___________=0; uber_msg("___________ now inactive"); }  $uber_knownstring=1;}

		# Non-working session stuff, come back to later.
#		if (lc($uset_cmd) eq 'uber_session_saving') {  if ($uber_session_saving eq 0) { $uber_session_saving=1; uber_msg("Session Saving now active"); $uber_session_timer=Xchat::hook_timer($uber_session_cycle,"uber_session_saver"); } else { $uber_session_saving=0; uber_msg("Session Saving now inactive"); Xchat::unhook($uber_session_timer); }  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_session_saving') {  if ($uber_session_saving eq 0) { $uber_session_saving=0; uber_msg("Session Saving non-functional."); } else { $uber_session_saving=0; uber_msg("Session Saving now inactive"); Xchat::unhook($uber_session_timer); }  $uber_knownstring=1;}

		# Change strings (1 value)
		if (lc($uset_cmd) eq 'uber_editor') {  $uber_editor = $uset_val1; uber_msg("uber_editor now set to '$uber_editor'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_triggerfile') {  $uber_triggerfile = $uset_val1; uber_msg("uber_triggerfile now set to '$uber_triggerfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_greetingfile') {  $uber_greetingfile = $uset_val1; uber_msg("uber_greetingfile now set to '$uber_greetingfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_Q_auth_name') {  $uber_Q_auth_name = $uset_val1; uber_msg("uber_Q_auth_name now set to '$uber_Q_auth_name'");  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_Q_auth_pass') {  $uber_Q_auth_pass = $uset_val1; uber_msg("uber_Q_auth_pass now set to '$uber_Q_auth_pass'");  $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_ctcp_version_file') {  $uber_ctcp_version_file = $uset_val1; uber_msg("uber_ctcp_version_file now set to '$uber_ctcp_version_file'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_away_random_file') {  $uber_away_random_file = $uset_val1; uber_msg("uber_away_random_file now set to '$uber_away_random_file'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_slapfile') {  $uber_slapfile = $uset_val1; uber_msg("uber_slapfile now set to '$uber_slapfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_givefile') {  $uber_givefile = $uset_val1; uber_msg("uber_givefile now set to '$uber_givefile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_quotesfile') {  $uber_quotesfile = $uset_val1; uber_msg("uber_quotesfile now set to '$uber_quotesfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_session_throttle') {  $uber_session_throttle = $uset_val1; uber_msg("uber_session_throttle now set to '$uber_session_throttle'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_session_config') {  $uber_session_config = $uset_val1; uber_msg("uber_session_config now set to '$uber_session_config'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_favouritesfile') {  $uber_favouritesfile = $uset_val1; uber_msg("uber_favouritesfile now set to '$uber_favouritesfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_quickstringsfile') {  $uber_editor = $uset_val1; uber_msg("uber_quickstringsfile now set to '$uber_quickstringsfile'"); $uber_quickstringsfile=1;}
		if (lc($uset_cmd) eq 'uber_quotesfile') {  $uber_quotesfile = $uset_val1; uber_msg("uber_quotesfile now set to '$uber_quotesfile'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_quit_messages') {  $uber_quit_messages = $uset_val1; uber_msg("uber_quit_messages now set to '$uber_quit_messages'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_part_messages') {  $uber_part_messages = $uset_val1; uber_msg("uber_part_messages now set to '$uber_part_messages'"); $uber_knownstring=1;}
		if (lc($uset_cmd) eq 'uber_peak_datfile') {  $uber_peak_datfile = $uset_val1; uber_msg("uber_peak_datfile now set to '$uber_peak_datfile'"); $uber_knownstring=1;}
#		if (lc($uset_cmd) eq 'uber_editor') {  $uber_editor = $uset_val1; uber_msg("uber_editor now set to '$uber_editor'"); $uber_knownstring=1;}

		# Change strings (multi-value) 
		if (lc($uset_cmd) eq 'uber_pm_autoreply_message') { 
			my $uber_tmp = index($uset_whole_line," ");
			$uber_pm_autoreply_message = substr($uset_whole_line,$uber_tmp+1); # Seek to first space +1
			uber_msg("uber_pm_autoreply_message set to \"$uber_pm_autoreply_message\"");
			}

		# More complex ones, change files etc. 
		uber_save_config();
		# Because the above may have changed the menu values, reload them
		if ($uber_reloadmenu eq 1) {
			uber_remove_buttons(); # Remove all buttons first so they don't get left behind if option disabled
			if ($uber_buttons eq 1) { uber_add_buttons(); } # If set, load buttons
			if ($uber_menu eq 1) { uber_add_menu(); }
			}
		if ($uber_knownstring eq 0) { uber_msg("UberScript doesn't understand uset value '$uset_cmd'"); }
		return Xchat::EAT_XCHAT;
		}
	}

sub uber_msg { 	Xchat::print"\002UberScript:\002 " . shift ; }

sub uber_rehash_config { 
	uber_msg("Resetting config from defaults in: \"$uber_path$uber_selffile\" (Deleting config and reloading self)");
	unlink("$uber_path/UberScript.cfg");	
	Xchat::command("timer 1 reload $uber_path$uber_selffile"); # Can't reload from within own script or we create a loop and Xchat goes bye-bye
	}

sub uber_give { # Give person random item	
	if ($uber_sillystuff_enabled eq 0) { return Xchat::EAT_XCHAT; }
	my $secondparty = shift;
	my $thirdparty = undef;
	if (ref($secondparty) eq 'ARRAY') {  # It came from /uber
		$secondparty = $_[0][1];
		$thirdparty = $_[0][2];
		} else { 
			$secondparty = shift;
			$thirdparty = shift;
		}
	$secondparty = 'Nobody' unless defined $secondparty;
	my $line;
	my $content = "me gives ";
	if (defined $thirdparty) { $content .= "$thirdparty "; } 
		else { $content .= $secondparty .= " "; } 
	open (IN, "<$uber_path$uber_givefile") or ( $content .= "a broken installation of UberScript!");
	rand($.) < 1 && ($line = $_) while <IN>; # Pick random line
	close(IN);
	chomp($line);
	$content .= "$line";
	Xchat::command($content);
	return Xchat::EAT_XCHAT;
}

sub uber_slap {	
	if ($uber_sillystuff_enabled eq 0) { return Xchat::EAT_XCHAT; }
	my $secondparty = shift;
	my $thirdparty = undef;
	if (ref($secondparty) eq 'ARRAY') {  # It came from /uber
		$secondparty = $_[0][1];
		$thirdparty = $_[0][2];
		} else { 
			$secondparty = shift;
			$thirdparty = shift;
		}
	$secondparty = 'Nobody' unless defined $secondparty;
	my $line;
	my $content = "me slaps ";
	if (defined $thirdparty) { $content .= "$thirdparty "; } 
		else { $content .= $secondparty ; } 
	$content .= " around the head with ";
	open (IN, "<$uber_path$uber_givefile") or ( $content .= "a broken installation of UberScript!");
	rand($.) < 1 && ($line = $_) while <IN>; # Pick random line
	close(IN);
	chomp($line);
	$content .= "$line";
	Xchat::command("timer $content");
	return Xchat::EAT_XCHAT;
}

sub uber_join_filter { # Hide joins/parts if toggled
	##################### Peak control
	if ($uber_peak_enabled) { # If peak monitoring enabled, log all joins. Check against existing dbase for channel and update if neccessary.
		# Created Peak file format: #channel,Peak,UnixDateString,NickOfPeakAchiever
		my $uber_stored_peak='';
		my $uber_currpeak=Xchat::get_list('users')+1; # Xchat doesn't include self when getting usercount, so is always one short
		my $uber_currachiever=$_[0][0];
		my $channel = $_[0][1];		
		my $uber_lastpeaktime=0;
		my $uber_lastpeakachiever=' ';
		my $uber_peak_found=0;
		open (PF, "<$uber_path$uber_peak_datfile");
		while (<PF>) {
			my @line = split(/,/);
			if ($line[0] eq $channel) { $uber_stored_peak = $line[1]; $uber_lastpeaktime=$line[2]; $uber_lastpeakachiever = $line[3]; $uber_peak_found++;  }
			}
		close (PF);
		if (($uber_currpeak gt $uber_stored_peak) or ($uber_peak_found eq 0)) { # New peak or new channel, announce and save
			if ($uber_peak_announce) { uber_say("Welcome $uber_currachiever! You have achieved a new peak of $uber_currpeak users for $channel!"); }
			# Now save info in datfile
			open (PFTMP,">$uber_tempfile");
			open (PF,"<$uber_path$uber_peak_datfile");
			while (<PF>) {
				my @line2 = split(/,/);
				if ($line2[0] eq $channel) { print(PFTMP "$channel,$uber_currpeak," . time() . ",$uber_currachiever\n"); } else { print (PFTMP); }
				}
			if ($uber_peak_found eq 0) { print (PFTMP "$channel,$uber_currpeak," . time() . ",$uber_currachiever\n"); }
			close(PF);
			close(PFTMP);
			unlink("$uber_path$uber_peak_datfile");
			rename("$uber_tempfile","$uber_path$uber_peak_datfile"); # Copy temp file to new file.
			}
		}
	####################### Welcome/Greeting Control (including auto-op/voice)
	if ($uber_greetings_enabled) {	
		$uber_nick = $_[0][0];
		$uber_line = $_[0][1];
		$uber_orig_line = $_[0][1];
		$uber_chan = Xchat::get_info('channel');
		uber_load_greetings(); # Reload greetings if required
		# Check against configuration

		$utmp_ignore_next=1; # Stop details being overriden temporarily  (Causes perl errors)
		foreach  (@uber_greetings) {  # nick|#channel|action
			chomp;
			my @ub_ga = split(/\|/,);
			if (@ub_ga)  {# No nick 
				if (($ub_ga[0] eq $uber_nick) or ($ub_ga[0] eq '*')) { # Nick match, or wildcard
					if (($ub_ga[1] eq $uber_chan) or ($ub_ga[1] eq '*')) { # Right channel, or wildcard, let's perform the function.
						uber_command($ub_ga[2]);
						$utmp_ignore_next=1;
						} # End channel match
					} # End nick match
				}
			}
		$utmp_ignore_next=0; # Stop details being overriden temporarily
		}
	####################### Join/part Filter
	if ($uber_hide_joinpart) { return Xchat::EAT_XCHAT; } else { return Xchat::EAT_NONE; }
	}

sub uber_peak_response { # Give response to !peak
	# Created Peak file format: #channel,Tot_Number,UnixDateString,NickOfPeakAchiever
	my $channel = Xchat::get_info('channel');
	my $uber_peak_tot;
	my $uber_peak_time;
	my $uber_peak_achiever;
	open (PF, "<$uber_path$uber_peak_datfile");
	my $uber_peak_found=0;
	while (<PF>) {
		chomp;
		my @line = split(/,/);
		if ($line[0] eq $channel) { 
			$uber_peak_found++;
			uber_say("$channel achieved a max peak of $line[1] users by $line[3] on " . localtime($line[2]) .".");
			}
		}
	close(PF);
	if ($uber_peak_found eq 0) { uber_say("Sorry, I have no peak information for $channel"); }
	return Xchat::EAT_XCHAT;
	}

sub uber_part_filter {
	if ($uber_hide_joinpart) { return Xchat::EAT_XCHAT; } else { return Xchat::EAT_NONE; }
	}

sub uber_nickchanger_filter { # Hide nick changes if so toggled
	if ($uber_hide_nickchanges) { return Xchat::EAT_XCHAT; } else { return Xchat::EAT_NONE; }
	}

sub uber_modechanger_filter { # Hide mode changes if so toggled
	if ($uber_hide_modechanges) { return Xchat::EAT_XCHAT; } else { return Xchat::EAT_NONE; }
	}

sub uber_quote { # Quotes/jokes.  Takes filename and expects to find that file in $uber_path. 	
	my $quotefile = shift;
	if ($uber_sillystuff_enabled eq 0) { return Xchat::EAT_XCHAT;; }
	my $thirdparty;
	my $line;
	if ($quotefile ne 'trigger') { # It came from /uber... and not from a trigger.
		$quotefile = $_[0][1];
		} else { $thirdparty=shift; $quotefile = shift;  }
	if (!$quotefile) { $quotefile = $uber_quotesfile; }  # Default quotefile

	open (IN, "<$uber_path$quotefile");
	if (defined fileno IN) {
		rand($.) < 1 && ($line = $_) while <IN>; # Pick random line
		close(IN);
		chomp($line);
		}
	if ($line) { uber_say($line); } else { uber_msg("Can't open quote file $uber_path$quotefile"); }
}

sub uber_say { # Output string to current channel 
	my $channel = Xchat::get_info('channel');
	foreach(@uber_ignore_channels) {
		if ($channel eq $_) { return Xchat::EAT_NONE; } # Abort
		}
	Xchat::command(uber_parse("say " . shift));
}

sub uber_command { # Output string to current channel without /
	my $channel = Xchat::get_info('channel');
	foreach(@uber_ignore_channels) {
		if ($channel eq $_) { return Xchat::EAT_NONE; } # Abort
		}
	Xchat::command(uber_parse(shift));
}

sub uber_pick_random_quit {
	my $line3;
	open (IN, "<$uber_path$uber_quit_messages") or ( $line3 .= "I didn't set up UberScript properly!");
	rand($.) < 1 && ($line3 = $_) while <IN>; # Pick random line
	close(IN);
	chomp($line3);
	Xchat::command(uber_parse("set -quiet irc_quit_reason $line3"));
}

sub uber_pick_random_part {
	my $uprp;
	open (IN, "<$uber_path$uber_part_messages") or ( $uprp .= "I didn't set up UberScript properly!");
	rand($.) < 1 && ($uprp = $_) while <IN>; # Pick random line
	close(IN);
	chomp($uprp);
	Xchat::command(uber_parse("set -quiet irc_part_reason $uprp"));
}

sub uber_random_ctcp_version_respond {
	$uber_nick = $_[0][1];
	my $ctcp_type = $_[0][0];
	my $line4;
	if ($ctcp_type ne 'VERSION') { return Xchat::EAT_NONE; } 	# First check it's actually a VERSION
	open (IN, "<$uber_path$uber_ctcp_version_file") or ( $line4 .= "My CTCP Version is my own affair");
	rand($.) < 1 && ($line4 = $_) while <IN>; # Pick random line
	close(IN);
	chomp($line4);
	uber_msg("CTCP Version request by $uber_nick - sending '$line4'");
	Xchat::command(uber_parse("NCTCP $uber_nick VERSION $line4"));
}

sub uber_parse { # Parse incoming string and replace tokens with various things.	
	my $line = shift;
	if (!$line) { $line=" "; }
	my @users = map { $_->{nick} } Xchat::get_list("users");
	if (@users = '') { $users[0]='Nobody'; } # No users, probably in a query
	my @split_line = split(/ /,$line);
	my @days=('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime();
	my $ut_nick=Xchat::get_info('nick');
	my $ut_server=Xchat::get_info('server');
	my $ut_network=Xchat::get_info('network');
	my $ut_away=Xchat::get_info('away');
	# To stop perl whining, we need to check Xchat hasn't returned null values
	if (!$ut_network) { $ut_network="Unknown"; }
	if (!$ut_away) { $ut_away="Unknown"; } 
	if (!$ut_server) { $ut_server="Not Connected"; }
	if (!$split_line[0]) { $split_line[0]=' '; }
	if (!$split_line[1]) { $split_line[1]=' '; }
	if (!$split_line[2]) { $split_line[2]=' '; }
	if (!$split_line[3]) { $split_line[3]=' '; }
	if (!$split_line[4]) { $split_line[4]=' '; }
	if (!$split_line[5]) { $split_line[5]=' '; }
	$line =~ s/%l/$uber_line/gi;  # %l = Line of text
	$line =~ s/%n/$uber_nick/gi;  # %n = Nick of third person. 
	$line =~ s/%m/$ut_nick/gi;  # %m = My current nick
	$line =~ s/%s/$ut_server/gi;  # %s = Current server
	$line =~ s/%e/$ut_network/gi;  # %e = Current network 
	$line =~ s/%t/$uber_orig_line/gi;  # %t = Topic of current channel
	$line =~ s/%c/$uber_chan/gi;	# %c = Current channel
	$line =~ s/%r/$ut_away/gi;  # %r = Your away reason
	$line =~ s/%u/$users[rand int(@users)]/gi;  # %u = Random user in the current channel.
	$line =~ s/%1/$split_line[0]/gi;  # %1 = First word in line.
	$line =~ s/%2/$split_line[1]/gi;  # %2 = Second word in line.
	$line =~ s/%3/$split_line[2]/gi;  # %3 = Third word in line. 
	$line =~ s/%4/$split_line[3]/gi;  # %4 = Fourth word in line.
	$line =~ s/%5/$split_line[4]/gi;  # %5 = Fifth word in line.
	$line =~ s/%6/$split_line[5]/gi;  # %6 = Sixth word in line.
	$line =~ s/%i/"$hour:$min.$sec"/gi;  # %i = Current time. HH:MM.S
	$line =~ s/%d/"$mday\/$mon\/$year+1970"/gi;  # %d = Current date: Day/Mon/Year
	$line =~ s/%w/$days[$wday]/gi;  # %w = Current day of the week. Monday, Tuesday etc.
	if (($line =~ /%h/) or ($line =~ /%a/))  {  # Want channel/server info 
			my @ub_test = map { $_->{channel} } Xchat::get_list("channels");
			my $uber_chancnt=0;
			my $uber_pmcnt=0;
			foreach (@ub_test) {
				if ($_ =~ /#/) { $uber_chancnt++; } else { $uber_pmcnt++; } # It's a channel, not a pm
				}
			$line =~ s/%h/$uber_chancnt/gi; # %h = Number of channels I'm in
			$line =~ s/%a/$uber_pmcnt/gi;   # %a = Number of queries I have open.
			}
	return $line;
}

sub uber_colour { # say something in pretty colours
	my $i=0;	
	$_ = $_[1][1];
	s{(.)}{"\cC" . (($i++%14)+2) . "$1"}eg;
	uber_say("\002$_");
	return Xchat::EAT_XCHAT;
}
sub uber_server_watch { # Called on messages from server. Tends not to work too well with bouncers.
	$uber_line = $_[0][0];
	if ($uber_Q_auth_toggle eq 1) { # Check to see if just connected to Quakenet, if so - try to auth.
	
		if ($uber_line =~ /Welcome to the QuakeNet/gi) { # Change this is Qnet change their welcome string
			uber_msg("Found Quakenet connection string, attempting auto-auth");
			Xchat::command("msg Q\@CServe.quakenet.org auth $uber_Q_auth_name $uber_Q_auth_pass");
			# Also add a +x to hide the IP (On quakenet this replaces your hostmask with *@authname.quakenet.org.
			# Comment following line if for some insane reason you don't want that.
			Xchat::command("umode +x");
			}
	}
	return Xchat::EAT_NONE; 
}

sub uber_pm_watch { # Called on private messages (PM - NOT CTCP/DCC CHAT)#
	$uber_nick = $_[0][0];
	if ($uber_nick eq '') { return Xchat::EAT_NONE; }
	my $uber_away_status = Xchat::get_info('away');
	if (($uber_pm_autoreply eq 1) and ( !$uber_away_status) and ($uber_last_pmer ne $uber_nick)) { # Enabled, Here and last PMer wasn't same nick
		$uber_last_pmer = $uber_nick;
		uber_command("msg $uber_nick $uber_pm_autoreply_message");
		}
	if (($uber_pm_autoreply_away eq 1) and ( $uber_away_status) and ($uber_last_pmer ne $uber_nick)) { # For /away 
		$uber_last_pmer = $uber_nick;
		uber_command("msg $uber_nick $uber_pm_autoreply_message");
		}
	return Xchat::EAT_NONE;
	}

sub uber_away { # Called when user uses /away
	if ($uber_away_randoms) { # Pick a random away message
		my $line7;
		open (IN, "<$uber_path$uber_away_random_file") or ( $line7 .= "I didn't set up UberScript properly!");
		rand($.) < 1 && ($line7 = $_) while <IN>; # Pick random line
		close(IN);
		chomp($line7);
		Xchat::command(uber_parse("set -quiet away_reason $line7"));
		}
	return Xchat::EAT_NONE;
	}

sub uber_getstr { # Used to get a string from the user ; uber_getstr(PrimeString,Action,Prompt);
	uber_command("getstr ". shift() ." " . shift() . " ".shift()."");
	}

sub uber_getstr_editor {  # Get editor string
	Xchat::command("getstr \"$uber_editor\" \"uset uber_editor \" \"Enter new text editor filename\"");	
	}

sub uber_getstr_autoreply { # get autoreply string
	Xchat::command("getstr \"$uber_pm_autoreply_message\" \"uset uber_pm_autoreply_message\" \"Enter new AutoReply String\"");	
	}

sub uber_getstr_filename { # Getstring of filename  ' Args: variable $existing_variable_value	
	Xchat::command("getstr \"$_[0][2]\" \"uset $_[0][1]\" \"Enter new filename for $_[0][2]\"");
	}

sub uber_save_config {
	open (CFG,">$uber_path/UberScript.cfg") or uber_msg("Cannot open config file $uber_path/UberScript.cfg - Configuration will NOT BE SAVED!");
	print (CFG "UberScript Configuration File,$uber_buttons,$uber_menu,$uber_hide_joinpart,$uber_hide_nickchanges,$uber_hidejunk,");
	print (CFG "$uber_peak_enabled,$uber_peak_announce,$uber_random_quits,$uber_quit_messages,$uber_triggers_enabled,");
	print (CFG "$uber_slapfile,$uber_givefile,UNUSED,$uber_triggerfile,$uber_selffile,$uber_quotesfile,$uber_editor,");
	print (CFG "$uber_greetings_enabled,$uber_greetingfile,$uber_Q_auth_toggle,$uber_Q_auth_name,$uber_Q_auth_pass,");
	print (CFG "$uber_ctcp_versions,$uber_ctcp_announcements,$uber_ctcp_version_file,$uber_away_randoms,$uber_away_random_file,");
	print (CFG "$uber_pm_autoreply,$uber_pm_autoreply_away,$uber_pm_autoreply_message,$uber_sillystuff_enabled,$uber_invites_autojoin,");
	print (CFG "$uber_invites_autothanks,$uber_regain_nick,$uber_trigger_macro_scanning,$uber_session_saving,$uber_session_throttle,");
	print (CFG "$uber_session_config,$uber_hide_modechanges,$uber_favourites,$uber_favouritesfile,$uber_quickstrings,$uber_quickstringsfile,");
	print (CFG "$uber_fav_buttons,$uber_random_parts,$uber_part_messages,$uber_system_menu,$uber_peak_datfile");
	close (CFG);
	uber_msg("Configuration saved");
	}

sub uber_load_config {
	my $uber_nocfg=0;
	open (CFG,"<$uber_path/UberScript.cfg") or $uber_nocfg = 1;
	if ($uber_nocfg eq 1) { 
		uber_msg("No existing configuration file, starting afresh!");
		uber_save_config(); # Save default values of this script as the new 
		return; 
		}
	my $configstr;
	my @cfgarr = split(/,/,<CFG>);
	($configstr,$uber_buttons,$uber_menu,$uber_hide_joinpart,$uber_hide_nickchanges,$uber_hidejunk,
	$uber_peak_enabled,$uber_peak_announce,$uber_random_quits,$uber_quit_messages,$uber_triggers_enabled,
	$uber_slapfile,$uber_givefile,$utmpline,$uber_triggerfile,$uber_selffile,$uber_quotesfile,$uber_editor,
	$uber_greetings_enabled,$uber_greetingfile,$uber_Q_auth_toggle,$uber_Q_auth_name,$uber_Q_auth_pass,
	$uber_ctcp_versions,$uber_ctcp_announcements,$uber_ctcp_version_file,$uber_away_randoms,$uber_away_random_file,
	$uber_pm_autoreply,$uber_pm_autoreply_away,$uber_pm_autoreply_message,$uber_sillystuff_enabled,$uber_invites_autojoin,
	$uber_invites_autothanks,$uber_regain_nick,$uber_trigger_macro_scanning,$uber_session_saving,$uber_session_throttle,
	$uber_session_config,$uber_hide_modechanges,$uber_favourites,$uber_favouritesfile,$uber_quickstrings,$uber_quickstringsfile,
	$uber_fav_buttons,$uber_random_parts,$uber_part_messages,$uber_system_menu,$uber_peak_datfile)=@cfgarr;
	if ($configstr ne 'UberScript Configuration File') { uber_msg("WARNING! Corrupt UberScript config file, settings are probably hosed!"); }
	close (CFG);
}

sub uber_startup {
	# Startup code and checks.
	# Some sanity checks BEFORE saving new config
	if ($uber_pm_autoreply_message =~ /,/) { uber_msg("Warning! uber_pm_autoreply_message contains a comma, THIS BREAKS THE CONFIGURATION FILE AND WILL CAUSE MANY BAD THINGS! (Changed)"); $uber_pm_autoreply_message="Please tell me to fix my UberScript configuration"; }

	uber_load_config(); # Load configuration if one exists
	uber_remove_buttons(); # Remove all buttons first so they don't get left behind if option disabled
	uber_remove_menu(); # Same for menu
	uber_remove_system_menu(); # Remove system menu
	if ($uber_system_menu eq 1) { uber_draw_system_menu(); } # Draw system menu
	if ($uber_buttons eq 1)	{ uber_add_buttons(); } # If set, load buttons
	if ($uber_menu eq 1)	{ uber_add_menu(); }  # If set, load menu
	if ($uber_random_quits eq 1) { uber_pick_random_quit(); } # Prime quit message on start since we can't set it on quit.
	if ($uber_random_parts eq 1) { uber_pick_random_part(); } # Set random part message
	if ($uber_ctcp_versions eq 1) { Xchat::command("set -quiet irc_hide_version on"); } # To ensure we don't send real version

	my $uber_xv = Xchat::get_info('version');
	$uber_xv =~ s/\.//g; 
	if ($uber_xv lt 245) { uber_msg("Warning! Menu functions will not work until you upgrade X-Chat to 2.4.5 or later. Currently: V." . Xchat::get_info('version') .""); }

	# Create timer for Nick-regain if enabled
	if ($uber_regain_nick eq 1) {  $uber_ison_timer=Xchat::hook_timer($uber_ison_cycle,"uber_regain_nick");  uber_regain_nick(); }
	# Create timer for uber_session_saver if enabled
	if ($uber_session_saving eq 1) { $uber_session_timer=Xchat::hook_timer($uber_session_cycle,"uber_session_saver"); }

	if ($uber_favourites ne 0) { uber_loadfavs(); } # Load favourites and redraw menu
	if ($uber_quickstrings ne 0) { uber_loadquicks(); } # Load quicklists and redraw menu
	}

sub uber_invites { # Autojoin channels when invited
#		uber_msg("Output: $_[0][0],$_[0][1],$_[0][2],$_[0][3],$_[0][4],$_[0][5],");
	if ($uber_invites_autojoin eq 1) {
		uber_command("join $_[0][0]"); # Join Chan
		}
	if ($uber_invites_autothanks) {
		if ($uber_invites_autojoin) {
			uber_command("msg $_[0][1] Thank you for the invite $_[0][1], I will join $_[0][0]");
		} else {
			uber_command("msg $_[0][1] Thank you for the invite $_[0][1], but I am not automatically joining channels just now.");
		}
	}
	return Xchat::EAT_NONE;
}

sub uber_regain_nick { # Called once a minute if enabled to check current nick and if not as prefs, try to regain
	# Check nick is as wanted
	if ($uber_regain_nick == 0) { Xchat::unhook($uber_ison_timer); } # Cancel timer
	my $uber_primary_nick=Xchat::get_prefs('irc_nick1');
	my $uber_current_nick=Xchat::get_info('nick'); 
	if ($uber_primary_nick ne $uber_current_nick) {
		$uber_regaining_nick =1;
		uber_command("ison $uber_primary_nick");
		}
	}

sub uber_ison_handler {
	my $uber_primary_nick=Xchat::get_prefs('irc_nick1');
	if ($uber_regaining_nick == 0) { return Xchat::EAT_XCHAT; } # It's been turned off. Return to break loop
	if (!$_[0][3]) { return Xchat::EAT_XCHAT; }
	if (lc($_[0][3]) ne lc(":$uber_primary_nick")) {
		uber_msg("Nick $uber_primary_nick appears to be free, attempting to take it...");
		uber_command("nick $uber_primary_nick");
		# Stop timer and loop
		$uber_regaining_nick=0;
		Xchat::unhook($uber_ison_timer); 
		} else { 1; }
	}

sub uber_load_triggers {
	if ($uber_triggers_filesize ne (-s "$uber_path$uber_triggerfile")) { # Greetings file has changed, reload
	if ($uber_triggers_filesize != 0) { uber_msg("Triggers file changed, reloading."); }
	open(TF,"<$uber_path$uber_triggerfile") or uber_msg("Triggers are enabled, but cannot load configuration file: '$uber_path$uber_triggerfile'");
	my @uber_temptrigger=<TF>;
	close(TF);
	$uber_triggers_filesize = (-s "$uber_path$uber_triggerfile");
	# Remove comments and store in global array
	@uber_triggers=();
	foreach (@uber_temptrigger) {
		chomp;
		if (($_ =~ /^\s*#/) or (!$_)) {  } else { 
			push(@uber_triggers,$_);
			}
		}
	} # End trigger-load section
}

sub uber_load_greetings {
	if ($uber_greetings_filesize ne (-s "$uber_path$uber_greetingfile")) { # Greetings file has changed, reload
	if ($uber_greetings_filesize != 0) { uber_msg("Greetings file changed, reloading."); } # Not first load
	open(GF,"<$uber_path$uber_greetingfile") or uber_msg("Greetings are enabled, but cannot load configuration file: '$$uber_path$uber_greetingfile'");
	my @uber_tempgreet=<GF>;
	close(GF);
	$uber_greetings_filesize = (-s "$uber_path$uber_greetingfile");
	# Remove comments and store in global array
#			@uber_greetings=''; # Reset global array
	@uber_greetings=();
	foreach (@uber_tempgreet) {
		if ($_ =~ /^\s*#/) {  } else {
			push(@uber_greetings,$_);
			}
		}
	}
	# End Greeting load section
	}

sub uber_session_saver { # Saves current state of Xchat (Channels, channel keys and servers) and attempts to reconnect at startup
	# Experimental and UNFINISHED!
	my $uber_id = "UberScript Session File"; # Identification
	# Called every X minutes on a timer if enabled.
	#uber_msg("Session_saver called");
	open (SS, ">$uber_path$uber_session_config") or uber_msg("WARNING! Cannot open Session Saver file: $uber_session_config - Session Saving will not work!"); 

	# Format of cfg file, one line per channel: $id_string,channel_name,server(hostname),channel_key(If any)
	# Loop to save all current channels
	my @ub_ss = Xchat::get_list("channels");

	## FIND WAY TO GET CHAN KEY ***************

	foreach(@ub_ss) {
		my @ubss_chan = map { $_->{channel} } $_;
		my @ubss_serv = map { $_->{server} } $_;
		my $ubss_pass = '';
		print (SS "$uber_id,@ubss_chan,@ubss_serv,$ubss_pass\n"); 
		}
	close (SS);
	return Xchat::EAT_XCHAT;
	}

sub uber_session_saver_reload { # Reload a saved session NOT WORKING, DO NOT USE
	my $ubss_chancnt=0;
	my $ubss_servcnt=0;
	open (SS,"<$uber_path$uber_session_config") or uber_msg("WARNING! Cannot open Session Saver file: $uber_session_config - Cannot load previous session"); 
	while (<SS>) { # Read each line
		chomp;
		my ($ubss_id,$ubss_chan,$ubss_serv,$ubss_pass) = split(/,/);
#		Xchat::print("($ubss_id)$ubss_chan($ubss_serv)$ubss_pass");
		if ($ubss_id ne 'UberScript Session File') { uber_msg("ERROR! Session file $uber_session_config is corrupt, aborting reload."); return Xchat::EAT_XCHAT; }
		# First find if we need to connect to a server...
		my $ubss_serv_found=0;
		my @ub_servers = map { $_->{server} } Xchat::get_list("channels");
		foreach (@ub_servers) {
			if ($ubss_serv eq $_) { $ubss_serv_found=1; } # Already connected this one.
			}
		if ($ubss_serv_found == 0) { # Not connected, let's connect
			uber_msg("Connecting to $ubss_serv for channel $ubss_chan");
			uber_command("server $ubss_serv");
			}
		}
	close(SS);
	return Xchat::EAT_XCHAT;
}

sub uber_addfav { # add a new favourite
	my $curchan = $_[0][1];
	if (!$curchan) {  $curchan=Xchat::get_info('channel'); }
	uber_msg("Adding channel $curchan to favourites");
	push(@uber_favlist,$curchan);
	open (UAF,">>$uber_path$uber_favouritesfile") or uber_msg("Unable to open favourites file ($uber_favouritesfile) - Addition won't be saved");
	print (UAF "$curchan\n");
	close (UAF);
	uber_favmenu_redraw();
	return Xchat::EAT_XCHAT;
}

sub uber_loadfavs { # load favs from cfg file
	@uber_favlist=();
	open (UAF,"<$uber_path$uber_favouritesfile") or uber_msg("Failure to load Favourites list, file doesn't exist ($uber_path$uber_favouritesfile)");
	while (<UAF>) {
		chomp;
		push (@uber_favlist,$_);
		}
	close(UAF);
	uber_favmenu_redraw();
}

sub uber_delfav { # Delete a favourite from
	my $remstr=$_[0][1];
	if (!$remstr) { $remstr = Xchat::get_info('channel'); }
	my $totfnd=0;
	open (UAF,"<$uber_path$uber_favouritesfile") or uber_msg("Can't open favourites file ($uber_path$uber_favouritesfile");
	open (UTMP, ">$uber_tempfile") or uber_msg("Can't open tempfile ($uber_tempfile) - this action will fail");
	while (<UAF>) {
		my $found=0;
		chomp;
		if ($remstr eq $_) { $found=1; $totfnd++; }
		if ($found == 0) { print(UTMP "$_\n"); }
		}
	close(UAF);
	close(UTMP);
	if ($totfnd ne 0) { 
		unlink("$uber_path$uber_favouritesfile");
		rename($uber_tempfile,"$uber_path$uber_favouritesfile");
		uber_msg("Removed $totfnd lines matching \"$remstr\" from Favourites.");
		uber_loadfavs();
		uber_favmenu_redraw();
		} else { uber_msg("Sorry, couldn't find a Favourite matching \"$remstr\" - usage /delfav #channel"); }
	return Xchat::EAT_XCHAT;
}

sub uber_addquick { # add a new quickstring
	if ($_[0][1] eq '') { uber_msg("Usage: /addquick string"); return Xchat::EAT_XCHAT; }
	uber_msg("Adding string ($_[1][1]) to Quickstrings");
	$_[1][1] =~ s/^\///;
	push(@uber_quicklist,$_[1][1]);
	open (UAF,">>$uber_path$uber_quickstringsfile") or uber_msg("Unable to open Quickstring file ($uber_quickstringsfile) - Addition won't be saved");
	print (UAF "$_[1][1]\n");
	close (UAF);
	uber_favmenu_redraw();
	return Xchat::EAT_XCHAT;
}

sub uber_delquick { # Delete a quickstring from file
	my $remstr=$_[1][1];
	my $totfnd=0;
	open (UAF,"<$uber_path$uber_quickstringsfile") or uber_msg("Can't open Quickstring file ($uber_path$uber_quickstringsfile)");
	open (UTMP, ">$uber_tempfile") or uber_msg("Can't open tempfile ($uber_tempfile) - this action will fail");
	while (<UAF>) {
		my $found=0;
		chomp;
		if (lc($remstr) eq lc($_)) { $found=1; $totfnd++; }
		if ($found == 0) { print(UTMP "$_\n"); }
		}
	close(UAF);
	close(UTMP);
	if ($totfnd ne 0) {
		unlink("$uber_path$uber_quickstringsfile");
		rename($uber_tempfile,"$uber_path$uber_quickstringsfile");
		uber_msg("Removed $totfnd lines matching \"$remstr\" from Quickstrings.");
		uber_loadquicks();
		uber_favmenu_redraw();
		} else { uber_msg("Sorry, couldn't find a Quickstring matching \"$remstr\" - usage /delquick exactstring"); }
	return Xchat::EAT_XCHAT;
}

sub uber_showquicks { # Display all quickstrings
	uber_msg("Showing all Quickstrings");
	my $cnt=0;
	foreach (@uber_quicklist) {
		uber_msg("$cnt: $_ ");
		$cnt++;
		}
	if ($cnt == 0) { uber_msg("No Quickstrings found"); }
	return Xchat::EAT_XCHAT;
}

sub uber_loadquicks { # load quickstrings from cfg file	
	@uber_quicklist=();
	open (UAF,"<$uber_path$uber_quickstringsfile") or uber_msg("Failure to load Quickstrings list, file doesn't exist ($uber_path$uber_quickstringsfile)");
	while (<UAF>) {
		chomp;
		push (@uber_quicklist,$_);
		}
	close(UAF);
	uber_favmenu_redraw();
}

sub uber_favmenu_redraw {
	Xchat::command("menu DEL Favourites");
	# Add favourites menu if set
	if (($uber_favourites != 0) or ($uber_quickstrings != 0)) {
		Xchat::command("menu ADD Favourites");
			if ($uber_favourites != 0) {
				foreach(sort(@uber_favlist)) {  # Sort it alpha for prettiness
					chomp;
					Xchat::command("menu ADD \"Favourites/Join: $_\"   \"join $_\" ");
					}
				Xchat::command("menu ADD \"Favourites/-");
				}
			if ($uber_quickstrings != 0) {
				foreach(sort(@uber_quicklist)) { # Sort it alpha
					chomp;
					Xchat::command("menu ADD \"Favourites/Quick: $_\"  \"$_\" ");
					}
				}
			} else {
				Xchat::command("menu ADD \"Favourites/No Entries\" \"uber_dialog Favourites: No channels set, use /addfav #channel to add some.\" ");
			}
}

sub uber_dialog { Xchat::print(uber_parse($_[1][1])); } # Simply output a message (Can't seem to get a gtk popup dialog, so using print instead)

sub uber_remove_system_menu {
	Xchat::command("menu DEL System");
	}

sub uber_draw_system_menu {
	Xchat::command("menu ADD System");
	# Away
	Xchat::command("menu add \"System/Away\"");
	uber_addsysmenu('away_auto_unmark','Away','Toggle automatically unmarking away before message send');
	uber_addsysmenu('away_show_message','Away','Toggle announcing of away messages');
	uber_addsysmenu('away_show_once','Away','Show identical away messages only once');
	uber_addsysmenu('away_track','Away','Toggle color change for away users in userlist');
	# Completion
	Xchat::command("menu add \"System/Completion\"");
	uber_addsysmenu('completion_auto','Completion','Toggle automatic nick completion');
	uber_addsysmenu('completion_sort','Completion','Toggle nick completion sorting in last talk order');
	# DCC
	Xchat::command("menu add \"System/DCC\"");
	uber_addsysmenu('dcc_auto_chat','DCC','Toggle auto accept for DCC chats');
	uber_addsysmenu('dcc_auto_resume','DCC','Toggle auto resume of DCC transfers');
	uber_addsysmenu('dcc_fast_send','DCC','Toggle speed up of DCC transfers by not waiting to heard if last part was received before sending next');
	uber_addsysmenu('dcc_remove','DCC','Toggle automatic removal of finished/failed DCCs');
	uber_addsysmenu('dcc_save_nick','DCC','Toggle saving of nicks in filenames');
	uber_addsysmenu('gui_auto_open_recv','DCC','Toggle auto opening of transfer window on DCC Recv');
	uber_addsysmenu('gui_auto_open_send','DCC','Toggle auto opening of transfer window on DCC Send');
	# Misc
	Xchat::command("menu add \"System/Misc\"");
	uber_addsysmenu('identd','Misc','Toggle internal IDENTD (Win32 Only)');
	# Beeps/Flashes
	Xchat::command("menu add \"System/Beeps\"");	
	uber_addsysmenu('input_beep_chans','Beeps','Toggle beep on channel messages');
	uber_addsysmenu('input_beep_hilight','Beeps','Toggle beep on highlighted messages');
	uber_addsysmenu('input_beep_msg','Beeps','Toggle beep on private messages');
	uber_addsysmenu('input_filter_beep','Beeps','Toggle filtering of beeps sent by others');
	uber_addsysmenu('input_flash_hilight','Beeps','Toggle whether or not to flash taskbar on highlighted message');
	uber_addsysmenu('input_perc_ascii','Beeps','Toggle interpreting of %nnn as ASCII value');
	uber_addsysmenu('input_perc_color','DCC','Toggle interpreting of %C, %B as color, bold, etc');
	# IRC
	Xchat::command("menu add \"System/IRC\"");
	uber_addsysmenu('irc_auto_rejoin','IRC','Toggle auto rejoining when kicked');
	uber_addsysmenu('irc_conf_mode','IRC','Toggle hiding of join and part messages');
	uber_addsysmenu('irc_hide_version','IRC','Toggle hiding of VERSION reply');
	uber_addsysmenu('irc_invisible','IRC','Toggle invisible mode (+i)');
	uber_addsysmenu('irc_logging','IRC','Toggle logging');
	uber_addsysmenu('irc_raw_modes','IRC','Toggle RAW channel modes');
	uber_addsysmenu('irc_servernotice','IRC','Toggle receiving of server notices');
	uber_addsysmenu('irc_skip_motd','IRC','Toggle skipping of server MOTD');
	uber_addsysmenu('irc_wallops','IRC','Toggle receiving wallops');
	uber_addsysmenu('irc_who_join','IRC','Toggle running WHO after joining channel');
	uber_addsysmenu('irc_whois_front','IRC','Toggle whois results being sent to currently active tab');
	# Net
	Xchat::command("menu add \"System/Net\"");
	uber_addsysmenu('net_auto_reconnect','Net','Toggle auto reconnect to server');
	uber_addsysmenu('net_auto_reconnectonfail','Net','Toggle auto reconnect upon failed connection');
	uber_addsysmenu('net_proxy_auth','Net','Toggle proxy authentication');
	uber_addsysmenu('net_throttle','Net','Toggle flood protection (to keep from getting kicked)');
	# Tabs
	Xchat::command("menu add \"System/Tabs\"");
	uber_addsysmenu('tab_chans','Tabs','Open channels in tabs instead of windows');
	uber_addsysmenu('tab_dialogs','Tabs','Open dialogs in tabs instead of windows');
	uber_addsysmenu('tab_icons','Tabs','Toggle icons in treeview');
	uber_addsysmenu('tab_notices','Tabs','Open up extra tabs for server notices');
	uber_addsysmenu('tab_server','Tabs','Open an extra tab for server messages');
	uber_addsysmenu('tab_small','Tabs','Toggle small tabs');
	uber_addsysmenu('tab_sort','Tabs','Toggle alphabetical sorting of tabs');
	uber_addsysmenu('tab_utils','Tabs','Open utils in tabs instead of windows');
	# Text
	Xchat::command("menu add \"System/Text\"");
	uber_addsysmenu('text_color_nicks','Text','Toggle colored nicks');
	uber_addsysmenu('text_indent','Text','Toggle text indentation');
	uber_addsysmenu('text_show_marker','Text','Toggle red marker line feature');
	uber_addsysmenu('text_show_sep','Text','Toggle separator line');
	uber_addsysmenu('text_stripcolor','Text','Toggle stripping of mIRC colors');
	uber_addsysmenu('text_thin_sep','Text','Use thin separator line instead of thick line');
	uber_addsysmenu('text_transparent','Text','Toggle transparent background');
	uber_addsysmenu('text_wordwrap','Text','Toggle wordwrap');
}

sub uber_addsysmenu {
	my $var=shift;
	my $tree=shift;
	my $desc=shift;
	Xchat::command("menu -t".Xchat::get_prefs("$var")." ADD \"System/$tree/$var ($desc)\"  \"set -quiet $var 1\"  \"set -quiet $var 0z\" ");
	}