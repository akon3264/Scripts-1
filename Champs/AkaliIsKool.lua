-- ************************** LBC META *****************************
-- * lbc_name = AkaliIsKool.lua
-- * lbc_version = 1.3
-- * lbc_date = 09/22/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 3 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = koolkaracter
-- * lbc_champion = Akali // if this script is for a special champ
-- * lbc_tags = Akali, ninja, assassin, AP, stealth, elo, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4442
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/AkaliIsKool.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************

local ScriptName = 'AkaliIsKool'									
local Version = '1.3'												
local Author = 'Koolkaracter'												
--[[	
    _   _        _ _   ___      _  __         _ 
   /_\ | |____ _| (_) |_ _|___ | |/ /___  ___| |
  / _ \| / / _` | | |  | |(_-< | ' </ _ \/ _ \ |
 /_/ \_\_\_\__,_|_|_| |___/__/ |_|\_\___/\___/_|
                                                
]]


require 'spell_damage'
require 'winapi'
require 'SKeys'
require 'Utils'
require 'vals_lib'
local yayo = require 'yayo'
local uiconfig = require 'uiconfig'
local send = require 'SendInputScheduled'
local target = nil
local attempts = 0
local lastAttempt = 0
local Q,W,E,R = 'Q','W','E','R'
local skillOrder = {}
local Enemies = {}
local EnemyIndex = 1
local qRange, wRange, eRange, rRange = 600, 700, 325, 800      			 --600			
local qSpeed, wSpeed, eSpeed, rSpeed = nil, nil, nil, nil     						
local qDelay, wDelay, eDelay, rDelay = .5, .5, .5, .50          						  
local qWidth, wWidth, eWidth, rWidth = nil, nil, nil, nil								
local qCollision, wCollision, eCollision, rCollision = false, false, false, false		
local tsRange = 800 
local qAirBorne = false
																				

------------------------------------------------------------  
---------------------------Menu-----------------------------
------------------------------------------------------------
Cfg, menu = uiconfig.add_menu('Akali Is Kool', 250)
local submenu = menu.submenu('1. Skill Options', 200)
submenu.label('lbS1', '--AutoCarry Mode--')
submenu.checkbox('Q_AC_ON', 'Use Q', true)
submenu.checkbox('W_AC_ON', 'Use W', true)
submenu.checkbox('E_AC_ON', 'Use E', true)
submenu.checkbox('R_AC_ON', 'Use R', true)
submenu.label('lbS2', '----Mixed Mode----')
submenu.checkbox('Q_M_ON', 'Use Q', true)
submenu.checkbox('W_M_ON', 'Use W', false)
submenu.checkbox('E_M_ON', 'Use E', false)
submenu.checkbox('R_M_ON', 'Use R', false)
submenu.label('lbS3', '----Lane Clear----')
submenu.checkbox('Q_LC_ON', 'Use Q', false)
submenu.checkbox('E_LC_ON', 'Use E', false)
submenu.checkbox('R_LC_ON', 'Use R', false)
submenu.label('lbS4', '----Last Hit----')
submenu.checkbox('Q_LH_ON', 'Use Q', true)
submenu.checkbox('E_LH_ON', 'Use E', false)
submenu.checkbox('R_LH_ON', 'Use R', false)
submenu.label('lbS4', '----W Options----')
submenu.checkbox('W_InPlace_ON', 'Cast W On You', false)
submenu.keydown('W_InPlace_Btn', 'W Inplace Button', Keys.W)

local submenu = menu.submenu('2. Target Selector', 300)
submenu.slider('TS_Mode', 'Target Selector Mode', 1,2,1, {'TS Primary', 'Get Weakest'})
submenu.checkbox('TS_Circles', 'Use Circles To ID Target(s)', true)
submenu.keydown('TS', 'Target Selection Hotkey', 0x01)

local submenu = menu.submenu('3. Draw Range', 150)
submenu.checkbox('qRange', 'Show Q Range ', true)
submenu.slider('qRangeColor', 'Color of Q Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('wRange', 'Show W Range', false)
submenu.slider('wRangeColor', 'Color of W Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('eRange', 'Show E Range', true)
submenu.slider('eRangeColor', 'Color of E Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('rRange', 'Show R Range', false)
submenu.slider('rRangeColor', 'Color of R Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})

local submenu = menu.submenu('4. Item Options', 225)
submenu.label('lbI1', '--Offensive Items--')
submenu.checkbox('BC', '---Bilgewater Cutlass---', true)
submenu.checkbox('BFT', '---Blackfire Torch---', true)
submenu.checkbox('DFG', '---Deathfire Grasp---', true)
submenu.checkbox('HG', '---Hextech Gunblade---', true)
submenu.checkbox('TWS', '----Twin  Shadows----', true)
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
submenu.checkbox('KSE', 'KS with E', true)
submenu.checkbox('KSR', 'KS with R', true)
submenu.checkbox('KSDFG', 'KS with DFG', true)
submenu.checkbox('KSBFT', 'KS with BFT', true)
submenu.checkbox('KSBWC', 'KS with BWC', true)
submenu.checkbox('KSHG', 'KS with HG', true)
submenu.checkbox('KSIGN', 'KS with Ignite', true)

local submenu = menu.submenu('8. Misc Options', 300)
submenu.checkbox('ShowPHP', 'Show Your % of HP', true)
submenu.label('lbM1', '--Auto Level--')
submenu.checkbox('ALevel_ON', 'Use Auto Leveler', true)
submenu.label('lbM2', 'Order: Q,W,E,Q,Q,R,Q,E,Q,E,R,E,E,W,W,R,W,W')

local submenu = menu.submenu('9. Burst Info Beta', 300)
submenu.checkbox('Burst_Info_ON', 'Display Burst Info', true)
submenu.slider('Executioner_Level_Value', 'Points In Executioner', 0,3,0)
submenu.slider('Havoc_Level_Value', 'Points In Havoc', 0,1,0)
submenu.slider('Burst_Info_Method', 'Use Which Display Method?', 1, 3, 1, {'Circle', 'Kill', 'XXX'})
submenu.slider('Burst_Info_After_Color', 'Color For Not Killable Display', 1, 8, 1, {"Yellow","Green", "Red", "Cyan", "Magenta", "Blue", 'DarkGreen', 'Orange'})
submenu.slider('Burst_Info_Kill_Color', 'Color For Killable Display', 1, 9, 3, {"Yellow","Green", "Red", "Cyan", "Magenta", "Blue", 'Purple', 'DarkGreen', 'Orange'})
submenu.checkbox('Real_Time_ON', 'Track in real time', true)

menu.label('lb01', ' ')
menu.label('lb02', 'AkaliIsKool Version '..tostring(Version) ..' by KoolKaracter')
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

	if Cfg['1. Skill Options'].W_InPlace_ON and Cfg['1. Skill Options'].W_InPlace_Btn then CastSpellTarget(W, myHero) end
	if Cfg['7. Kill Steal Options'].KillSteal_ON then KillSteal() end
	if Cfg['8. Misc Options'].ShowPHP then ShowPercentHP() end
	if Cfg['8. Misc Options'].ALevel_ON then AutoLvl() end
	if Cfg['9. Burst Info Beta'].Burst_Info_ON then BurstInfo() end
	
	if yayo.Config.AutoCarry then 
		if target ~= nil then 
			if Cfg['4. Item Options'].ACItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].Q_AC_ON then UseQ(target) end
			if Cfg['1. Skill Options'].R_AC_ON then UseR(target) end
			if Cfg['1. Skill Options'].E_AC_ON then UseE(target) end
			if Cfg['1. Skill Options'].W_AC_ON then UseW(target) end
		end
	end
	
	if yayo.Config.Mixed then 
		if target ~= nil then 
			if Cfg['4. Item Options'].MItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].Q_M_ON then UseQ(target) end
			if Cfg['1. Skill Options'].R_M_ON then UseR(target) end
			if Cfg['1. Skill Options'].E_M_ON then UseE(target) end
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
	if GetDistance(targ, myHero) <= qRange and ValidTarget(targ) and myHero.SpellTimeQ >= 1 and myHero.SpellLevelQ > 0 then 
		CastSpellTarget('Q', targ) 
		qAirBorne = true
	end
end

function UseW(targ)
	if GetDistance(targ, MyHero) <= wRange and ValidTarget(targ) and myHero.SpellTimeW >= 1 and myHero.SpellLevelW > 0 then CastSpellTarget('W', targ) end
end

function UseE(targ)
	if GetDistance(targ, myHero) < eRange and QCheck(targ) and myHero.SpellTimeE >= 1 and myHero.SpellLevelE > 0 and ValidTarget(targ) then 
		CastSpellTarget('E', myHero)
	elseif GetDistance(targ, myHero) < eRange and QCheck(targ) ~= true and qAirBorne ~= true and myHero.SpellTimeQ >= 1 and myHero.SpellLevelE > 0 and ValidTarget(targ) then
		CastSpellTarget('E', myHero)
	elseif yayo.Config.LaneClear and GetDistance(targ, myHero) < eRange and myHero.SpellTimeE >= 1 and myHero.SpellLevelE > 0 then 
		CastSpellTarget('E', myHero)
	end
end

function UseR(targ)
	if GetDistance(targ, myHero) <= rRange and (GetDistance(myHero,target) > eRange or (myHero.SpellTimeQ < 1 and myHero.SpellTimeE < 1)) and myHero.SpellTimeR >= 1 and ValidTarget(targ) and myHero.SpellLevelR > 0 then 
		CastSpellTarget('R', targ) 
	end
end

function SpellClear()
	local minionTarget = GetLowestHealthEnemyMinion(800)
	--Q Farm
	if Cfg['1. Skill Options'].Q_LC_ON and minionTarget ~= nil then UseQ(minionTarget) end
	--E Farm
	if Cfg['1. Skill Options'].E_LC_ON and minionTarget ~= nil then UseE(minionTarget) end
	--R Farm
	if Cfg['1. Skill Options'].R_LC_ON and minionTarget ~= nil then UseR(minionTarget) end
end

function SpellLastHit()
	local minionTarget = GetLowestHealthEnemyMinion(800)
	if minionTarget ~= nil and GetDistance(minionTarget, myHero) > 190 then 
		--Q Farm
		if Cfg['1. Skill Options'].Q_LH_ON and minionTarget ~= nil and minionTarget.dead ~= 1 and getDmg('Q', minionTarget, myHero) >= minionTarget.health then 
			CustomCircle(50,1,2,minionTarget)
			UseQ(minionTarget) 
		end
		--E Farm
		if Cfg['1. Skill Options'].E_LH_ON and minionTarget ~= nil and minionTarget.dead ~= 1 and getDmg('W', minionTarget, myHero) >= minionTarget.health then 
			CustomCircle(50,1,2,minionTarget)
			UseE(minionTarget) 
		end
		--R Farm
		if Cfg['1. Skill Options'].R_LH_ON and minionTarget ~= nil and minionTarget.dead ~= 1 and getDmg('R', minionTarget, myHero) >= minionTarget.health then 
			CustomCircle(50,1,2,minionTarget)
			UseR(minionTarget) 
		end
	end  
end

function QCheck(targ)
	if targ ~= nil and IsBuffed(targ, 'akali_markOftheAssasin_marker_tar.troy') and ValidTarget(targ, 800) then 
		qAirBorne = false
		return true
	else 
		return false
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
			target = GetWeakEnemy('MAGIC', tsRange)
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
		target = GetWeakEnemy('MAGIC', tsRange)
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
	if Cfg['3. Draw Range'].wRange then
		DrawCircleObject(myHero, wRange, Cfg['3. Draw Range'].wRangeColor)
	end
	if Cfg['3. Draw Range'].eRange then
		DrawCircleObject(myHero, eRange, Cfg['3. Draw Range'].eRangeColor)
	end
	if Cfg['3. Draw Range'].rRange then
		DrawCircleObject(myHero, rRange, Cfg['3. Draw Range'].rRangeColor)
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
			if Cfg['4. Item Options'].BC and (GetDistance(myHero, target) < 400) then -- In Item Range (IR)
				UseItemOnTarget(3144, target) -- Bilgewater Cutlass
			end        
  			if Cfg['4. Item Options'].DFG and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3128, target) -- Deathfire Grasp
			end        
			if Cfg['4. Item Options'].BFT and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3188, target) -- Blackfire Torch
			end    
			if Cfg['4. Item Options'].HG and (GetDistance(myHero, target) < 700) then -- IR
				UseItemOnTarget(3146, target) -- Hextech Gunblade
			end  
			if Cfg['4. Item Options'].TWS and (GetDistance(myHero, target) < AttackRange+10) then -- IR
				UseItemOnTarget(3023, target) -- Twin Shadows on Summoners Rift & Howling Abyss
				UseItemOnTarget(3290, target) -- Twin Shadows on Crystal Scar & Twisted Treeline
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
			if Cfg['7. Kill Steal Options'].KSE and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < eRange and getDmg('E', ksTarg, myHero) >= ksTarg.health then UseE(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSR and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < rRange and getDmg('R', ksTarg, myHero) >= ksTarg.health then UseR(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSDFG and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('DFG', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3128, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBFT and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('BLACKFIRE', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3188, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSHG and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('HXG', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3146, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBWC and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and GetDistance(myHero, ksTarg) < 750 and getDmg('BWC', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3144, ksTarg) end
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
		skillOrder = {Q,W,E,Q,Q,R,Q,E,Q,E,R,E,E,W,W,R,W,W}
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


------------------------------------------------------------
----------------------Burst Information---------------------
------------------------------------------------------------
function FillEnemiesTable()
	local tableFull = false
	if Enemies[objManager:GetMaxHeroes()/2] == nil then 
		for i = 1, objManager:GetMaxHeroes(), 1 do
			Champ = objManager:GetHero(i)
			if Champ ~= nil and Champ.team ~= myHero.team then
				if Enemies[Champ.name] == nil then
					Enemies[Champ.name] = { Unit = Champ, Number = EnemyIndex }
					EnemyIndex = EnemyIndex + 1
					tableFull = false
				end
			end
		end
	else
		tableFull = true
	end
	
	return tableFull
end



function BurstInfo()
	if not FillEnemiesTable() then FillEnemiesTable() end
	for i, Enemy in pairs(Enemies) do
		if Enemy ~= nil then
			enemyChamp = Enemy.Unit
		
			local PositionX = (13.3/16) * GetScreenX()

			local Damage
			Damage = GetDamageInfo(enemyChamp)
			futurePercent = (enemyChamp.health - Damage)/ enemyChamp.maxHealth * 100
			futurePercent = string.format('%d%%', futurePercent)
--			currentPercent = (enemyChamp.health / enemyChamp.maxHealth) * 100
--			currentPercent = string.format('%d%%', currentPercent)
			local notKillableColor = 0xFFFFFF00
			local killableColor = Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color
			
			if Cfg['9. Burst Info Beta'].Burst_Info_After_Color -1 == 0 then notKillableColor = Color.Yellow
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 1 then notKillableColor = Color.Green
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 2 then notKillableColor = Color.Red
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 3 then notKillableColor = Color.Cyan
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 4 then notKillableColor = Color.Purple
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 5 then notKillableColor = Color.Blue
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 6 then notKillableColor = Color.Olive
			elseif Cfg['9. Burst Info Beta'].Burst_Info_After_Color-1  == 7 then notKillableColor = Color.Orange
			else
				notKillableColor = Color.Yellow --Should never happen
			end
			
			if Cfg['9. Burst Info Beta'].Burst_Info_Method == 1 then 
				killableColor = Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color - 1
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 1 then killableColor = Color.Yellow
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 2 then killableColor = Color.Green
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 3 then killableColor = Color.Red
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 4 then killableColor = Color.Cyan
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 5 then killableColor = Color.Purple
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 6 then killableColor = Color.Blue
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 7 then killableColor = Color.Purple
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 8 then killableColor = Color.Olive
			elseif Cfg['9. Burst Info Beta'].Burst_Info_Kill_Color == 9 then killableColor = Color.Orange
			else
				KillableColor = Color.Yellow --Should never happen
			end	
							
			if enemyChamp.visible == 1 and enemyChamp.dead ~= 1 then
				if Damage < enemyChamp.health then
					DrawTextObject(futurePercent, enemyChamp, notKillableColor)
				elseif Damage >= enemyChamp.health then	
					if Cfg['9. Burst Info Beta'].Burst_Info_Method == 1 then 
						CustomCircle(0,50,killableColor, "", enemyChamp.x, enemyChamp.y, enemyChamp.z+25)
					elseif Cfg['9. Burst Info Beta'].Burst_Info_Method == 2 then 
						DrawTextObject('KILL',enemyChamp, killableColor)
					elseif Cfg['9. Burst Info Beta'].Burst_Info_Method == 3 then 
						DrawTextObject('XXXXX',enemyChamp, killableColor)	
					end
				end
			end
		end
	end
end

--[[
To Do list:
- Add check for items, if so then if they are on CD, then add item damage, (Hextech, Bilgewater, Deathfire
- Add Ignite
- Add items such as Lichbane/Triforce/Iceborn
- Add AA damage
- Add Champ Specific damage, like Akalis 2nd proc of Q, and Leblancs 2nd proc of q... 
]]--

function GetDamageInfo(targ)

	local qDMG = GetQDmg(targ)	
	local wDMG = GetWDmg(targ)
	local eDMG = GetEDmg(targ)	
	local rDMG = GetRDmg(targ)
	local combo_Damage = 0
	if Cfg['9. Burst Info Beta'].Real_Time_ON then   --This will display the damage you are capable of doing right now with the current spells you have on CD
	
		if myHero.SpellLevelQ > 0 and myHero.SpellTimeQ > 1 and (qDMG ~= nil or qDMG ~= 0) then 
			combo_Damage = combo_Damage + qDMG
		end
		if myHero.SpellLevelW > 0 and myHero.SpellTimeW > 1 and (wDMG ~= nil or wDMG ~= 0) then 
			combo_Damage = combo_Damage + wDMG
		end
		if myHero.SpellLevelE > 0 and myHero.SpellTimeE > 1 and (eDMG ~= nil or eDMG ~= 0) then 
			combo_Damage = combo_Damage + eDMG
		end
		if myHero.SpellLevelR > 0 and myHero.SpellTimeR > 1 and (rDMG ~= nil or rDMG ~= 0) then 
			combo_Damage = combo_Damage + rDMG
		end

	else
	
		if (qDMG ~= nil or qDMG ~= 0) and myHero.SpellLevelQ > 0 then 
			combo_Damage = combo_Damage + qDMG
		end
		if (wDMG ~= nil or wDMG ~= 0) and myHero.SpellLevelW > 0 then 
			combo_Damage = combo_Damage + wDMG
		end
		if (eDMG ~= nil or eDMG ~= 0) and myHero.SpellLevelE > 0 then 
			combo_Damage = combo_Damage + eDMG
		end
		if (rDMG ~= nil or rDMG ~= 0) and myHero.SpellLevelR > 0 then 
			combo_Damage = combo_Damage + rDMG
		end

	end	

	return combo_Damage
end

function GetExecAmt()

	local ExVal = 0 --Excutioner Value
 	
	if Cfg['9. Burst Info Beta'].Executioner_Level_Value == 0 then 
		ExVal = 0
	elseif Cfg['9. Burst Info Beta'].Executioner_Level_Value == 1 then 
		ExVal = .2
	elseif Cfg['9. Burst Info Beta'].Executioner_Level_Value == 2 then 
		ExVal = .35
	elseif Cfg['9. Burst Info Beta'].Executioner_Level_Value == 3 then 
		ExVal = .5
	else
		ExVal = 0 --Should never be anything else... but Just incase.
	end
	
	return ExVal
end

function GetHavocAmt()

	local HavVal = 0 --Havoc Value
 	
	if Cfg['9. Burst Info Beta'].Havoc_Level_Value == 0 then 
		HavVal = 0
	elseif Cfg['9. Burst Info Beta'].Havoc_Level_Value == 1 then 
		HavVal = .3
	else
		HavVal = 0
	end
	
	return HavVal
end

function GetQDmg(targ)
	if targ ~= nil then 
		local qDmg = 0
		local HavocAmt = GetHavocAmt() 
		local ExecAmt = GetExecAmt()

		if getDmg('Q', targ, myHero) ~= nil and getDmg('Q', targ, myHero) > 0 then 
			if ExecAmt > 0 and (targ.health < (targ.maxHealth * ExecAmt)) then 
				qDmg = getDmg('Q', targ, myHero) + (getDmg('Q', targ, myHero) * HavocAmt) + (getDmg('Q', targ, myHero) * .05)
			else
				qmg = getDmg('Q', targ, myHero) + (getDmg('Q',targ,myHero) * HavocAmt)	
			end
		end
		
		return qDmg
	end
end

function GetWDmg(targ)
	if targ ~= nil then 
		local wDmg = 0
		local HavocAmt = GetHavocAmt() 
		local ExecAmt = GetExecAmt()

		if getDmg('W', targ, myHero) ~= nil and getDmg('W', targ, myHero) > 0 then 
			if ExecAmt > 0 and (targ.health < (targ.maxHealth * ExecAmt)) then 
				wDmg = getDmg('W', targ, myHero) + (getDmg('W',targ,myHero) * HavocAmt) + (getDmg('W',targ,myHero) * .05)
			else
				wDmg = getDmg('W', targ, myHero) + (getDmg('W',targ,myHero) * HavocAmt)	
			end
		end
		
		return wDmg
	end
end

function GetEDmg(targ)
	if targ ~= nil then 
		local eDmg = 0
		local HavocAmt = GetHavocAmt() 
		local ExecAmt = GetExecAmt()

		if getDmg('E', targ, myHero) ~= nil and getDmg('E', targ, myHero) > 0 then 
			if ExecAmt > 0 and (targ.health < (targ.maxHealth * ExecAmt)) then 
				eDmg = getDmg('E', targ, myHero) + (getDmg('E',targ,myHero) * HavocAmt) + (getDmg('E',targ,myHero) * .05)
			else
				eDmg = getDmg('E', targ, myHero) + (getDmg('E',targ,myHero) * HavocAmt)
			end
		end
		
		return eDmg
	end
end

function GetRDmg(targ)
	if targ ~= nil then 
		local rDmg = 0
		local HavocAmt = GetHavocAmt() 
		local ExecAmt = GetExecAmt()

		if getDmg('R', targ, myHero) ~= nil and getDmg('R', targ, myHero) > 0 then 
			if ExecAmt > 0 and (targ.health < (targ.maxHealth * ExecAmt)) then 
				rDmg = getDmg('R', targ, myHero) + (getDmg('R',targ,myHero) * HavocAmt) + (getDmg('R',targ,myHero) * .05)
			else
				rDmg = getDmg('R', targ, myHero) + (getDmg('R',targ,myHero) * HavocAmt)	
			end
		end
		
		return rDmg
	end
end

------------------------------------------------------------
------------------End Of Burst Information------------------
------------------------------------------------------------







SetTimerCallback('Main')
