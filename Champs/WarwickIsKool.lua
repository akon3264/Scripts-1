-- ************************** LBC META *****************************
-- * lbc_name = WarwickIsKool.lua
-- * lbc_version = 1.00
-- * lbc_date = 09/25/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 3 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = KoolKaracter
-- * lbc_champion = Warwick // if this script is for a special champ
-- * lbc_tags = warwick, WW, bruiser, jungler, tank, AP, AD, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4452
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/WarwickIsKool.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************

local ScriptName = 'WarwickIsKool'									
local Version = '1.0'												
local Author = 'Koolkaracter'												
--[[	
     
 __      __                      .__        __     .___          ____  __.            .__   
/  \    /  \_____ _________  _  _|__| ____ |  | __ |   | ______ |    |/ _|____   ____ |  |  
\   \/\/   /\__  \\_  __ \ \/ \/ /  |/ ___\|  |/ / |   |/  ___/ |      < /  _ \ /  _ \|  |  
 \        /  / __ \|  | \/\     /|  \  \___|    <  |   |\___ \  |    |  (  <_> |  <_> )  |__
  \__/\  /  (____  /__|    \/\_/ |__|\___  >__|_ \ |___/____  > |____|__ \____/ \____/|____/
       \/        \/                      \/     \/          \/          \/                  
                                                                                                         
]]



require 'yprediction'
require 'spell_damage'
require 'winapi'
require 'SKeys'
require 'Utils'
require 'vals_lib'
local yayo = require 'yayo'
local uiconfig = require 'uiconfig'
local send = require 'SendInputScheduled'
local YP = YPrediction()
local target = nil
local attempts = 0
local lastAttempt = 0
local Q,W,E,R = 'Q','W','E','R'
local skillOrder = {}
local qRange, wRange, eRange, rRange = 400, 200, nil, 650      						
local qSpeed, wSpeed, eSpeed, rSpeed = nil, nil, nil, nil     						
local qDelay, wDelay, eDelay, rDelay = .5, .5, .5, .50          						 
local qWidth, wWidth, eWidth, rWidth = 100, nil, 250, 575								
local qCollision, wCollision, eCollision, rCollision = false, false, false, false		
local tsRange = 700 		
local smitedamage = {390, 410, 430, 450, 480, 510, 540, 570, 600, 640, 680, 720, 760, 800, 850, 900, 950, 1000}	
local prefixes = { 'Worm', 'Dragon', 'AncientGolem', 'LizardElder' }																		

------------------------------------------------------------  
---------------------------Menu-----------------------------
------------------------------------------------------------
Cfg, menu = uiconfig.add_menu('Warwick Is Kool', 250)
local submenu = menu.submenu('1. Skill Options', 150)
submenu.label('lbS1', '--AutoCarry Mode--')
submenu.checkbox('Q_AC_ON', 'Use Q', true)
submenu.checkbox('W_AC_ON', 'Use W', true)
submenu.checkbox('R_AC_ON', 'Use R', true)
submenu.label('lbS2', '----Mixed Mode----')
submenu.checkbox('Q_M_ON', 'Use Q', true)
submenu.checkbox('W_M_ON', 'Use W', true)
submenu.checkbox('R_M_ON', 'Use R', false)
submenu.label('lbS3', '----Lane Clear----')
submenu.checkbox('Q_LC_ON', 'Use Q', false)
submenu.checkbox('W_LC_ON', 'Use W', true)
submenu.label('lbS4', '----Last Hit----')
submenu.checkbox('Q_LH_ON', 'Use Q', false)

local submenu = menu.submenu('2. Target Selector', 300)
submenu.slider('TS_Mode', 'Target Selector Mode', 1,2,1, {'TS Primary', 'Get Weakest'})
submenu.slider('TS_Mode_Type', 'Damage Type', 1,2,1, {'Physical', 'Magic'})
submenu.checkbox('TS_Circles', 'Use Circles To ID Target(s)', true)
submenu.keydown('TS', 'Target Selection Hotkey', 0x01)

local submenu = menu.submenu('3. Draw Range', 150)
submenu.checkbox('qRange', 'Show Q Range ', true)
submenu.slider('qRangeColor', 'Color of Q Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('rRange', 'Show R Range', false)
submenu.slider('rRangeColor', 'Color of R Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('smiteRange', 'Show Smite Range', false)
submenu.slider('smiteRangeColor', 'Color of Smite Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})

local submenu = menu.submenu('4. Item Options', 225)
submenu.label('lbI1', '--Offensive Items--')
submenu.checkbox('BC', '---Bilgewater Cutlass---', true)
submenu.checkbox('BORK', '---Blade Of The Ruined King---', true)
submenu.checkbox('BFT', '---Blackfire Torch---', true)
submenu.checkbox('DFG', '---Deathfire Grasp---', true)
submenu.checkbox('HG', '---Hextech Gunblade---', true)
submenu.checkbox('RO', '---Randuins Omen---', true)
submenu.checkbox('RH', '---Ravenous Hydra---', true)
submenu.checkbox('T', '---Tiamat---', true)
submenu.checkbox('TWS', '----Twin  Shadows----', true)
submenu.checkbox('YG', '---Youmuu\'s Goshtblade---', true)
submenu.checkbox('ACItem_ON', 'Use Items in A/C mode', true)
submenu.checkbox('MItem_ON', 'Use Items in Mixed mode', true)
submenu.label('lbI1', '--Defensive Items--')
submenu.checkbox('ZH', 'Auto Use Zhonyas/Witchcap', true)
submenu.slider('ZHValue', 'Use Zhonyas/Witchcap at X% health', 0, 100, 20)

local submenu = menu.submenu('5. Summoner Spell Options', 300)
submenu.checkbox('Auto_Ignite_ON', 'Ignite', true)
submenu.checkbutton('Auto_Ignite_Self_ON', 'Ignite Self Cast (creates circle when killable)', false)
submenu.checkbox('Auto_Exhaust_ON', 'Exhaust', true)
submenu.slider('AutoExhaustValue', 'Auto Exhaust Value', 0, 100, 30)
submenu.checkbox('Auto_Barrier_ON', 'Barrier', true)
submenu.slider('AutoBarrierValue', 'Auto Barrier Value', 0, 100, 15)
submenu.checkbox('Auto_Clarity_ON', 'Clarity', true)
submenu.slider('AutoClarityValue', 'Auto Clarity Value', 0, 100, 40)
submenu.checkbox('Auto_Heal_ON', 'Heal', true)
submenu.checkbox('Auto_HealAlly_ON', 'Use Heal To Protect Allies', true)
submenu.slider('AutoHealValue', 'Auto Heal Value', 0, 100, 15)
submenu.keytoggle('AutoSmite', 'Auto-Smite', Keys.N, true)
submenu.permashow("AutoSmite")

local submenu = menu.submenu('6. Potion Options', 300)
submenu.checkbox('Health_Potion_ON', 'Health Potions', true)
submenu.slider('Health_Potion_Value', 'Health Potion Value', 0, 100, 75)
submenu.checkbox('Biscuit_ON', 'Biscuit', true)
submenu.slider('Biscuit_Value', 'Biscuit Value', 0, 100, 60)
submenu.checkbox('Chrystalline_Flask_ON', 'Chrystalline Flask', true)
submenu.slider('Chrystalline_Flask_Value', 'Chrystalline Flask Value', 0, 100, 75)
submenu.checkbox('Elixir_of_Fortitude_ON', 'Elixir of Fortitude', true)
submenu.slider('Elixir_of_Fortitude_Value', 'Elixir of Fortitude Value', 0, 100, 30)
submenu.checkbox('Mana_Potion_ON', 'Mana Potions', true)
submenu.slider('Mana_Potion_Value', 'Mana Potion Value', 0, 100, 75)

local submenu = menu.submenu('7. Kill Steal Options', 300)
submenu.checkbutton('KillSteal_ON', 'Single Spell Kill Steal', true)
submenu.checkbox('KSQ', 'KS with Q', true)
submenu.checkbox('KSR', 'KS with R', false)
submenu.checkbox('KSDFG', 'KS with DFG', true)
submenu.checkbox('KSBFT', 'KS with BFT', true)
submenu.checkbox('KSHG', 'KS w/ Hextech', true)
submenu.checkbox('KSBC', 'KS w/ Cutlass', true)
submenu.checkbox('KST', 'KS w/ Tiamat', true)
submenu.checkbox('KSRH', 'KS w/ Hydra', true)
submenu.checkbox('KSBORK', 'KS w/ BORK', true)
submenu.checkbox('KSIGN', 'KS w/ Ignite', true)

local submenu = menu.submenu('8. Misc Options', 300)
submenu.checkbox('ShowPHP', 'Show Your % of HP', true)
submenu.label('lbM1', '--Auto Level--')
submenu.checkbox('ALevel_ON', 'Use Auto Leveler', true)
submenu.slider('lvlOrder', 'Skill Leveling Order', 1, 6 , 1, {'RQWE', 'RQEW', 'RWQE', 'RWEQ','REQW', 'REWQ'})

menu.label('lb01', ' ')
menu.label('lb02', 'WarwickIsKool Version '..tostring(Version) ..' by KoolKaracter')
------------------------------------------------------------  
------------------------End Of Menu-------------------------
------------------------------------------------------------


------------------------------------------------------------
------------------------Main Function-----------------------
------------------------------------------------------------
function Main()
	TargetSelector()
	RangeIndicators()
	UseDefensiveItems()
	AutoSummoners()
	AutoPots()
	onTick()
	if Cfg['7. Kill Steal Options'].KillSteal_ON then KillSteal() end
	if Cfg['8. Misc Options'].ShowPHP then ShowPercentHP() end
	if Cfg['8. Misc Options'].ALevel_ON then AutoLvl() end
	
	if yayo.Config.AutoCarry then 
		if target ~= nil then 
			if Cfg['4. Item Options'].ACItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].Q_AC_ON then UseQ(target) end
			if Cfg['1. Skill Options'].R_AC_ON then UseR(target) end
			if Cfg['1. Skill Options'].W_AC_ON then UseW(target) end
		end
	end
	
	if yayo.Config.Mixed then 
		if target ~= nil then 
			if Cfg['4. Item Options'].MItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].Q_M_ON then UseQ(target) end
			if Cfg['1. Skill Options'].R_M_ON then UseR(target) end
			if Cfg['1. Skill Options'].W_M_ON then UseW(target) end
		end
	end
	
	if yayo.Config.LaneClear then SpellClear() end
	
	if yayo.Config.LastHit then SpellLastHit() end
end
------------------------------------------------------------
--------------------End Of Main Function--------------------
------------------------------------------------------------


------------------------------------------------------------
---------------------------Skills---------------------------						
------------------------------------------------------------
function UseQ(targ)
	if GetDistance(targ, myHero) <= qRange and ValidTarget(targ) then CastSpellTarget('Q', targ) end
end

function UseW(targ)
	if GetDistance(targ, myHero) <= wRange then CastSpellTarget('W', targ) end
end

function UseR(targ)
	if GetDistance(targ, myHero) <= rRange and ValidTarget(targ) then CastSpellTarget('R', targ) end
end

function SpellClear()
	local minionTarget = GetLowestHealthEnemyMinion(900)
	
	if Cfg['4. Item Options'].LCItem_ON and minionTarget ~= nil and GetDistance(minionTarget, myHero) < 400 then 
		UseItemOnTarget(3074, myHero) -- Ravenous Hydra
		UseItemOnTarget(3077, myHero) -- Tiamat
	end
	--Q Farm
	if Cfg['1. Skill Options'].Q_LC_ON and minionTarget ~= nil then UseQ(minionTarget) end
	--W Farm
	if Cfg['1. Skill Options'].W_LC_ON and minionTarget ~= nil then UseW(minionTarget) end
end

function SpellLastHit()
	local minionTarget = GetLowestHealthEnemyMinion(800)
	if minionTarget ~= nil and GetDistance(minionTarget, myHero) > 190 then 
		--Q Farm
		if Cfg['1. Skill Options'].Q_LH_ON and minionTarget ~= nil and minionTarget.dead ~= 1 and getDmg('Q', minionTarget, myHero) >= minionTarget.health then 
			CustomCircle(50,1,2,minionTarget)
			UseQ(minionTarget) 
		end
	end  
end
------------------------------------------------------------
------------------------End Of Skills-----------------------
------------------------------------------------------------


------------------------------------------------------------
------------------------Target Selector---------------------
------------------------------------------------------------
function TargetSelector()
--TS Mode 1 (TS Primary)	
	local TSType = 'PHYS'
	if Cfg['2. Target Selector'].TS_Mode_Type == 1 then 
		TSType = 'PHYS'
	elseif Cfg['2. Target Selector'].TS_Mode_Type == 2 then 
		TSType = 'MAGIC'
	end
		
	if Cfg['2. Target Selector'].TS_Mode == 1 then
		if Cfg['2. Target Selector'].TS then
			for i = 1, objManager:GetMaxHeroes() do
				local enemy = objManager:GetHero(i)
				if enemy ~= nil and enemy.team ~= myHero.team and enemy.visible == 1 and GetDistance(enemy,mousePos) < 150 then
					targetPri = enemy
				end
			end
		end
		if target ~= nil and (GetDistance(target, myHero) > tsRange or target.visible ~= 1) then target = nil end
		if 	targetPri ~= nil and ValidTarget(targetPri, tsRange) then
			target = targetPri
			yayo.ForceTarget(target)
		elseif target == nil or (targetPri ~= nil and ValidTarget(targetPri, tsRange) ~= 1) then
			target = GetWeakEnemy(TSType, tsRange)
			target = target
			yayo.ForceTarget(target)
		end
		if targetPri ~= nil and (targetPri.dead == 1 or myHero.dead == 1) then targetPri = nil end
		if target ~= nil and (target.dead==1 or myHero.dead==1) then 
				target = nil
		end
		if Cfg['2. Target Selector'].TS_Circles then 
			if targetPri ~= nil and targetPri ~= target then
				CustomCircle(100,10,9,targetPri)  --yellow
			end
			if target ~= nil then
				CustomCircle(100,10,1,target) -- green
			end
		end 
-- TS Mode 2 (Get Weakest)
	elseif Cfg['2. Target Selector'].TS_Mode == 2 then
		target = GetWeakEnemy(TSType, tsRange)
		yayo.ForceTarget(target)
		if target ~= nil and (GetDistance(target, myHero) > tsRange or target.visible ~= 1) then target = nil end
		if Cfg['2. Target Selector'].TS_Circles and target ~= nil then 
			CustomCircle(100,10,1,target)
		end
	else
		--Do nothing
	end
end
------------------------------------------------------------
--------------------End Of Target Selector------------------
------------------------------------------------------------


------------------------------------------------------------
-----------------------Range Indicators---------------------
------------------------------------------------------------
function RangeIndicators()
	--local qColor, wColor, eColor, rColor = GetColors()
	if Cfg['3. Draw Range'].qRange then
		DrawCircleObject(myHero, qRange, Cfg['3. Draw Range'].qRangeColor)
	end
	if Cfg['3. Draw Range'].rRange then
		DrawCircleObject(myHero, rRange, Cfg['3. Draw Range'].rRangeColor)
	end
	if Cfg['3. Draw Range'].smiteRange then
		DrawCircleObject(myHero, 750, Cfg['3. Draw Range'].smiteRangeColor)
	end
end
------------------------------------------------------------
--------------------End Of Range Indicators-----------------
------------------------------------------------------------


------------------------------------------------------------
--------------------------Use Items-------------------------
------------------------------------------------------------
function UseOffensiveItems(target)
    AttackRange = myHero.range+(GetDistance(GetMinBBox(myHero)))

    if target ~= nil then
			if Cfg['4. Item Options'].BC and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3144, target) -- Bilgewater Cutlass
			end  
			if Cfg['4. Item Options'].BFT and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3188, target) -- Blackfire Torch
			end 			
			if Cfg['4. Item Options'].BORK and (GetDistance(myHero, target) < 500) then -- IR
				UseItemOnTarget(3153, target) -- Blade of the Ruined King
			end    
			if Cfg['4. Item Options'].DFG and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3128, target) -- Deathfire Grasp
			end   
			if Cfg['4. Item Options'].HG and (GetDistance(myHero, target) < 700) then -- IR
				UseItemOnTarget(3146, target) -- Hextech Gunblade
			end  
			if Cfg['4. Item Options'].RO and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3143, target) -- Randuin's Omen
			end
			if Cfg['4. Item Options'].RH and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3074, target) -- Ravenous Hydra
			end
			if Cfg['4. Item Options'].T and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3077, target) -- Tiamat
			end   
			if Cfg['4. Item Options'].TWS and (GetDistance(myHero, target) < AttackRange+10) then -- IR
				UseItemOnTarget(3023, target) -- Twin Shadows on Summoners Rift & Howling Abyss
				UseItemOnTarget(3290, target) -- Twin Shadows on Crystal Scar & Twisted Treeline
			end 
			if Cfg['4. Item Options'].YG and (GetDistance(myHero, target) < AttackRange+10) then -- AR
				UseItemOnTarget(3142, target) -- Youmuu's Ghostblade
			end  			
     end
