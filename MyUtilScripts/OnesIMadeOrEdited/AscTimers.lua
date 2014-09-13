--NewGen Timers
--Made by Code BK-201 

--require 'Utils'
local uiconfig = require 'uiconfig'
require 'runrunrun'
require 'skeys'
local send = require 'SendInputScheduled'

local prefixes = {}
local track = {}

local messageDrag = "1 min drag"
local messageBaron = "Baron ~1 min"

local startTick = GetTickCount()

local Map = GetMap() --0=ProvingGrounds; 1=SummonersRift; 2=CrystalScar; 3=TwistedTreeline
printtext("\n\nMap id: "..Map.."\n\n")
if Map == 1 then
	Inhibits = {
	--BLU 
		Order_Top = {x = 840, y = 101, z = 3359, team = 100, object = nil, status = nil, shatter = 0},
		Order_Mid = {x = 2788, y = 94, z = 2981, team = 100, object = nil, status = nil, shatter = 0},
		Order_Bot = {x = 3037, y = 98, z = 1035, team = 100, object = nil, status = nil, shatter = 0},
	--RED
		Chaos_Top = {x = 10959, y = 91, z = 13435, team = 200, object = nil, status = nil, shatter = 0},
		Chaos_Mid = {x = 11239, y = 92, z = 11471, team = 200, object = nil, status = nil, shatter = 0},
		Chaos_Bot = {x = 13209, y = 107, z = 11175, team = 200, object = nil, status = nil, shatter = 0}
	}

	prefixes[1] = 'Dragon'
	prefixes[2] = 'AncientGolem'
	prefixes[3] = 'LizardElder'
	prefixes[4] = 'Golem'
	prefixes[5] = 'GiantWolf'
	prefixes[6] = 'Wraith'
	prefixes[7] = 'Worm'  --Baron
	prefixes[8] = 'GreatWraith' --Wight
	prefixes[9] = 'YoungLizard' --sth
	prefixes[10] = 'LesserWraith' --sth
	prefixes[11] = 'SmallGolem' --sth
	prefixes[12] = 'Wolf' --sth 
elseif Map == 2 then --DOM   
	prefixes[1] = 'OdinShieldRelic'
	prefixes[2] = 'AscRelic'
	
elseif Map == 3 then --TT
	Altars = {
		Left_Altar = {x = 1037, y = 400, z = 6730, object = nil, status = nil, side = left, lockedT = 0},
		Right_Altar = {x = 970, y = 475, z = 6750, object = nil, status = nil, side = right, lockedT = 0}
		}
		
	prefixes[1] = 'TT_Relic' --TT's Ghost Relic/Heal
	prefixes[2] = 'TT_Spiderboss' --TT Vilemaw
	
		
elseif Map == 6 then --ARAM
	prefixes[1] = 'HA_AP_HealthRelic'
else return end 

	--MENU
	CfgSettings, menu = uiconfig.add_menu('NewGen Timer', 200)
	menu.keytoggle('AutoChat', 'Remind time to spawn', Keys.O, true)
	menu.permashow("AutoChat")
	menu.keytoggle('InitChat', 'Announce spawn time', Keys.P, true)
	menu.permashow("InitChat")
	menu.keytoggle('SuicideTimer', 'SuicideTimer', Keys.M, false)
	menu.permashow("SuicideTimer")

function OnTick()
	--printtext("\nGame Time: "..GetGameTime())
	DrawThings()
	run_every(0.2, Main)
	if (Map == 1) then	
		InhibTimer()
	end	
	if Map == 3 then
		AltarTimer()
	end
	SuicideTimer()	
end

function Main()	
	--printtext("\nTickcount: "..GetTickCount())	
	Tick = GetTickCount()	
	JungleTimer()

	if (Map == 1) then
		InhibitAdd()
	end
	if (Map == 3) then
		AltarAdd()
	end
end

local DrawBlue = false
local DrawList = {}

function DrawThings()
	local tempTable = {}	
	for i,monster in pairs(DrawList) do
		if monster ~= nil and monster.x ~= nil and monster.z ~= nil then			
      		local x, y = screen_position(monster)
		 	local tempTime = TimeFormat(monster.time)
		 	DrawText(tempTime,monster.x,monster.y,Color.White)
		 	
          	    --printtext("\nDrawing: "..monster.name.." x: "..monster.x.." z: "..monster.z)
				DrawTextMinimap(tempTime,monster.x,monster.z,Color.Yellow) 
			
			local remTime = math.floor((monster.time-GetTickCount())/1000)
			--printtext("\nremTime: "..remTime)
		 	if remTime <= 0 then
		 		DrawList[i] = nil --useless		 	
		 		printtext("\nRemoved!")
		 	else
			 	if(Map == 1) then		 					
					if (remTime <= monster.annTime and CfgSettings.AutoChat and monster.announced == false) then --==
						if (monster.name == prefixes[1]) then
							send_message(messageDrag)
							monster.announced = true;						
						elseif(monster.name == prefixes[7])	then
							send_message(messageBaron)
							monster.announced = true;					
					    end
					end 
				end	
				table.insert(tempTable, monster) 	 				 			
		 	end
		end	 	 
	end
	DrawList = {}
	for i,monster in pairs(tempTable) do
		if monster ~= nil then --should never happen (useless check)
			table.insert(DrawList, monster)					
		end
	end	
