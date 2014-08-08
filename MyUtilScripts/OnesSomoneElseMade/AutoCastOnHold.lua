--Made by Code BK-201
--Only self-cast

--This works for Eve and Hecarim's Qs
 
require 'Utils'
require 'winapi'
require 'SKeys'
 
local uiconfig = require 'uiconfig'
local send = require 'SendInputScheduled'
 
 
--========================================
 
function Main()
    if IsChatOpen() == 0 and tostring(winapi.get_foreground_window()) == "League of Legends (TM) Client" then
        GetCD()
        DoSpells()
    end
end
 
function DoSpells()
    if(CfgSettings.AutoQ and CfgSettings.UseAutoQ and QRDY) then
        --send.key_press(SKeys.Q)
        CastSpellXYZ('Q',myHero.x,myHero.y,myHero.z)        
    end
    if(CfgSettings.AutoW and CfgSettings.UseAutoW and WRDY) then
        --send.key_press(SKeys.W)
        CastSpellXYZ('W',myHero.x,myHero.y,myHero.z)
    end
     if(CfgSettings.AutoE and CfgSettings.UseAutoE and ERDY) then
        --send.key_press(SKeys.E)
        CastSpellXYZ('E',myHero.x,myHero.y,myHero.z)
    end    
     if(CfgSettings.AutoR and CfgSettings.UseAutoR and RRDY) then
        --send.key_press(SKeys.R)
        CastSpellXYZ('R',myHero.x,myHero.y,myHero.z)
    end
end
 
function GetCD()
    if myHero.SpellTimeQ > 1 and GetSpellLevel('Q') > 0 then
        QRDY = 1
        else QRDY = 0
    end
    if myHero.SpellTimeW > 1 and GetSpellLevel('W') > 0 then
        WRDY = 1
        else WRDY = 0
    end
    if myHero.SpellTimeE > 1 and GetSpellLevel('E') > 0 then
        ERDY = 1
        else ERDY = 0
    end
    if myHero.SpellTimeR > 1 and GetSpellLevel('R') > 0 then
        RRDY = 1
    else RRDY = 0 end
end
 
CfgSettings, menu = uiconfig.add_menu('Auto Spell')
menu.keydown('AutoQ', 'AutoQ', Keys.Q)
menu.keydown('AutoW', 'AutoW', Keys.W)
menu.keydown('AutoE', 'AutoE', Keys.E)
menu.keydown('AutoR', 'AutoR', Keys.R)
 
menu.checkbutton('UseAutoQ', 'UseAutoQ', false)
menu.checkbutton('UseAutoE', 'UseAutoE', false)
menu.checkbutton('UseAutoW', 'UseAutoW', false)
menu.checkbutton('UseAutoR', 'UseAutoR', false)
 
SetTimerCallback('Main')