end

function UseDefensiveItems()
	if IsBuffed(myHero, "FountainHeal") ~= true then

		if Cfg['4. Item Options'].ZH and myHero.health <= (myHero.maxHealth*(Cfg['4. Item Options'].ZHValue / 100)) then --If health is below the slider % value
	        UseItemOnTarget(3157,myHero) -- Zhonya's Hourglass
	        UseItemOnTarget(3090,myHero) -- Wooglet's Witchap
	    end
	end
end
------------------------------------------------------------
-----------------------End Of Use Items---------------------
------------------------------------------------------------


------------------------------------------------------------
------------------------Summoner Spells---------------------
------------------------------------------------------------
local Summoners =
                {
                    Ignite = {Key = nil, Name = 'summonerdot'},
                    Exhaust = {Key = nil, Name = 'summonerexhaust'},
                    Heal = {Key = nil, Name = 'summonerheal'},
                    Clarity = {Key = nil, Name = 'summonermana'},
                    Barrier = {Key = nil, Name = 'summonerbarrier'},
					Smite = {Key = nil, Name = 'summonersmite'}
                }

if myHero ~= nil then
    for _, Summoner in pairs(Summoners) do
        if myHero.SummonerD == Summoner.Name then
            Summoner.Key = "D"
        elseif myHero.SummonerF == Summoner.Name then
            Summoner.Key = "F"
        end
    end
