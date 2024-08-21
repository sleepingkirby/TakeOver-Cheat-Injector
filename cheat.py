import re

v = "1.3"
tab = " " * 4
newline = "\n"

#=============  ./screens.rpy =========
def screens():
    fn="./screens.rpy"
    with open(fn, "r") as file:
        fc = file.read()

    #set time of day
    patt='text "\{vspace=0\}\{font=fonts/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} Day \[day\], \[week_day\], \[time_name\](?P<dlv>(\. Delivery in \[delivery_day\] days\.)?) \{/size\}\{/color\}\{/font\}"';
    repl='textbutton "{vspace=0}{font=fonts/Sansation_Bold.ttf}{color=#fff}{size= 20} Day [day], [week_day], [time_name]\g<dlv> {/size}{/color}{/font}" style "gui_text" action [SetVariable("daytime", 0), SetVariable("time_name", set_time(daytime))]';
    fc = re.sub(patt, repl, fc, flags=re.M)

    #money
    patt='text "\{vspace=40\}\{font=fonts/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} Money: \[money\], supplies: \[supplies\] +\{/size\}\{/color\}\{/font\}"';
    repl='textbutton "{font=fonts/Sansation_Bold.ttf}{color=#fff}{size= 20} Money: [money], supplies: [supplies] {/size}{/color}{/font}" style "gui_text" ypos 40 action [SetVariable("money", money + 100), SetVariable("supplies", supplies + 10)]';
    fc = re.sub(patt, repl, fc, flags=re.M)

    #control serum
    patt='text "\{vspace=690\}\{font=fonts/Sansation_Bold\.ttf\}\{color=#(?P<color>[0-9A-Fa-f]{3,})\}\{size= 18\} Control serum: \[serum\] \{/size\}\{/color\}\{/font\}"';
    repl='textbutton "{font=fonts/Sansation_Bold.ttf}{color=#\g<color>}{size= 18} Control serum: [serum] {/size}{/color}{/font}" style "gui_text" yalign 1.0 action SetVariable("serum", serum+3)';
    fc = re.sub(patt, repl, fc, flags=re.M)

    #char corruption
    patt='text "\{font=veteran typewriter\.ttf\}\{color=#000000\}\{size= 30\}Corruption: \[(?P<name>[a-z]+)_corr\] \{/size\}\{/color\}\{/font\}"'
    repl='textbutton "{font=veteran typewriter.ttf}{color=#000000}{size= 30}Corruption: [\g<name>_corr] {/size}{/color}{/font}" style "gui_text" action SetVariable("\g<name>_corr", \g<name>_corr + 10)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    #research points and suspicion
    patt='text "\{vspace=20\}\{font=fonts/Sansation_Bold\.ttf\}\{color=#fff\}\{size= 20\} (?P<d>(Day )?)Research points: \[res_points\], suspicion \[suspicion\]/\[max_suspicion\] \{/size\}\{/color\}\{/font\}"'
    repl='textbutton "{font=fonts/Sansation_Bold.ttf}{color=#fff}{size= 20} \g<d>Research points: [res_points], suspicion [suspicion]/[max_suspicion] {/size}{/color}{/font}" style "gui_text" ypos 20 action [SetVariable("res_points", res_points + 20), SetVariable("suspicion",suspicion - 2)]'
    fc = re.sub(patt, repl, fc, flags=re.M)

    #vera_trust
    patt='\\\\n\\\\nCurrent trust: \[vera_trust\]\{/size\}\{/color\}\{/font\}"'
    repl='{/size}{/color}{/font}"\n                            textbutton "{font=veteran typewriter.ttf}{color=#000000}{size= 18}\\\\nCurrent trust: [vera_trust]{/size}{/color}{/font}" style "gui_text" action SetVariable("vera_trust", vera_trust + 1)'
    fc = re.sub(patt, repl, fc, flags=re.M)
    
    #adding cheat version to places
    patt='\[config\.version\]';
    repl='[config.version] CheatV'+v;
    fc = re.sub(patt, repl, fc, flags=re.M)
    
    patt='(?P<pad> {2,})textbutton _\("Prefs"\) action ShowMenu\(\'preferences\'\)'
    repl='\g<pad>textbutton _("Prefs") action ShowMenu(\'preferences\')\n\g<pad>textbutton _("CheatV'+v+'") action NullAction()'
    fc = re.sub(patt, repl, fc, flags=re.M)


    with open(fn, "w") as file:
        file.write(fc)

    print (fn+" patched")

screens()

#============= ./script/screens/screen journal subjects.rpy =========
def screen_journal_subjects():
    fn="./script/screens/screen journal subjects.rpy"
    with open(fn, "r") as file:
        fc = file.read()


    # corruption for updated journal
    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{size= 30\}Corr: \[(?P<name>[a-z]+)_corr\]/100\{/size\}\{/font\}" at left'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{size= 30}Corr: [\g<name>_corr]/100{/size}{/font}" style "gui_text" at left action SetVariable("\g<name>_corr", \g<name>_corr + 10)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    with open(fn, "w") as file:
        file.write(fc)

    print (fn+" patched")

