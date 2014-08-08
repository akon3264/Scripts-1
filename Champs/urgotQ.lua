require 'Utils'
require 'vals_lib'
local uiconfig = require 'uiconfig'
if myHero.name ~= 'Urgot' then return end

    CFG, menu = uiconfig.add_menu('Urgot Config', 200)
    menu.keytoggle('LockOn', 'LockOn', Keys.F1, true)
    menu.permashow('LockOn')

function LockOn()
	getCD()
    for i = 1, objManager:GetMaxHeroes() do
        local enemy = objManager:GetHero(i)
        if enemy~=nil and enemy.team~=myHero.team and IsBuffed(enemy,'UrgotCorrosiveDebuff_buf', 0) and QRDY and enemy.visible==1 and enemy.invulnerable==0 and (GetDistance(myHero, enemy) < 1175)  then
            if CFG.LockOn then CastSpellXYZ('Q',enemy.x,enemy.y,enemy.z) end
        end
    end
end

function getCD()
    if myHero.SpellTimeQ > 1.0 then 
	QRDY = true
    else QRDY = false
    end	
end


SetTimerCallback('LockOn')