end

function AutoSummoners()
        if Cfg['5. Summoner Spell Options'].Auto_Ignite_ON then SummonerIgnite() end
        if Cfg['5. Summoner Spell Options'].Auto_Barrier_ON then SummonerBarrier() end
        if Cfg['5. Summoner Spell Options'].Auto_Heal_ON then SummonerHeal() end
        if Cfg['5. Summoner Spell Options'].Auto_Exhaust_ON then SummonerExhaust() end
        if Cfg['5. Summoner Spell Options'].Auto_Clarity_ON then SummonerClarity() end
end
 
function SummonerIgnite()
--print( Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON)
--[[
This Ignite scripts calculates the targets health regen and
determines if you can kill the target taking in account their
natural health regen. This does not yet take into account health
regen from items... Some day perhaps!
]]--	

	if myHero.SummonerD == 'summonerdot'  or myHero.SummonerF == 'summonerdot' then --Dont waist time/energy if you dont have ignite 
		if myHero.SummonerD == 'summonerdot' then 
			ignKey = Keys.D
		else 
			ignKey = Keys.F
		end		

		for i = 1, objManager:GetMaxHeroes() do
            		local targetIgnite = objManager:GetHero(i)
			if targetIgnite ~= nil and targetIgnite.team ~= myHero.team and targetIgnite.visible == 1 and GetDistance(myHero, targetIgnite) < 700 then 
				local targetName = champdb[targetIgnite.name]
				local damage = (myHero.selflevel*20)+50
				local targetRegenPerSec = (targetName.healthRegenBase + (targetName.healthRegenLevel * targetIgnite.selflevel))
				local ignDamageAfterRegen = (damage-((targetRegenPerSec*5)/2))  
				local targCircle = 0

				if Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON then 
					if (ignKey == Keys.D and myHero.SpellTimeD > 1) or (ignKey == Keys.F and myHero.SpellTimeF > 1 )then
						if targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) < 600 then
							CustomCircle(80,8,2,targetIgnite)--RED
							targCircle = 2	--Ready to Cast     	                       		
						elseif targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) > 599 and GetDistance(myHero, targetIgnite) < 700 then
							CustomCircle(80,8,8,targetIgnite) --ORANGE
							targCircle = 1 --Ready to cast but target is just out of range (100 away)
						else
							targCircle = 0
						end
					
						if targCircle == 2 and IsKeyDown(ignKey) then CastSummonerIgn(targetIgnite) end --Cast ignite on killable target when ignite key is pressed
					end
				elseif  Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON == false then 
					if targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) < 600 then CastSummonerIgn(targetIgnite) end

				end 				                   		
			end
		end
	end