screen_journal_subjects()


#============= ./script/character screens/character socialize journal screen.rpy =========
def character_socialize_journal_screen():
    fn="./script/character screens/character socialize journal screen.rpy"
    with open(fn, "r") as file:
        fc = file.read()

    # corruption for updated journal
    patt='Energy available: \[energy\]/5\{/size\}\{/color\}\{/font\}"'
    repl='{/size}{/color}{/font}"\n            textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 16}Energy available: [energy]/5{/size}{/color}{/font}" style "gui_text" action SetVariable("energy",5)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    with open(fn, "w") as file:
        file.write(fc)

    print (fn+" patched")

character_socialize_journal_screen()


#============= ./script/character screens/character intimacy journal screen.rpy =========
def character_intimacy_journal_screen():
    fn="./script/character screens/character intimacy journal screen.rpy"
    with open(fn, "r") as file:
        fc = file.read()

    # corruption for updated journal
    patt='Energy available: \[energy\]/5\{/size\}\{/color\}\{/font\}"'
    repl='{/size}{/color}{/font}"\n            textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 16}Energy available: [energy]/5{/size}{/color}{/font}" style "gui_text" action SetVariable("energy",5)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    with open(fn, "w") as file:
        file.write(fc)

    print (fn+" patched")

character_intimacy_journal_screen()



#============= ./script/screens/screen journal.rpy =========
def screen_journal():
    fn="./script/screens/screen journal.rpy"
    with open(fn, "r") as file:
        fc = file.read()

    #updated journal stats
    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Suspicion: \[suspicion\]/\[max_suspicion\] \{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Suspicion: [suspicion]/[max_suspicion] {/size}{/color}{/font}" at center style "gui_text" action SetVariable("suspicion", suspicion - 2)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Heat: \[heat\]/100 \{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Heat: [heat]/100 {/size}{/color}{/font}" at center style "gui_text" action SetVariable("heat", heat - 2)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Freedom: \[_int_free\]/100 \{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Freedom: [_int_free]/100 {/size}{/color}{/font}" at center style "gui_text" action SetVariable("freedom", freedom+1)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Intelligence: \[intelligence\] \{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Intelligence: [intelligence] {/size}{/color}{/font}" at center style "gui_text" action SetVariable("intelligence", intelligence + 1)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Money: \[money\] \{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Money: [money] {/size}{/color}{/font}" at center style "gui_text" action SetVariable("money", money + 100)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 24\}Supplies: \[supplies\]\{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Supplies: [supplies]{/size}{/color}{/font}" at center style "gui_text" action SetVariable("supplies", supplies+10)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Research: \[res_points\]\{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Research: [res_points]{/size}{/color}{/font}" at center style "gui_text" action SetVariable("res_points", res_points+10)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Serums: \[serum\]\{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Serums: [serum]{/size}{/color}{/font}" at center style "gui_text" action SetVariable("serum", serum+3)'
    fc = re.sub(patt, repl, fc, flags=re.M)

    patt='text "\{font=KozGoPr6N-Regular.otf\}\{color=#000000\}\{size= 24\}Manpower: \[manpower\]\{/size\}\{/color\}\{/font\}" at center'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 24}Manpower: [manpower]{/size}{/color}{/font}" at center style "gui_text" action SetVariable("manpower", manpower+1)'
    fc = re.sub(patt, repl, fc, flags=re.M)


    with open(fn, "w") as file:
        file.write(fc)

    print (fn+" patched")

screen_journal()


#============= ./script/screens/screen bios.rpy =========
def screen_bios():
    fn="./script/screens/screen bios.rpy"
    with open(fn, "r") as file:
        fc = file.read()


    # corruption for updated journal
    patt='\\\\n\\\\nCurrent trust: \[vera_trust\]\\\\n\\\\nCurrent love: \[vera_love\]\{/size\}\{/color\}\{/font\}"'
    repl='{/size}{/color}{/font}"\n                        textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}\\\\n\\\\nCurrent trust: [vera_trust]{/size}{/color}{/font}" style "gui_text" action SetVariable("vera_trust", vera_trust + 1)\n                        textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}\\\\n\\\\nCurrent love: [vera_love]{/size}{/color}{/font}" style "gui_text" action SetVariable("vera_love", vera_love + 1)'
    fc = re.sub(patt, repl, fc, flags=re.M)
    
    #Love of other characters
    patt='text "\{font=KozGoPr6N-Regular\.otf\}\{color=#000000\}\{size= 18\}(?P<descr>.+)\\\\n\\\\nLove: \[(?P<nm>[a-z]+)_love\]\{/size\}\{/color\}\{/font\}"'
    repl='textbutton "{font=KozGoPr6N-Regular.otf}{color=#000000}{size= 18}\g<descr>\\\\n\\\\nLove: [\g<nm>_love]{/size}{/color}{/font}" style "gui_text" action SetVariable("\g<nm>_love", \g<nm>_love + 1)'
    fc = re.sub(patt, repl, fc, flags=re.M)
    
    with open(fn, "w") as file:
        file.write(fc)

screen_bios()


print ("    Success! Cheats are now enabled!")
