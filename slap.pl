IRC::register ("slap! v1.05 by APz", "1.05", "", "");
IRC::print("slap! v1.05 loaded.");

##############################################################################
# slap! # 
# Adds a random mIRC-style slaps #
# #
# And yes, it *IS* lame! :) #
##############################################################################

IRC::add_command_handler("slap", "do_slap");
IRC::add_command_handler("slapk", "do_slapk");

sub arvo {
@tavat=("slaps", "hits", "beats up", "bashes", "hurts", "kills", "tortures");
@koot=("a large", "an enormous", "a small", "a medium sized", "an extra large", "a questionable", "a suspicious", "a terrifying", "a scary", "a breath taking", "a horrifying");
@tavarat=("Windows ME user guide", "Windows 2000", "brick", "non-functional AT power source", "axe", "shovel", "mIRC 6.01", "salmon", "Khaled Mardam-Bey", "iron bar", "Back Street Boys CD", "whip", "QuakeNET server", "Pentium 4 CPU", "set of Windows 3.11 floppies", "camel", "christmas tree", "Compaq laptop", "picture of Bill Gates", "RIAA", "MagLite<tm> torch covered with vaseline", "MS IIS", "slap-script");
srand;
$index=rand @tavat;
$tapa=@tavat[$index];
$index=rand @koot;
$koko=@koot[$index];
$index=rand @tavarat;
$tavara=@tavarat[$index];
}

sub do_slap
{
arvo; 
$nimi=shift(@_);

if ($nimi eq "") {
IRC::print("Usage: /slap <nick>");
} else {
IRC::command("/me $tapa $nimi with $koko $tavara");
}
return(1);
}

sub do_slapk
{
arvo; 
$nimi=shift(@_);

if ($nimi eq "") {
IRC::print("Usage: /slapk <nick>");
} else {
$omanimi=IRC::get_info(1);
IRC::command("/kick $nimi $omanimi $tapa $nimi with $koko $tavara");
}
return(1);
}