end
 
 
function SummonerBarrier()
                if myHero.SummonerD == 'summonerbarrier' or myHero.SummonerF == 'summonerbarrier' then
                        if myHero.health < myHero.maxHealth*(Cfg['5. Summoner Spell Options'].AutoBarrierValue / 100) then
                                CastSummonerBar()
                        end
                end
end
 
function SummonerHeal()
        if myHero.SummonerD == 'summonerheal' or myHero.SummonerF == 'summonerheal' then
                if Cfg['5. Summoner Spell Options'].Auto_HealAlly_ON then --will activate when alley within range is below X%
                        for h = 1, objManager:GetMaxHeroes() do
                                        local allyH = objManager:GetHero(h)
                                        if (allyH ~= nil and allyH.team == myHero.team and allyH.visible == 1 and GetDistance(myHero, allyH) < 700) or allyH == myHero then
                                                        if allyH.health <= (allyH.maxHealth*(Cfg['5. Summoner Spell Options'].AutoHealValue / 100)) then --If health is below the slider % value
															CastSummonerHea()                            
                                                        end
                                        end
                        end
                else --HealAlly not on, will just activate on self
                        if myHero.health < myHero.maxHealth*(Cfg['5. Summoner Spell Options'].AutoHealValue / 100) then
                                CastSummonerHea()
                        end
                end
        end
