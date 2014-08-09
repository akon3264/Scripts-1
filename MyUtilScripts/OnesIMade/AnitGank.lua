--[[
	===================================================================
	|           Sida's Enemy Alert + KoolKaracter's Revision          |
	|                           Version 1                             |
	===================================================================
	
	Change Log:
	v1 - Took Sida's Enemy Alert and changed menus to new uiconfig style
	
]]
require "Utils"
local uiconfig = require 'uiconfig'
CfgAlertSettings, menu = uiconfig.add_menu('Alert Options', 200)
menu.checkbutton("Alerts_ON", "Enable Alerts", true)
menu.checkbox("Beep_ON", "Play Beep", true)
menu.checkbox("Text_ON", "Draw text above your head?", true)
menu.slider("MissingForX", "Seconds until considered missing", 1, 20, 5)
menu.slider("DrawTimeX", "Seconds to keep circle displayed", 1, 10, 5)


--[[ Variables ]]
local enemies = {}

function OnTick()
	local tick = GetTickCount()
	if CfgAlertSettings.Alerts_ON then
		for i = 1, objManager:GetMaxHeroes(), 1 do
		local object = objManager:GetHero(i)
			if object.team ~= myHero.team and object.dead == 0 then
				if not enemies[object.name] then 
					enemies[object.name] = {missing = true, draw = tick, lastVisible = 0, object = object, doDraw = false} 
				end
				local enemy = enemies[object.name]
				if object.visible == 1 and GetDistance(object) < 2500 then
					if enemy.missing then
						if CfgAlertSettings.Beep_ON then 
							PlaySound("Beep") 
						end
						enemy.draw = tick	
						enemy.doDraw = true
					elseif tick - enemies[object.name].draw > CfgAlertSettings.DrawTimeX * 1000 then
						enemy.doDraw = false
					end
					enemy.missing = false
					enemy.lastVisible = tick
					
				elseif tick - enemies[object.name].lastVisible > CfgAlertSettings.MissingForX * 1000 then
					enemy.missing = true
				end	
			end
		end
	end
end

function OnDraw()
	for _,enemy in pairs(enemies) do
		if enemy.doDraw then
			for t = 0, 10 do	
				DrawCircleObject(enemy.object, 1250 + t, 2)
				if CfgAlertSettings.Text_ON then
					DrawText("ENEMY INCOMING!!!", myHero.x, myHero.y, Color.Red)
				end
			end
		end
	end
end

SetTimerCallback("OnTick")
