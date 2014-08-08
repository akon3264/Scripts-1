require 'Utils'
require 'winapi'
require 'SKeys'
require 'vals_lib'
local uiconfig = require 'uiconfig'
local Q,W,E,R = 'Q','W','E','R'

    CFG, menu = uiconfig.add_menu('Urgot Config', 200)
    menu.keytoggle('LockOn', 'LockOn', Keys.F1, true)
    menu.permashow('LockOn')

function LockOn()
    for i = 1, objManager:GetMaxHeroes() do
        local enemy = objManager:GetHero(i)
        if enemy~=nil and enemy.team~=myHero.team and enemy.invulnerable==0 and enemy.visible==1 and enemy.dead==0 and GetDistance(enemy)<1175 and QRDY==1 and not IsBuffed(myHero,'TeleportHome',0) and not IsBuffed(myHero,'CaptureBeam',0) and IsBuffed(enemy,'UrgotCorrosiveDebuff_buf') then
            if CFG.LockOn then CastSpellXYZ('Q',enemy.x,0,enemy.z) end
        end
    end
end

SetTimerCallback('LockOn')