end
 
function SummonerExhaust()
        if target ~= nil then
                if myHero.SummonerD == 'summonerexhaust' or myHero.SummonerF == 'summonerexhaust' then
                        if myHero.health < myHero.maxHealth*(Cfg['5. Summoner Spell Options'].AutoExhaustValue / 100) and GetDistance(myHero, target) < 650 then
                                if myHero.health < target.health then
                                        CastSummonerExh(target)
                                end
                        end
                end
        end
end
 
function SummonerClarity()
                if myHero.SummonerD == 'summonermana' or myHero.SummonerF == 'summonermana' then
                        if myHero.mana < myHero.maxMana*(Cfg['5. Summoner Spell Options'].AutoClarityValue / 100) then
                                CastSummonerCla()
                        end
                end
end

-----------Kool's Edited version of Smite from Code BK-201----------------
local track = {}
local default_button_value = true

function onTick()
    for key,t in pairs(track) do
        local o = t.object
        local still_valid = false
        if is_boss(o) and o.dead == 0 and o.health > 0 then
            local current_key = get_key(o)
            if key == current_key then
                still_valid = true
            end
        end
        if still_valid then
			if Summoners.Smite.Key ~= nil then 
				if IsSpellReady(Summoners.Smite.Key) and Cfg['5. Summoner Spell Options'].AutoSmite then
					if o.health <= smitedamage[myHero.selflevel] and GetDistance(o, myHero) < 750 then
						CastSmite(o)
					end
				end
			end
        else
            track[key] = nil
        end
    end 
