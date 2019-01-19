statusmenu:
    gui, destroy
    Gui, Add, Text, x10 y0 w160 h20 center border, selected pokemon
    Gui, Add, Text, x10 y40 w160 h20 center, % vpokemon
    Gui, Add, Button, x10 y80 w160 h30 gcheckspecies,  % "show owned " vpokemon "'s"
    Gui, Add, Button, x10 y130 w160 h30 gsearchiv, search high iv
    Gui, Add, Button, x10 y180 w160 h30 gsearchprice, search low price
    Gui, Add, Text, x200 y0 w160 h20 center border, stats
    Gui, Add, Text, x200 y30 w160 h20 center, % "total boots : " commify(bootcount)
    Gui, Add, Text, x200 y60 w160 h20 center, % "messages sent : " commify(messagessent)
    Gui, Add, Text, x200 y90 w160 h20 center, % "total messages sent : " commify(totalmessagessent)
    Gui, Add, Text, x200 y130 w160 h20 center, % "pokemon caught : " commify(pokemoncaught)
    Gui, Add, Text, x200 y160 w160 h20 center, % "latest catch : " lastpokemoncaught
    Gui, Add, Button, x190 y190 w170 h20 glatestcatch, info latest
    Gui, Add, Text, x390 y0 w160 h20 border center, highlighted text
    Gui, Add, Button, x390 y30 w80 h70 gmarketinfo, info
    Gui, Add, Button, x470 y30 w80 h70 gtrade, trade
    Gui, Add, Button, x390 y100 w80 h70 gmarketsell, quick sell
    Gui, Add, Button, x470 y100 w80 h70 gmarketbuy, quick buy
    Gui, Add, Button, x390 y180 w160 h30 gnicknames, set nicknames
    showgui(560,220,"Better Pokecord - Status")
    Return

nicknames:
    msgbox, % "being worked on"
    return

checkspecies:
    sleepwin("Discord",20)
    send % prefix "pokemon --name " vpokemon "`r"
    gosub, msgcount
    return

searchiv:
    sleepwin("Discord",20)
    send % prefix "market search --name " vpokemon " --order iv descending --showiv`r"
    gosub, msgcount
    return

searchprice:
    sleepwin("Discord",20)
    send % prefix "market search --name " vpokemon " --order price ascending --showiv`r"
    gosub, msgcount
    return

latestcatch:
    sleepwin("Discord",20)
    send % prefix "info latest`r"
    gosub, msgcount
    return

marketinfo:
    sleepwin("Discord",20)
    setkeydelay, 120
    send, {ctrldown}c{ctrlup}
    loop, parse, clipboard, `n
    {
        parsesanity := 0
        marketarray := strsplit(a_loopfield, a_space)
        if (marketarray[1] = "level") {
            if (marketarray[3]="alolan"||marketarray[3]="mega"||marketarray[3]="mime"||marketarray[4]="mime")
                parsesanity += 1
            if (marketarray[5]="x"||marketarray[5]="y")
                parsesanity += 1
            send % prefix "market info " marketarray[6+parsesanity] "`r"
        } else {
            if (marketarray[1]="alolan"||marketarray[1]="mega"||marketarray[1]="mime"||marketarray[2]="mime")
                parsesanity += 1
            if (marketarray[3]="x"||marketarray[3]="y")
                parsesanity += 1
            send % prefix "info " marketarray[7+parsesanity] "`r"
        }
        gosub, msgcount
        sleep, 2000
    }
    return

trade:
    sleepwin("Discord",20)
    setkeydelay, 120
    send % prefix "p add "
    loop, parse, clipboard, `n
    {
        parsesanity := 0
        marketarray := strsplit(a_loopfield, a_space)
        if (marketarray[1]="alolan"||marketarray[1]="mega"||marketarray[1]="mime"||marketarray[2]="mime")
            parsesanity += 1
        if (marketarray[3]="x"||marketarray[3]="y")
            parsesanity += 1
        send % marketarray[7+parsesanity] " "
    }
    send, `r
    gosub, msgcount
    return

marketsell:
    sleepwin("Discord",20)
    setkeydelay, 120
    send, {ctrldown}c{ctrlup}
    inputbox, sellprice, how much to list each for?
    if (errorlevel = 1)
        return
    sleepwin("Discord",20)
    loop, parse, clipboard, `n
    {
        parsesanity := 0
        loopcount += 1
        marketarray := strsplit(a_loopfield, a_space)
        if (marketarray[1]="alolan"||marketarray[1]="mega"||marketarray[1]="mime"||marketarray[2]="mime")
            parsesanity += 1
        if (marketarray[3]="x"||marketarray[3]="y")
            parsesanity += 1
        send % prefix "market list " marketarray[7+parsesanity] " " sellprice "`r"
        gosub, msgcount
        if (a_index = 10) {
            send % prefix "confirmlist`r"
            gosub, msgcount
            break
        }
    }
    if (loopcount != 10) {
        send % prefix "confirmlist`r"
        gosub, msgcount
    }
    loopcount := 0
    return

marketbuy:
    sleepwin("Discord",20)
    setkeydelay, 120
    send, {ctrldown}c{ctrlup}
    loop, parse, clipboard, `n
    {
        parsesanity := 0
        loopcount += 1
        marketarray := strsplit(a_loopfield, a_space)
        if (marketarray[3]="alolan"||marketarray[3] = "mega"||marketarray[3] = "mime"||marketarray[4] = "mime")
            parsesanity += 1
        if (marketarray[5]="x"||marketarray[5]="y")
            parsesanity += 1
        send % prefix "market buy " marketarray[6+parsesanity] "`r"
        gosub, msgcount
        if (a_index = 10) {
            send % prefix "confirmbuy`r"
            gosub, msgcount
        }
    }
    if (loopcount != 10) {
        send % prefix "confirmbuy`r"
        gosub, msgcount
    }
    loopcount := 0
    return
    