end

--anouncing =============
local delay = 180
function openchat()
    send.key_press(0x1c)
    send.wait(delay) -- needed, 100
end
       
       
function closechat()
    send.key_press(0x1c)
    send.wait(delay) -- needed, 100
end

function send_message(s)
    --print('sending_spam')
	printtext("\n(NewGen Timer) Announcing time!\n")					
	if tostring(winapi.get_foreground_window()) == "League of Legends (TM) Client" then
	    if(IsChatOpen()==0) then    	
			openchat()
		else
			closechat()
			openchat()		
		end
	    send.text(s)
		send.wait(delay+delay) -- needed, not 100, 200
		closechat()
		send.tick()
		return true
	else
		return false
	end
end
--=======================

function JungleTimer()
	local tempValid = true	
   	for key,t in pairs(track) do
        local o = t.object
        local still_valid = false
        if IsMonster(o) and is_alive(o) and is_valid(o) then 
        	local current_key = get_key(o)
        	if key == current_key then
                still_valid = true        		 
            end
      	end
        if still_valid then
            --printtext("Alive")
            --printtext("\ncharName tracking: "..o.charName..o.x)
        else
        	tempValid = true
	   		for key2,t2 in pairs(track) do
	   			if(key ~= key2) then		        	
		        	local o2 = t2.object	   			
		   			if(GetDistance(o, o2) < 600) then
	        			--printtext("\nDist: "..GetDistance(o, o2).." from "..o.charName.." to "..o2.charName)
		   				tempValid = false
		   			end	   			
			    end 
	        end		    	   			 
			if(tempValid) then	
	        	--printtext("\nDead what: "..WhatMonster(o))            

	        	local TempTime = GetRespawnTime(o)
	        	local announceTime = math.random(58,62)

	        	--Spawn time
	        	if((WhatMonster(o) == prefixes[7] or WhatMonster(o) == prefixes[1]) and CfgSettings.InitChat and Map == 1) then
		        	--send_message(TimeFormat(TempTime))    	
		        end
	        	
	        	tempObj = { x = o.x, y = o.y, z = o.z, time = TempTime, name = WhatMonster(o), announced = false, annTime = announceTime} --, name = o.charName
	        	--printtext("\nDead "..tempObj.name)
	        	--printtext("\nObj time: "..tempObj.time) 
	        	table.insert(DrawList, tempObj)
	        	track[key] = nil
	        else
	        	track[key] = nil
	        	--printtext("\nNot alone! "..o.charName)
	        end 
	    end        	  	
    end  
end

local lastHP = myHero.maxHealth
local countdown = 0

function SuicideTimer()
	if myHero.health < lastHP then
		lastHP = myHero.health
		countdown = GetTickCount() + 10000
	end
	if countdown > 0 and CfgSettings.SuicideTimer then		
		DrawTextObject(TimeFormat(countdown),myHero,Color.White)		
	end
	if (countdown-GetTickCount()) < 0 then
		countdown = 0
	end
end

--not needed
function screen_position(unit)
    if unit == nil then return nil end
    local x, y, z = unit.x, unit.y, unit.z
    if x ~= nil and y ~= nil and z ~= nil then
        xScreen = GetScreenX()/2+(x-GetWorldX())
        yScreen = GetScreenY()/2-(z-GetWorldY())-y
        --adjust by percent--
        xScreen = xScreen-((xScreen-GetScreenX()/2)/100*30)
        yScreen = yScreen-((yScreen-GetScreenY()/2)/100*30)
        return xScreen, yScreen
    end
end