end

function is_boss(o)
    if o ~= nil and o.valid == 1 and o.name ~= nil and o.charName ~= nil then
        for i=1,#prefixes do
            local prefix = prefixes[i]
            if starts_with(o.name, prefix) then
                return true
            end
        end
    end
    return false
end

function starts_with(s, sub)
    return s:sub(1,string.len(sub))==sub
end

function get_key(o)
    return tostring(o.id)..','..o.name..','..o.charName
end

function start_tracking(o)
    local key = get_key(o)
    track[key] = {object=o, button_value=default_button_value, started=os.clock()}
end

function OnCreateObj(o)
    if is_boss(o) then
        start_tracking(o)
    end
end

for i=1,objManager:GetMaxObjects() do OnCreateObj(objManager:GetObject(i)) end
------------ End of Smite-------

function CastSummonerIgn(target)
    if ValidTarget(target) and Summoners.Ignite.Key ~= nil then
        CastSpellTarget(Summoners.Ignite.Key, target)
    end
end

function CastSummonerExh(target)
    if ValidTarget(target) and Summoners.Exhaust.Key ~= nil then
        CastSpellTarget(Summoners.Exhaust.Key, target)
    end
end

function CastSummonerHea(x, y, z)
    local unit
    if x == nil then
        unit = myHero
    elseif type(x) ~= 'number' then
        unit = x        
    end
    if unit then
        x, y, z = unit.x, unit.y, unit.z
    end
    if Summoners.Heal.Key ~= nil then
        CastSpellXYZ(Summoners.Heal.Key, x, y, z)
    end
