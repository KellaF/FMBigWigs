﻿local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "deDE")

if not L then return end

-- Core.lua
L["%s has been defeated"] = "%s wurde besiegt!"

L.bosskill = "Boss besiegt"
L.bosskill_desc = "Warnt, wenn der Boss besiegt wurde."
L.berserk = "Berserker"
L.berserk_desc = "Warnt, wenn der Boss zum Berserker wird."

L.already_registered = "|cffff0000WARNUNG:|r |cff00ff00%s|r (|cffffff00%s|r) existiert bereits als Modul in Big Wigs, aber irgend etwas versucht es erneut anzumelden. Dies bedeutet normalerweise, dass du zwei Kopien des Moduls aufgrund eines Fehlers beim Aktualisieren in deinem Addon-Ordner hast. Es wird empfohlen, jegliche Big Wigs Ordner zu löschen und dann von Grund auf neu zu installieren."

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = "Bei dir läuft ein offizieller Release von Big Wigs %s (revision %d)."
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = "Bei dir läuft ein ALPHA RELEASE von Big Wigs %s (revision %d)."
L["You are running a source checkout of Big Wigs %s directly from the repository."] = "Bei dir läuft ein Source Code Checkout von Big Wigs %s direkt aus dem Repository."
L["There is a new release of Big Wigs available (/bwv). You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "Eine neue Version von Big Wigs ist verfügbar (/bwv). Du kannst curse.com, wowinterface.com, wowace.com besuchen oder den Curse Client benutzen, um den Release zu bekommen."
L["Your alpha version of Big Wigs is out of date (/bwv)."] = "Deine Big Wigs Alpha ist veraltet (/bwv)."

L.tooltipHint = "|cffeda55fKlicken|r, um alle laufenden Module zurückzusetzen. |cffeda55fAlt+Klick|r, um alle laufenden Module zu beenden."
L["Active boss modules:"] = "Aktive Boss Module:"
L["All running modules have been reset."] = "Alle laufenden Module wurden zurückgesetzt."
L["All running modules have been disabled."] = "Alle laufenden Module wurden beendet."

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = "Es gibt Leute in deiner Gruppe mit veralteten Versionen oder ohne Big Wigs. Mehr Details mit /bwv."
L["Up to date:"] = "Aktuell:"
L["Out of date:"] = "Veraltet:"
L["No Big Wigs 3.x:"] = "Kein Big Wigs 3.x:"

L.coreAddonDisabled = "Big Wigs wird nicht richtig funktionieren, da das Addon %s deaktiviert ist. Du kannst es über die Addonkonfiguration im Charakterauswahlmenü aktivieren."

-- Options.lua
L["Big Wigs Encounters"] = "Big Wigs Module"
L["Customize ..."] = "Anpassen ..."
L["Profiles"] = "Profile"
L.introduction = "Willkommen bei Big Wigs, dort, wo die Bossbegegnungen rumschwirren. Bitte legen Sie Ihren Sicherheitsgurt an, stellen Sie die Rückenlehne gerade und genießen Sie den Flug. Wir werden Ihnen und Ihrer Raidgruppe bei der Begegnung mit Bossen zur Hand gehen und sie Ihnen als 7-Gänge-Menü zubereiten.\n"
L["Configure ..."] = "Einstellungen ..."
L.configureDesc = "Schließt das Interface-Fenster und lässt dich die Anzeigen für z.B. Leisten und Nachrichten einstellen.\n\nWenn du mehr Dinge hinter den Kulissen anpassen willst, kannst du Big Wigs im Menü links aufmachen und 'Anpassen ...' wählen."
L["Sound"] = "Sound"
L.soundDesc = "Nachrichten können zusammen mit Sounds erscheinen. Manche Leute finden es einfacher, darauf zu hören, welcher Sound mit welcher Nachricht einher geht, anstatt die Nachricht zu lesen.\n\n|cffff4411Auch wenn die Option ausgeschaltet ist, kann der normale Raidwarnungssound durch eingehende Raidwarnungen anderer Leute abgespielt werden. Diese Sounds sind allerdings unterschiedlich zu denen, die wir benutzen.|r"
L["Show Blizzard warnings"] = "Blizzards Warnungen anzeigen"
L.blizzardDesc = "Blizzard stellt eigene Nachrichten für einige Fähigkeiten in ein paar Begegnungen zur Verfügung. Unserer Meinung nach sind diese aber zu lang und erklären zu viel. Wir versuchen kurze, passende Nachrichten zu generieren, die das Gameplay nicht beeinflussen und die dir nicht sagen, was du tun sollst.\n\n|cffff4411Wenn die Option ausgeschaltet ist, werden Blizzards Warnungen nicht mehr mittig angezeigt, wohl aber immer noch im Chatfenster.|r"
L["Show addon warnings"] = "Addon Warnungen anzeigen"
L.addonwarningDesc = "Big Wigs und andere Bossmods senden ihre Nachrichten über den Raidwarnungschat an die Gruppe. Diese Nachrichten sind normalerweise von jeweils drei Sternen eingeschlossen (***), nach welchen Big Wigs sucht, um zu entscheiden, ob und welche Nachrichten geblockt werden.\n\n|cffff4411Diese Option anzuschalten resultiert in viel Spam und wird nicht empfohlen.|r"
L["Flash and shake"] = "Flash'n'shake"
L["Flash"] = "Flash"
L["Shake"] = "Shake"
L.fnsDesc = "Manche Fähigkeiten sind wichtig genug, deine volle Aufmerksamkeit zu genießen.\n\n|cffff4411Falls du mit eingeblendeten Namesplaketten spielst, wird die Shake-Funktion aufgrund von Restriktionen seitens Blizzard nicht funktionieren, der Bildschirm wird dann nur aufblitzen (Flash)."
L["Raid icons"] = "Schlachtzugs-Symbole"
L.raidiconDesc = "Einige Bossmodule benutzen Schlachtzugs-Symbole, um Spieler zu markieren, die von speziellem Interesse für deine Gruppe sind. Beispiele wären 'Bomben'-Effekte und Gedankenkontrolle. Wenn du diese Option ausschaltest, markierst du niemanden mehr.\n\n|cffff4411Trifft nur zu, sofern du Schlachtzugsleiter oder Assistent bist.|r"
L["Whisper warnings"] = "Warnungen flüstern"
L.whisperDesc = "Sendet geflüsterte Nachrichten über bestimmte Fähigkeiten einer Begegnung an Mitspieler, die diese betreffen. Denke an sowas wie 'Bomben'-Effekte usw.\n\n|cffff4411Trifft nur zu, sofern du Schlachtzugsleiter oder Assistent bist.|r"
L["Broadcast"] = "Nachrichten senden"
L.broadcastDesc = "Sendet alle Nachrichten von Big Wigs an den Schlachtzugswarnungschat.\n\n|cffff4411Trifft nur zu, sofern du Schlachtzugsleiter/Assistent oder in einer 5-Mann Gruppe bist.|r"
L["Raid channel"] = "Schlachtzugschat"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "Benutzt zum Senden von Nachrichten den Schlachtzugschat anstatt den Schlachtzugswarnungschat."
L["Minimap icon"] = "Minimap Symbol"
L["Toggle show/hide of the minimap icon."] = "Zeigt oder versteckt das Minimap Symbol."
L["Configure"] = "Einstellungen"
L["Test"] = "Testen"
L["Reset positions"] = "Positionen zurücksetzen"
L["Colors"] = "Farben"
L["Select encounter"] = "Wähle Begegnung"
L["List abilities in group chat"] = "Fähigkeiten im Chat auflisten"
L["Block boss movies"] = "Videos blockieren"
L["After you've seen a boss movie once, Big Wigs will prevent it from playing again."] = "Nachdem Sie eine Boss-Videosequenz einmal gesehen haben, wird diese zukünftig von BigWigs blockiert."
L["Prevented boss movie '%d' from playing."] = "Videosequenz '%d' wurde blockiert."
L["Ignore my role"] = "Rolle ignorieren"
L.ignoreroleDesc = "|cffff4411Nicht empfohlen.|r Bei Aktivierung werden alle Warnungen ausgegeben, egal welche Rolle ihr einnehmt, was bei manchen Bossen unübersichtlich sein kann."

L["BAR"] = "Leisten"
L["MESSAGE"] = "Nachrichten"
L["ICON"] = "Symbole"
L["WHISPER"] = "Flüstern"
L["SAY"] = "Sagen"
L["FLASHSHAKE"] = "Flash'n'shake"
L["PING"] = "Ping"
L["EMPHASIZE"] = "Stark hervorheben"
L["MESSAGE_desc"] = "Für die meisten Bossfähigkeiten gibt es eine oder mehrere Nachrichten, die Big Wigs anzeigt. Wenn du diese Option deaktivierst, wird keine der zugehörigen Nachrichten angezeigt."
L["BAR_desc"] = "Leisten werden für Bossfähigkeiten angezeigt, sofern sie sinnvoll sind. Falls diese Fähigkeit eine Leiste besitzt, die du verstecken möchtest, kannst du die Option deaktivieren."
L["FLASHSHAKE_desc"] = "Manche Fähigkeiten sind wichtiger als andere. Falls aktiviert, blitzt und wackelt dein Bildschirm, sobald diese Fähigkeit aktiv ist oder genutzt wird."
L["ICON_desc"] = "Big Wigs kann Spieler durch ein Symbol markieren, die von Fähigkeiten betroffen sind. Das erleichtert das Bemerken."
L["WHISPER_desc"] = "Manche Effekte sind wichtig genug, dass Big Wigs eine geflüsterte Nachricht an die betroffene Person schickt."
L["SAY_desc"] = "Chatblasen sind leicht zu sehen. Big Wigs benutzt eine /sagen-Nachricht, um Leute um dich herum auf Effekte auf dir aufmerksam zu machen."
L["PING_desc"] = "Manchmal können bestimmte Orte wichtig sein und Big Wigs kann dann die Minimap pingen, so dass die Leute wissen, wo du bist."
L["EMPHASIZE_desc"] = "Sobald aktiviert, werden entsprechende Nachrichten und Leisten stark HERVORGEHOBEN. Nachrichten werden größer, Leisten werden blinken und eine andere Farbe bekommen und Sounds werden als Countdown verwendet. Du wirst die Fähigkeit definitiv bemerken."
L["PROXIMITY"] = "Näheanzeige"
L["PROXIMITY_desc"] = "Fähigkeiten von Begegnungen erfordern manchmal, dass alle Mitspieler auseinander stehen. Die Näheanzeige wird speziell für diese Fähigkeit eingestellt, so dass du auf einen Blick siehst, ob du sicher bist oder nicht."
L["ALTPOWER"] = "Alternative Energie"
L["ALTPOWER_desc"] = "In manchen Bosskämpfen muss man auf eine Alternative Energie achten. Diese Anzeige zeigt einem hier den Status dieser Enegie des ganzen Raids."
L["Advanced options"] = "Erweiterte Optionen"
L["<< Back"] = "<< Zurück"

L["About"] = "Über"
L["Main Developers"] = "Hauptentwickler"
L["Developers"] = "Entwickler"
L["Maintainers"] = "Wartung"
L["License"] = "Lizenz"
L["Website"] = "Website"
L["Contact"] = "Kontakt"
L["See license.txt in the main Big Wigs folder."] = "Siehe license.txt im Big Wigs Hauptverzeichnis."
L["irc.freenode.net in the #wowace channel"] = "irc.freenode.net im #wowace Channel"
L["Thanks to the following for all their help in various fields of development"] = "Danke an die folgenden Leute für ihre Hilfe in verschiedenen Entwicklungsbereichen:"