function InhibTimer()
--Tick = GetTickCount()
	for i,inhibit in pairs(Inhibits) do		
		if inhibit.object ~= nil then
			if inhibit.status == 'destoryed' then
				--if CfgSettings.Minimap then
					if Map == 1 then
						if inhibit.team == 100 then 
						DrawTextMinimap(TimeFormat(inhibit.shatter),inhibit.x-100,inhibit.z-100,Color.Yellow)
						else 
						DrawTextMinimap(TimeFormat(inhibit.shatter),inhibit.x-600,inhibit.z-600,Color.Yellow) 
						end
					end
				--end
				if inhibit.shatter >= Tick then 
					DrawTextObject('\n\n\n\n\n\n\n'..TimeFormat(inhibit.shatter),inhibit.object,Color.White)
					else 
					inhibit.status = 'spawned'
				end	
			end		
		end
	end	
end

function AltarTimer()
--Tick = GetTickCount()
	for i,altar in pairs(Altars) do		
		if altar.object ~= nil then
			if altar.status == 'locked' then
				--if CfgSettings.Minimap then
					if Map == 3 then
						if altar.side == 'left' then 
						DrawTextMinimap(TimeFormat(altar.lockedT),altar.x-100,altar.z-100,Color.Yellow)
						else 
						DrawTextMinimap(TimeFormat(altar.lockedT),altar.x-600,altar.z-600,Color.Yellow) 
						end
					end
				--end
				if altar.lockedT >= Tick then 
					DrawTextObject('\n\n\n\n\n\n\n'..TimeFormat(altar.lockedT),altar.object,Color.White)
					else 
					altar.status = 'owned'
				end	
			end		
		end
	end	
end

function AltarAdd()
	for i,altar in pairs(Altars) do	
		if altar.object == nil then
			for i = 1, objManager:GetMaxObjects(), 1 do
				object = objManager:GetObject(i)
				if object ~= nil then
					if (object.charName == 'TT_altar_owned_blue.troy' or object.charName == 'TT_altar_owned_purple.troy') and altar.side == 'left' and GetDistance(altar, object) < 150 then
						altar.object = object
						altar.status = 'owned'
						print("Left Altar Owned: ",altar,object)
					elseif (object.charName == 'TT_altar_owned_blue.troy' or object.charName == 'TT_altar_owned_purple.troy') and altar.side == 'right' and GetDistance(altar, object) < 150 then
						altar.object = object
						altar.status = 'owned'
						print("Right Altar Owned: ",altar,object)
					end					
				end 
			end		
		end
	end
end

function InhibitAdd()
	for i,inhibit in pairs(Inhibits) do	
		if inhibit.object == nil then
			for i = 1, objManager:GetMaxObjects(), 1 do
				object = objManager:GetObject(i)
				if object ~= nil then
					if object.charName == 'Order_Inhibit_Gem.troy' and inhibit.team == 100 and GetDistance(inhibit, object) < 100 then
						inhibit.object = object
						inhibit.status = 'spawned'
						--print("BLUE Team Inhibitor Set: ",inhibit,object)
					elseif object.charName == 'Chaos_Inhibit_Gem.troy' and inhibit.team == 200 and GetDistance(inhibit, object) < 100 then
						inhibit.object = object
						inhibit.status = 'spawned'
						--print("RED Team Inhibitor Set: ",inhibit,object)
					end					
				end
			end		
		end
	end
end

function OnCreateObj(o)
	--Inhibs
	if Map == 1 then
		check_inhib(o)
	end
	if Map == 3 then
		check_altar(o)
	end
	
	if IsMonster(o) then	
		--printtext("\ncharName tracking: "..o.charName.." x: "..o.x.." z: "..o.z)
		start_tracking(o)
	end 
end

function GetRespawnTime(o)
	local tempPrefix = WhatMonster(o)	
	local tempTime = 0
		--Respawn times in miliseconds
	if(Map == 1) then
		if tempPrefix == prefixes[1] then --Dragon
			tempTime = GetTickCount()+360000
		elseif tempPrefix == prefixes[2] then --AncientGolem
			tempTime = GetTickCount()+300000
		elseif tempPrefix == prefixes[3] then --LizardElder
			tempTime = GetTickCount()+300000
		elseif tempPrefix == prefixes[4] then --Golem
			tempTime = GetTickCount()+50000
		elseif tempPrefix == prefixes[5] then --GiantWolf
			tempTime = GetTickCount()+50000
		elseif tempPrefix == prefixes[6] then --WraithWight
			tempTime = GetTickCount()+50000
		elseif tempPrefix == prefixes[7] then --Worm (Baron)
			tempTime = GetTickCount()+420000
		elseif tempPrefix == prefixes[8] then --Wight
			tempTime = GetTickCount()+50000
		elseif tempPrefix == prefixes[9] then --YoungLizard
			tempTime = GetTickCount()+300000
		elseif tempPrefix == prefixes[10] then --LesserWraith
			tempTime = GetTickCount()+50000	
		elseif tempPrefix == prefixes[11] then --SmallGolem
			tempTime = GetTickCount()+50000	
		elseif tempPrefix == prefixes[12] then --Wolf
			tempTime = GetTickCount()+50000	
		end
	elseif(Map == 2) then
		if tempPrefix == prefixes[1] then --
			tempTime = GetTickCount()+33000
		elseif tempPrefix == prefixes[2] then
			tempTime = GetTickCount()+30000
		elseif tempPrefix == prefixes[3] then
			tempTime = GetTickCount()+30000			
		end
		
	elseif(Map == 3) then
		if tempPrefix == prefixes[1] then --Ghost Relic
			tempTime = GetTickCount()+90000
		end	
		if tempPrefix == prefixes[2] then -- Vilemaw
			tempTime = GetTickCount()+300000
		end
		
	elseif(Map == 6) then
		if tempPrefix == prefixes[1] then -- Relic
			tempTime = GetTickCount()+40000
		end
	end
		return tempTime
