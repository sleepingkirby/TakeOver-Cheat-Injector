#!/bin/bash
v='1.2'
rpaurl='https://raw.githubusercontent.com/Shizmob/rpatool/master/rpatool'

clear

NC='\033[0m'
# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan

cols=`tput cols`
line=`printf '#%.0s' $(seq 1 $cols)`

echo -e $BGreen$line"\n\n"
echo -e "Take Over Cheat Injector\n" 
echo -e "   Vesrion: ${v}"
echo -e "   by Sleepingkirby"
echo -e "   Inspired/based on RL Cheat Injector by SLDR @ F95zone.com"
echo -e $line$NC"\n\n"

curpath=`pwd`

  if [[ `basename $curpath` != "game" || `echo $curpath|grep -ic 'TakeOver'` -lt 1 ]]
  then
  echo -e "$BRed This script is in the wrong path. Please make sure it's in \"TakeOver<version>/game/\" folder $NC"
  exit 1
  fi

echo -e "$BGreen Checking if modification has already been done...$NC"

  if [[ -f ./screens.rpy.orig ]]
  then
  echo -e "${BRed}\n\nBackup files found. This probably means it was already patched. No need to further action. Exitting...$NC"
  exit 1
  fi
echo -e "$BGreen No backup's found. Safe to progress.\n$NC"
echo -e "$BGreen Checking to make sure requirements are met. \n\n$NC"

perlP=`which perl`

  if [[ $perlP == "" ]]
  then
  echo $perlP
  echo -e "$BRed Perl was not found. This script requires perl.$NC"
  exit 1
  fi


  if [[ ! -f ./screens.rpy ]]
  then
  echo -e "${BRed}\n\nFiles to be editted not found. Is it still in the archive.rpa?\n\n$NC"
    if [[ -f ./archive.rpa && ! -f ./rpatool ]]
    then
    echo -e "$BRed Rpatool missing. Downloading$NC"
    wget $rpaurl
    chmod 755 ./rpatool
    fi
  echo -e "$BRed Extracting archive.rpa...$NC"
  ./rpatool -x ./archive.rpa
  wait
  fi

#=========== ./screens.rpy
fn='./screens.rpy'
cp $fn $fn.orig

#set time of day
patt='text "\{vspace=0\}\{font=fonts\/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} Day \[day\], \[week_day\], \[time_name\](?P<dlv>\. Delivery in \[delivery_day\] days\.)? \{\/size\}\{\/color\}\{\/font\}"';
repl='textbutton "{vspace=0}{font=fonts\/Sansation_Bold.ttf}{color=#fff}{size= 20} Day [day], [week_day], [time_name]$+{dlv} {\/size}{\/color}{\/font}" style "gui_text" action [SetVariable("daytime", 0), SetVariable("time_name", set_time(daytime))]';
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn


#money
patt='text "\{vspace=40\}\{font=fonts\/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} Money: \[money\], supplies: \[supplies\] +\{\/size\}\{\/color\}\{\/font\}"';
repl='textbutton "{font=fonts\/Sansation_Bold.ttf}{color=#fff}{size= 20} Money: [money], supplies: [supplies] {\/size}{\/color}{\/font}" style "gui_text" ypos 40 action [SetVariable("money", money + 100), SetVariable("supplies", supplies + 10)]';
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

#control serum
patt='text "\{vspace=690\}\{font=fonts\/Sansation_Bold\.ttf\}\{color=#(?P<color>[0-9A-Fa-f]{3,})\}\{size= 18\} Control serum: \[serum\] \{\/size\}\{\/color\}\{\/font\}"';
repl='textbutton "{font=fonts\/Sansation_Bold.ttf}{color=#$+{color}}{size= 18} Control serum: [serum] {\/size}{\/color}{\/font}" style "gui_text" yalign 1.0 action SetVariable("serum", serum+3)';
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

#char corruption
patt='text "\{font=veteran typewriter\.ttf\}\{color=#000000\}\{size= 30\}Corruption: \[(?P<name>[a-z]+)_corr\] \{\/size\}\{\/color\}\{\/font\}"'
repl='textbutton "{font=veteran typewriter.ttf}{color=#000000}{size= 30}Corruption: [$+{name}_corr] {\/size}{\/color}{\/font}" style "gui_text" action SetVariable("$+{name}_corr", $+{name}_corr + 10)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

#research points and suspicion
patt='text "\{vspace=20\}\{font=fonts\/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} (?P<d>(Day )?)Research points: \[res_points\], suspicion \[suspicion\]\/\[max_suspicion\] \{\/size\}\{\/color\}\{\/font\}"'
repl='textbutton "{font=fonts\/Sansation_Bold.ttf}{color=#fff}{size= 20} $+{d}Research points: [res_points], suspicion [suspicion]\/[max_suspicion] {\/size}{\/color}{\/font}" style "gui_text" ypos 20 action [SetVariable("res_points", res_points + 20), SetVariable("suspicion",suspicion - 2)]'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

