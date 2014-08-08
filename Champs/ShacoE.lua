require 'Utils'
require 'winapi'
require 'SKeys'
 
local uiconfig = require 'uiconfig'
local send = require 'SendInputScheduled'

 
--========================================
 
function Main()
	target = GetWeakEnemy('MAGIC',625, "NEARMOUSE")
    if IsChatOpen() == 0 and target ~=nil and tostring(winapi.get_foreground_window()) == "League of Legends (TM) Client" then
        GetCD()
		useItem()
        DoSpells()
    end
end
 
function DoSpells()
    if((IsKeyDown(69) == 1) and ERDY and target ~= nil) then --Uses E and DFG
        UseItemOnTarget(3128, target)
	    CastSpellTarget('E',target)
    end    

end

function useItem(item)
    if ((GetInventoryItem(1) == item) and RDY1) then 
       CastSpellTarget("1", target)
    elseif ((GetInventoryItem(2) == item)  and RDY2) then 
       CastSpellTarget("2", target)
    elseif ((GetInventoryItem(3) == item)  and RDY3) then 
       CastSpellTarget("3", target)
    elseif ((GetInventoryItem(4) == item)  and RDY4) then 
       CastSpellTarget("4", target)
    elseif ((GetInventoryItem(5) == item)  and RDY5) then   
       CastSpellTarget("5", target)
    elseif ((GetInventoryItem(6) == item)  and RDY6) then 
       CastSpellTarget("6", target)
    elseif ((GetInventoryItem(7) == item)  and RDY7) then 
       CastSpellTarget("7", target)
    end
end

function GetCD()

    if myHero.SpellTimeE > 1 and GetSpellLevel('E') > 0 then  --Checking if E is ready to cast
        ERDY = 1
        else ERDY = 0
    end

    if myHero.SpellTime1 > 1.0 then -- Checks if items are on cooldown
    RDY1 = true 
    else RDY1 = false
    end
    if myHero.SpellTime2 > 1.0 then
    RDY2 = true
    else RDY2 = false
    end
    if myHero.SpellTime3 > 1.0 then
    RDY3 = true
    else RDY3 = false
    end
    if myHero.SpellTime4 > 1.0 then
    RDY4 = true
    else RDY4 = false
    end
    if myHero.SpellTime5 > 1.0 then
    RDY5 = true
    else RDY5 = false
    end
    if myHero.SpellTime6 > 1.0 then
    RDY6 = true
    else RDY6 = false
    end
    if myHero.SpellTime7 > 1.0 then
    RDY7 = true
    else RDY7 = false
    end

end
 
SetTimerCallback('Main')