end


function starts_with(s, sub)
    return s:sub(1,string.len(sub))==sub
end

function IsMonster(o)
    if o ~= nil and is_valid(o) and o.name ~= nil and o.charName ~= nil then
        for i=1,#prefixes do
            local prefix = prefixes[i]
            -- name is the short thing, charName is name+numbers
            if starts_with(o.name, prefix) then --or starts_with(o.charName, prefix)
            	--printtext("\nFound prefix: "..prefix)
                return true
            end
        end
    end
    return false
end

function WhatMonster(o)
if o ~= nil and is_valid(o) and o.name ~= nil and o.charName ~= nil then
        for i=1,#prefixes do
            local prefix = prefixes[i]
            -- name is the short thing, charName is name+numbers
            if starts_with(o.name, prefix) then
                return prefix
            end
        end
    end
    return nil
end

function start_tracking(o)
    local key = get_key(o)    
    track[key] = {object=o, button_value=default_button_value, started=os.clock()} --GetRespawnTime(o)		
end

function get_key(o)
    return tostring(o.id)..','..o.name..','..o.charName
end

function check_altar(object)
	if object ~= nil then
		if object.charName == 'TT_Lock_Blue_L.troy' or object.charName == 'TT_Lock_Purple_L.troy' then
			for i,altar in pairs(Altars) do
				if altar.object ~= nil and altar.side == left and GetDistance(object, altar) < 150 then
					altar.status = 'locked'
					altar.lockedT = GetTickCount()+90000
					printtext('Alter Left is locked')
				end
			end
		elseif object.charName == 'TT_Lock_Blue_R.troy' or object.charName == 'TT_Lock_Purple_R.troy' then
			for i,altar in pairs(Altars) do
				if altar.object ~= nil and altar.side == right and GetDistance(object, altar) < 150 then
					altar.status = 'locked'
					altar.lockedT = GetTickCount()+90000
					printtext('Alter Right is locked')
				end
			end
		end		
	end
end


function check_inhib(object)
	if object ~= nil then
		if object.charName == 'Chaos_Inhibit_Crystal_Shatter.troy' then
			for i,inhibit in pairs(Inhibits) do
				if inhibit.object ~= nil and inhibit.team == 100 and GetDistance(object, inhibit) < 100 then
					inhibit.status = 'destoryed'
					inhibit.shatter = GetTickCount()+240000
					--print('BLUE Team Inhibitor is destoryed')
				end
			end
		elseif object.charName == 'Order_Inhibit_Crystal_Shatter.troy' then
			for i,inhibit in pairs(Inhibits) do
				if inhibit.object ~= nil and inhibit.team == 200 and GetDistance(object, inhibit) < 100 then
					inhibit.status = 'destoryed'
					inhibit.shatter = GetTickCount()+240000
					--print('PURPLE Team Inhibitor is destoryed')
				end
			end
		end		
	end
end

function is_alive(o)
    return o.dead == 0 and o.health > 0
end

function is_valid(o)
    return o.valid == 1
end


function TimeFormat(Time)
	if Time ~= nil and Time > 0 then	
		Seconds = math.floor((Time-GetTickCount())/1000)	
        if Seconds > 59 then
			Minutes = math.floor(Seconds/60)
			Seconds = math.floor(Seconds-(math.floor(Seconds/60)*60))
			if Seconds < 10 then Seconds = "0"..Seconds end
			Result = Minutes..":"..Seconds
        else
			if Seconds < 10 then Seconds = "0"..Seconds end
			Result = "0:"..Seconds
        end
        return Result
	end
	return "0:00"
end

for i=1,objManager:GetMaxObjects() do OnCreateObj(objManager:GetObject(i)) end

SetTimerCallback('OnTick')