end

function CastSummonerCla()
    if Summoners.Clarity.Key ~= nil then
        CastSpellTarget(Summoners.Clarity.Key, myHero)
    end
end

function CastSummonerBar()
    if Summoners.Barrier.Key ~= nil then
        CastSpellTarget(Summoners.Barrier.Key, myHero)
    end
end

function CastSmite(targ)
printtext('\nGets here\n')
	CastSpellTarget(Summoners.Smite.Key, targ)
end
------------------------------------------------------------
---------------------End Of Summoner Spells-----------------
------------------------------------------------------------


------------------------------------------------------------
--------------------------Use Potions-------------------------
------------------------------------------------------------
function AutoPots()
        if IsBuffed(myHero, "FountainHeal") ~= true and IsBuffed(myHero, 'TeleportHome.troy') ~= true then
                if Cfg['6. Potion Options'].Health_Potion_ON and myHero.health < myHero.maxHealth * (Cfg['6. Potion Options'].Health_Potion_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        usePotion()
                end
                if Cfg['6. Potion Options'].Biscuit_ON and myHero.health < myHero.maxHealth * (Cfg['6. Potion Options'].Biscuit_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion')~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        useBiscuit()
                end    
                if Cfg['6. Potion Options'].Chrystalline_Flask_ON and myHero.health < myHero.maxHealth * (Cfg['6. Potion Options'].Chrystalline_Flask_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        useFlask()
                end    
                if Cfg['6. Potion Options'].Elixir_of_Fortitude_ON and myHero.health < myHero.maxHealth * (Cfg['6. Potion Options'].Elixir_of_Fortitude_Value / 100) and IsBuffed(myHero, 'PotionofGiantStrength_itm') ~= true  then
                        useElixir()
                end
                if Cfg['6. Potion Options'].Mana_Potion_ON and myHero.mana < myHero.maxMana * (Cfg['6. Potion Options'].Mana_Potion_Value / 100) and IsBuffed(myHero, 'Global_Item_ManaPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_ManaPotion') ~= true then
                        useManaPot()
                end
        end
end
 
 
function usePotion()
        UseItemOnTarget(2003,myHero)
end
 
function useBiscuit()
        UseItemOnTarget(2010,myHero)
end
 
function useFlask()
        UseItemOnTarget(2041,myHero)
end
 
function useElixir()
        UseItemOnTarget(2037,myHero)
end
 
function useManaPot()
        UseItemOnTarget(2004,myHero)
end
------------------------------------------------------------
-----------------------End Of Use Potions-------------------
------------------------------------------------------------


------------------------------------------------------------
-----------------------Kill Steal Function------------------
------------------------------------------------------------
function KillSteal()

	for i = 1, objManager:GetMaxHeroes() do
          local ksTarg = objManager:GetHero(i)
		  
			if Cfg['7. Kill Steal Options'].KSQ and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < qRange and getDmg('Q', ksTarg, myHero) >= ksTarg.health then UseQ(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSR and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < rRange and getDmg('R', ksTarg, myHero) >= ksTarg.health then UseR(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSDFG and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('DFG', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3128, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBFT and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('BLACKFIRE', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3188, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBC and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('BWC', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3144, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSHG and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('HXG', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3146, ksTarg) end
			if Cfg['7. Kill Steal Options'].KST and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('TIAMAT', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3077, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSRH and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('HYDRA', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3074, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBORK and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 500 and getDmg('RUINEDKING', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3153, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSIGN and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 600 and getDmg('IGNITE', ksTarg, myHero) >= ksTarg.health  and (Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON ~= true) then CastSummonerIgn(ksTarg) end
	end
end
------------------------------------------------------------
-------------------End Of Kill Steal Function---------------
------------------------------------------------------------


------------------------------------------------------------
--------------------Miscellaneous Functions-----------------
------------------------------------------------------------
function ShowPercentHP()
 
        local myHP = ((myHero.health / myHero.maxHealth) * 100)
        myHP = string.format('%d%%', myHP)
        DrawTextObject(myHP,myHero,Color.White)
       
end

function Level_Spell(letter)  
     if letter == Q then send.key_press(0x69)
     elseif letter == W then send.key_press(0x6a)
     elseif letter == E then send.key_press(0x6b)
     elseif letter == R then send.key_press(0x6c) 
	 end
end

function GetSkillOrder()
	if Cfg['8. Misc Options'].lvlOrder == 1 then 
		skillOrder = {Q,W,Q,E,Q,R,Q,W,Q,W,R,W,W,E,E,R,E,E}
	end
	if Cfg['8. Misc Options'].lvlOrder == 2 then 
		skillOrder = {Q,E,Q,W,Q,R,Q,E,Q,E,R,E,E,W,W,R,W,W}
	end
	if Cfg['8. Misc Options'].lvlOrder == 3 then 
		skillOrder = {W,Q,W,E,W,R,W,Q,W,Q,R,Q,Q,E,E,R,E,E}
	end	
	if Cfg['8. Misc Options'].lvlOrder == 4 then 
		skillOrder = {W,E,W,Q,W,R,W,E,W,E,R,E,E,Q,Q,R,Q,Q}
	end		
	if Cfg['8. Misc Options'].lvlOrder == 5 then 
		skillOrder = {E,Q,E,W,E,R,E,Q,E,Q,R,Q,Q,W,W,R,W,W}
	end
	if Cfg['8. Misc Options'].lvlOrder == 6 then 
		skillOrder = {E,W,E,Q,E,R,E,W,E,W,R,W,W,Q,Q,R,Q,Q}
	end	
end

function AutoLvl()
    if IsChatOpen() == 0 then
		GetSkillOrder()
        spellLevelSum = GetSpellLevel(Q) + GetSpellLevel(W) + GetSpellLevel(E) + GetSpellLevel(R)

        if attempts <= 10 or (attempts > 10 and GetTickCount() > lastAttempt+1500) then
            if spellLevelSum < myHero.selflevel then
                if lastSpellLevelSum ~= spellLevelSum then attempts = 0 end
                letter = skillOrder[spellLevelSum+1]
                Level_Spell(letter, spellLevelSum)
                attempts = attempts+1
                lastAttempt = GetTickCount()
                lastSpellLevelSum = spellLevelSum
            else
                attempts = 0
            end
        end
    end
	send.tick()
end
------------------------------------------------------------
----------------End Of Miscellaneous Functions--------------
------------------------------------------------------------


SetTimerCallback('Main')
