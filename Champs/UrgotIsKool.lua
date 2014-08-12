local ScriptName = 'UrgotIsKool'
local Version = '2.0'
local Author = Koolkaracter
--yupdate = * 2.0 https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/UrgotIsKool.lua https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/UrgotVersion.lua

if myHero.name ~= 'Urgot' then return end
require 'Utils'
require 'vals_lib'
require 'yprediction'

local YP = YPrediction()
local Qrange, Qwidth, Qspeed, Qdelay = 975, 80, 1550, 0.5 
local Erange, Ewidth, Espeed, Edelay = 900, 150, 1400, 0.5
local uiconfig = require 'uiconfig'

    CFG, menu = uiconfig.add_menu('Urgot Config', 200)
    menu.keytoggle('LockOn', 'LockOn', Keys.F1, true)
	menu.keydown('CastQ', 'Cast Q', Keys.A)
	menu.keydown('CastE', 'Cast E', Keys.T)
	menu.keydown('TargetSelector', 'TargetSelector', 0x01)
    menu.permashow('LockOn')

function Main()
	TargetSelector()
	LockOn()
	if CFG.CastQ then 
		CastQ()
	end
	if CFG.CastE then 
		CastE()
	end
end
		
function CastQ()
	if target ~= nil then 
		CastPosition,  HitChance,  Position = YP:GetLineCastPosition(target, Qdelay, Qwidth, Qrange, Qspeed, myHero, true)
		if CastPosition and HitChance >= 2 then 
			local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
			CastSpellXYZ('Q', x, y, z)
		end
	end 
end

function CastE()
	if target ~= nil then 
		CastPosition, HitChance, Position = YP:GetCircularCastPosition(target, Edelay, Ewidth, Erange, Espeed, myHero, false)
		if CastPosition and HitChance >= 2 then
			local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z
			CastSpellXYZ('E', x, y, z)
		end
	end
end

function LockOn()
	GetCD()
    for i = 1, objManager:GetMaxHeroes() do
        local enemy = objManager:GetHero(i)
		if IsBuffed(target, 'UrgotCorrosiveDebuff_buf', 0) and QRDY and target.visible == 1 and target.invulnerable==0 and (GetDistance(myHero, target) < 1175) then 
			if CFG.LockOn then CastSpellXYZ('Q',target.x,target.y,target.z) end
        elseif enemy~=nil and enemy.team~=myHero.team and IsBuffed(enemy,'UrgotCorrosiveDebuff_buf', 0) and QRDY and enemy.visible==1 and enemy.invulnerable==0 and (GetDistance(myHero, enemy) < 1175)  then
            if CFG.LockOn then CastSpellXYZ('Q',enemy.x,enemy.y,enemy.z) end
        end
    end
end

function TargetSelector()
   if target == nil then
      target = GetWeakEnemy('PHYS',1000)
   end
   if CFG.TargetSelector then 
      for i = 1, objManager:GetMaxHeroes() do
         local enemy = objManager:GetHero(i)
         if enemy~=nil and enemy.team~=myHero.team and enemy.visible==1 and GetDistance(enemy,mousePos)<150 then
            target = enemy
            printtext('\n'..target.name.. ' - '..GetTickCount())           
         end
      end
	 end
   if target~=nil then
      if target.dead==1 or myHero.dead==1 then 
         target = nil 
      else
         CustomCircle(100,10,Color.Yellow,target)
      end 
   end    
end                        

SetTimerCallback('Main')