#vera_trust
patt='\\n\\nCurrent trust: \[vera_trust\]\{\/size\}\{\/color\}\{\/font\}"'
repl='{\/size}{\/color}\{\/font}"\n                            textbutton "{font=veteran typewriter.ttf}{color=#000000}{size= 18}\\nCurrent trust: [vera_trust]{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("vera_trust", vera_trust + 1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

#adding cheat version to places
patt='\[config\.version\]';
repl='[config.version] CheatV'$v;

perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

patt='(?P<pad> {2,})textbutton _\("Prefs"\) action ShowMenu\('"'"'preferences'"'"'\)'
repl='$+{pad}textbutton _("Prefs") action ShowMenu('"'"'preferences'"'"')\r\n$+{pad}textbutton _("CheatV'$v'") action NullAction()'

perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' $fn

echo -e "${BGreen}${fn} patched$NC"

#=========== ./script/screens/screen journal subjects.rpy
fn="./script/screens/screen journal subjects.rpy"
cp "$fn" "$fn.orig"

# corruption for updated journal
patt='text "\{font=KozGoPr6N-Regular\.otf\}\{size= 30\}Corr: \[(?P<name>[a-z]+)_corr\]\/100\{\/size\}\{\/font\}" at left'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{size= 30}Corr: [$+{name}_corr]\/100{\/size}{\/font}" style "gui_text" at left action SetVariable("$+{name}_corr", $+{name}_corr + 10)'

perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

echo -e "${BGreen}${fn} patched$NC"


#=========== ./script/character screens/character socialize journal screen.rpy
fn="./script/character screens/character socialize journal screen.rpy"
cp "$fn" "$fn.orig"

# corruption for updated journal
patt='Energy available: \[energy\]\/5\{\/size\}\{\/color\}\{\/font\}"'
repl='{\/size}{\/color}{\/font}"\n            textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 16}Energy available: [energy]\/5{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("energy",5)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

echo -e "${BGreen}${fn} patched$NC"


#=========== ./script/character screens/character intimacy journal screen.rpy 
fn="./script/character screens/character intimacy journal screen.rpy"
cp "$fn" "$fn.orig"

# corruption for updated journal
patt='Energy available: \[energy\]\/5\{\/size\}\{\/color\}\{\/font\}"'
repl='{\/size}{\/color}{\/font}"\n            textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 16}Energy available: [energy]\/5{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("energy",5)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

echo -e "${BGreen}${fn} patched$NC"



#=========== ./script/screens/screen journal.rpy
fn="./script/screens/screen journal.rpy"
cp "$fn" "$fn.orig"

#updated journal stats
patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Suspicion: \[suspicion\]\/\[max_suspicion\] \{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Suspicion: [suspicion]\/[max_suspicion] {\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("suspicion", suspicion - 2)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Heat: \[heat\]\/100 \{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Heat: [heat]\/100 {\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("heat", heat - 2)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Freedom: \[_int_free\]\/100 \{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Freedom: [_int_free]\/100 {\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("freedom", freedom+1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Intelligence: \[intelligence\] \{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Intelligence: [intelligence] {\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("intelligence", intelligence + 1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Money: \[money\] \{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Money: [money] {\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("money", money + 100)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Supplies: \[supplies\]\{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Supplies: [supplies]{\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("supplies", supplies+10)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Research: \[res_points\]\{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Research: [res_points]{\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("res_points", res_points+10)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Serums: \[serum\]\{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Serums: [serum]{\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("serum", serum+3)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Manpower: \[manpower\]\{\/size\}\{\/color\}\{\/font\}" at center'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Manpower: [manpower]{\/size}{\/color}{\/font}" at center style "gui_text" action SetVariable("manpower", manpower+1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"


echo -e "${BGreen}${fn} patched$NC"

#=========== ./script/screens/screen bios.rpy
fn="./script/screens/screen bios.rpy"
cp "$fn" "$fn.orig"

# corruption for updated journal
patt='\\n\\nCurrent trust: \[vera_trust\]\\n\\nCurrent love: \[vera_love\]\{\/size\}\{\/color\}\{\/font\}"'
repl='{\/size}{\/color}{\/font}"\n                        textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}\\n\\nCurrent trust: [vera_trust]{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("vera_trust", vera_trust + 1)\n                        textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}\\n\\nCurrent love: [vera_love]{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("vera_love", vera_love + 1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

#Love of other characters
patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 18\}(?P<descr>.+)\\n\\nLove: \[(?P<nm>[a-z]+)_love\]\{\/size\}\{\/color\}\{\/font\}"'
repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}$+{descr}\\n\\nLove: [$+{nm}_love]{\/size}{\/color}{\/font}" style "gui_text" action SetVariable("$+{nm}_love", $+{nm}_love + 1)'
perl -0777 -i -pe 's/'"$patt"'/'"$repl"'/mg' "$fn"

echo -e "${BGreen}${fn} patched$NC"



echo -e "${BGreen}DONE!$NC"
exit 0
