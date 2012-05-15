Flashy's UberScript for Xchat, October 2006
Version 1.1e
Flash_ - irc.freenode.org - #xchat  /  irc.quakenet.org - Flash_

Overview:

A huge collection of useful functions. Some fun, some that I don't know how I lived without - all 
designed to add the functionality to Xchat that some feel has been missing. 

Designed to be as easy to install and use as possible, despite it's staggering range of features - 
most options are available through a special pulldown menu and one-click launching of config 
files in your favourite text editor which makes adjusting a breeze!

Copyright: None. Polite request to credit my name if my code is used elsewhere.

=================================================================================
Brief list of functions:

Core:
	Adds new Menu item controlling most aspects. 
	Adds several User Buttons
	Automatically saves configuration.
	Wide variety of macros for all output strings.

Fun/Silly: 
	Random Slaps, including third person.
	Random Gives, including third person.
	Random Quotes, including multiple quote files. 
	Random Quit Messages.
	Random CTCP VERSION replies. 
	"Rainbow" text with /uc Text

Useful: 
	Full Trigger support! Respond to user commands or your own commands, say/me/kick/op - whatever you want.
	Join/Part Filter. 
	Nick-change filter. 
	Now Playing / Junk Strings filter.
	Auto Greet, Auto-op, Auto-Voice (Any action on join, specified nick/channel or wildcard)
	Quakenet automatic Q authing, including hiding hostmask.
	Automatic reply to queries, toggleable for here and away. (Doesn't keep spamming same message each line, either)
	A Favourites list - Adds a menu containing your favourite channels for one-click joining. /addfav and /delfav
	A Quickstrings list - A menu system where you can add strings to a special menu. Eg, Auth strings you don't need to call every time, special op stuff that you can't remember - just bung it in the self-sorting menu and it'll be there, just two clicks away. /addquick and /delquick
	An easy menu system for all the Xchat internal toggles, along with descriptions.

=================================================================================
To Upgrade:
From v.1, v.1.1* :  (Everything in the 1.x branch is backwardly compatible with existing config and quote files)
	Read History at end of this document.
	Backup.
	Drop in the new UberScript.pl 
	No need to overwrite your ./uber/* files or your configuration. This version is backwardly compatible with all 1.x configs.	There may some minor tweaks in the /uber directory, but nothing important enough to overwrite what you have already.
=================================================================================
To install:

Requirements: 
	Windows or Linux (Probably Mac too, but untested). 
	X-Chat version 2.4.5 onwards with the Perl plugin (UberScript uses /menu to make things easier. Older versions will work partially.)
	Perl (ActivePerl for windows)

Tip: If running Windows, I recommend the FREE X-Chat builds at http://xrl.us/h7rs or http://www.silverex.info/
Alas, Daemon404 who made my favourite builds has decided to stop producing them.
Paces is now doing current builds as of October 06: http://paces.podzone.net/xchat-win32/

Windows: 
	Install ActivePerl if you have not already. This is available free from http://www.activestate.com/
	unzip UberScript.pl and associated files into X-chat's working directory. This will be at:
		C:\Documents and Settings\Administrator\Application Data\X-Chat 2
		(Note "Administrator" will need to be changed to your windows username if you're not Administrator)
		(Also if using Windows Explorer, not that "Application Data" is hidden by default, you need to turn on "Show Hidden Files and folders" in 		Tools -> Folder Options -> View) Horrible, I know.
	Ensure the uber/ and (Optionally /quotes) directories are created containing several text files. 
	
	UberScript will now run when you start X-Chat and you will see something like "UberScript: Loaded Flashy's Uberscript" when it loads successfully. 
	You can also force it to start manually by using  Xchat's "Window -> Plugins and Scripts" dialog.
	By default the new menu is enabled and you can see it at the top of the screen. It should also add a couple of Userlist buttons.

Linux: 
	Unzip into ~/.xchat2/ checking that ~/.xchat2/uber and (Optionally ~/.xchat2/quotes) are created containing various text files.
	Optional: Edit ~/.xchat2/UberScript.pl and change my $uber_editor = "notepad"; to your favourite X windows text editor - eg, gedit. 		

	UberScript will now run when you start X-Chat and you will see something like "UberScript: Loaded Flashy's Uberscript" when it loads successfully. 
	You can also force it to start by using  Xchat's "Window -> Plugins and Scripts" dialog, or just /reloadall 
	By default the new menu is enabled and you can see it at the top of the screen.

Mac: 	
	No idea, but probably along the same lines as Linux, although Xchat's script directory may be different.

=================================================================================
Macros supported

These work in most strings - Greetings, Triggers etc. The exceptions are things in the Quickstrings menu. 
Simply include them in your response/string and they'll be expanded when used.

%n = Nick of third person.
%m = Your current nick.
%s = Current server. (In multi-server situations, will be the one in context)
%e = Current network. 
%t = Topic of current channel.
%c = Current channel.
%r = Your /away reason.
%u = Random user from current channel.
%l = Entire line of text.
%1 = First word in line
%2 = Second word in line
%3 = Third word in line
%4 = Fourth word in line
%5 = Fifth word in line
%6 = Sixth word in line
%i = Current time - HH:MM.S
%d = Current date - Day/Mon/Year
%w = Current day of week. Monday, Tuesday etc.
%h = Number of channels connected to.
%a = Number of queries/PMs open.

=================================================================================

How do I... ?

Reduce some of the channel spam?  
	Click on the UberScript menu and tick the "Filtering" options.

Reply automatically to queries or personal messages?
	Click on the UberScript menu and experiment with the AutoReply sub-menu

How do I use the Channel Peaks system?
	Click on the UberScript menu then Channel Peaks submenu. First enable it. 
To manually display to the channel the current peak, select "Announce Channel peak now" from that menu. 
It may take some time to build up some scores - it starts scoring when somebody joins. 
It's recommended you DO NOT turn on the "Peak Announcements" (Which spam to the channel when the peak is beaten) until you have several days or weeks of peaks, so it won't spam very often
To enable !peak, choose Edit Triggers from the UberScript menu -> Triggers and uncomment this line:
#!peak|*|uberpeak

How do I turn off these silly !give, !slap and !quote things?
	/uset uber_sillystuff_enabled        (Or use the menus)

How do I give voice to everyone entering my channel?
	Use the menus to edit the Greetings configuration and enter a new line like:	
*|#3am|mode +v %n
* means everyone. #3am is the channel name. move +v sets voice. %n expands into the nick of the user who just joined. 

How do I spam people in really annoying rainbow colours?
	/uc Enter your message here

I use Quakenet and want to auth with Q automatically. How?
	Use the menu and enable Q authing, then set the username and passwords either in UberScript.pl itself, or by typing into Xchat:
/uset uber_Q_auth_name YourAuthNick
/uset uber_Q_auth_name YourAuthPassword
	Then next time you connect to a Quakenet server, UberScript should auth you AND grant you mode +X which hides your hostname.

I want X-Chat to make me automatically join channels that I'm invited to!
	Investigate the Invite menu options.

I want to regain a nick as soon as it's free!
	Then enable Network -> Regain Nick. UberScript will then notice when your current nick isn't that which is set to your first-choice nick
and will check once a minute to see if that nick is no longer in use. If it's no longer in use, UberScript will change your nick automatically.

I changed some config entries in UberScript.pl and reloaded the script, but it's still using the old values. Wtf?
	UberScript saves the config in its own config file - UberScript.cfg. Easiest way to refresh from the .pl 	default values is to type /uber_rehash

I keep getting "Unable to open..." errors when doing stuff. 
	If linux, double-check the permissions are read/write for your username (or whatever user you're running Xchat under). 
	If Windows, check the path is correct by typing /uset and checking uber_path. Ensure you have permissions to create files there.
	Also check the various filenames and paths in /uset to ensure they exist and are read/write able.

Remember what arcane X-chat setting does what?
	Enable "System Menu" in UberScript pulldown menu and view/change all the Toggleable Xchat settings along with descriptions. 

This script doesn't add any menus! You said it would, you fibber!
	Upgrade your copy of X-Chat to 2.4.5 or newer.

=================================================================================
Overview of all extra commands (More are available from UberScript menu) {} = Required. [] = Optional

/addfav [#channel]	Adds #channel to your favourites list, of if #channel not supplied, adds current channel.
			Eg: /addfav #3am
/delfav [#channel]	Remove #channel from favourites list, or current channel if empty.

/addquick {string}	Adds string to the Favourites menu. Note: A leading / is assumed and will be removed from the menu entry.
			Eg: /addquick me throws peanuts onto the stage.
/delquick {string}	Remove string from favourites list. string must match exactly that to be removed.
/showquicks		Lists all quickstrings for easy cut-n-paste when you want to delete them.

/uber_regain_nick	Toggles the Nick Regain function. Watches your primary nick (from prefs) and attempts to change to it when free.

/uc {Text}		Says "Text" in wild rainbow colours.

/uber_rehash		Abandons current config (Except greetings/favourites/triggers etc) and uses the defaults saved in UberScript.pl

/uberpeak		Announces to channel the existing peak for that channel.

/uberquote [Filename]	Picks random line from Filename. If no Filename supplied, will use the default file set in uber_quotesfile.
			(This looks a little unwieldy, but is flexible and intended you set filenames with usermenu or user buttons)

/ubergive {Nick}	Gives a random object from textfile specified as uber_givefile 
!slap {Nick} (Public)	Eg: Flash_ gives Pengbot a book by Stephen King

/uberslap {Nick}	As above, but slaps them with random item in uber_slapfile
!give {Nick} (Public)	Eg: Flash_ slaps Pengbot around the head with a catholic pries

/uset [variable] [Setting]
			When called without a variable, displays current configuration. 
			When called with a variable, either toggles that variable or changes it to Setting, depending on type.

=================================================================================
Done/todo/not-do lists

Random quote (/quote file)		(Done)
Random slap				(Done)
Random give				(Done)
Auto greet, including auto-op/voice	(Done)
Remove joins/parts/quits		(Done)
Remove nick-changes			(Done)
Remove mode-changes			(Done)
PM message-responder (Home and away)	(Done)
Colour output 				(Done) /UC
Random ctcp version replies.		(Done)
Now Playing / Junk Strings filter	(Done)  (Note: Also hides your own text if it matches)
Random Quit Messages			(Done)
Random Part Messages			(Done)
Q-Auth & umode +x. 			(Done)
peak !peak, saving and auto-announce	(Done)
Trigger system 				(Done)
Self-checks xchat version and warns if low (Done)
Random away messages			(Done)
On invite auto-join and auto-thank	(Done)
/USET  Shows current settings.		(Done) (Double-check)
Save/load automatically.		(Done) (Add all new ones)
Regain nick				(Done) 
Report how many channels I'm in. 	(Done) %h and %a for number of channels and queries
Favourites Menu List			(Done) /ADDFAV /DELFAV
QuickStrings Menu List			(Done) /ADDQUICK /DELQUICK
Xchat variables menu (Toggles)		(Done)

Session saver. 10-minute timer, save all server/channels and passwords, pms 	
	(Incomplete; Saving all but pass ok but need to work on gaining channel password reliably)

Todo list: 
A Seen (!seen) system. 
A Temp ban system (floods etc). /mode +b /kick (wait x minutes) /mode -b
Tempban on spam (x repeats in same channel within x seconds)
Add hostmasks to Autogreet. 
Add Perform system per-server. (Any call for this?)
Fix auto rejoin for keyworded channels. (Difficult as Xchat has no support for providing channel keys or modes)
Add auto popup entries (Going to be difficult as Xchat has no 3rd-party support to edit or even force reload of popup.conf)
Figlet function (Too much work to replicate in a Windows environment for limited use)

Removed from Todo List:
!wikibot				Covered by Craig Andrews lookupbot - Available here: 
!google					Covered by Craig Andrews lookupbot - http://digdilem.org/code/xchat/xchat.php
!urban					Covered by Craig Andrews lookupbot
!dictionary				Covered by Craig Andrews lookupbot
!define etc				Covered by Craig Andrews lookupbot

=========================================================

Credit: Xchat Setvars list at: http://xchat-win32.berlios.de/setvars.html
Khisanth, b0at and others from #xchat for various help.
Silverex, Daemon404, Pu70 and Paces for the Win32 builds.

History: 

V.1.1e
- Fixed CTCP reply bug - would reply with VERSION regardless of what type of CTCP request. This bug also stopped Xchat and other scripts from responding other CTCP types.
- Rewritten /ubergive and /uberslap routines. (Overly complicated and giving "Use of uninitialized value in string.." errors. 

V.1.1d
- Fixed bug with autojoin function which gave error: "Use of uninitialized value in concatenation (.) or string at "

V.1.1c
Minor bugfix - /uberslap and /ubergive had new bugs
Turned off perl warnings, one day I'll improve my code enough...

V.1.1b
/delquick amended so no longer case-sensitive.
/showquicks added. (Displays Quickstrings)
Fix: CTCP autoresponder function returned:  "Error in print callback Undefined subroutine
	&Xchat::Script::UberScript::uber_print called at (eval 3) line 681."
Fix: Some other Perl errors like: " Use of uninitialized value in subroutine entry at "
Change: !quote reply made private, rather than public to avoid clashes with other quote scripts.
Fix: Perl warning on !quote if quotefile didn't exist. Fixed.
Unfixed: Autoresponder goes mad if you have two PM's open and reconnect to your bouncer, when you have multiple clients to that bouncer. (ie, Psybnc). Temp fix - turn off autoresponse on one client.

V.1.0 Released. June 18th, 2006
 