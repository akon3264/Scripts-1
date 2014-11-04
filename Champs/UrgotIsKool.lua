-- ************************** LBC META *****************************
-- * lbc_name = UrgotIsKool.lua
-- * lbc_version = 3.0
-- * lbc_date = 11/03/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 3 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = KoolKaracter
-- * lbc_champion = Urgot // if this script is for a special champ
-- * lbc_tags = Urgot, ADC, AD, muramana, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4323
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/TwitchIsKool.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************



local ScriptName = 'UrgotIsKool'									
local Version = '3.0'												
local Author = 'Koolkaracter'												
--[[
  _    _ _____   _____  ____ _______   _____  _____   _  ______   ____  _      
 | |  | |  __ \ / ____|/ __ \__   __| |_   _|/ ____| | |/ / __ \ / __ \| |     
 | |  | | |__) | |  __| |  | | | |      | | | (___   | ' / |  | | |  | | |     
 | |  | |  _  /| | |_ | |  | | | |      | |  \___ \  |  <| |  | | |  | | |     
 | |__| | | \ \| |__| | |__| | | |     _| |_ ____) | | . \ |__| | |__| | |____ 
  \____/|_|  \_\\_____|\____/  |_|    |_____|_____/  |_|\_\____/ \____/|______|
                                                                                                                                                         
]]--

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
local qRange1, qRange2, eRange, rRange = 975,1175, 900, (400 + (150 * myHero.SpellLevelR))      						
local qSpeed, wSpeed, eSpeed, rSpeed = 1550, nil, 1400, nil     					
local qDelay, wDelay, eDelay, rDelay = .5, .5, .5, .50          						  
local qWidth, wWidth, eWidth, rWidth = 80, nil, 150, nil								
local qCollision, wCollision, eCollision, rCollision = true, false, false, false		
local tsRange = 1175 
																			
local skillOrder = {Q,E,Q,W,Q,R,Q,W,Q,W,R,W,W,E,E,R,E,E} -- Change this if you want to change the AutoLevel order(ensure you have 18 items or you might get an error. 
------------------------------------------------------------  
---------------------------Menu-----------------------------
------------------------------------------------------------
Cfg, menu = uiconfig.add_menu('Urgot Is Kool', 250)
local submenu = menu.submenu('1. Skill Options', 150)
submenu.label('lbS1', '--AutoCarry Mode--')
submenu.checkbox('Q_AC_ON', 'Use Q', true)
submenu.checkbox('W_AC_ON', 'Use W', false)
submenu.checkbox('E_AC_ON', 'Use E', true)
submenu.checkbox('R_AC_ON', 'Use R', false)
submenu.label('lbS2', '----Mixed Mode----')
submenu.checkbox('Q_M_ON', 'Use Q', true)
submenu.checkbox('W_M_ON', 'Use W', false)
submenu.checkbox('E_M_ON', 'Use E', true)
submenu.checkbox('R_M_ON', 'Use R', false)
submenu.label('lbS3', '----Lane Clear----')
submenu.checkbox('Q_LC_ON', 'Use Q', false)
submenu.checkbox('E_LC_ON', 'Use E', false)
submenu.label('lbS4', '----Last Hit----')
submenu.checkbox('Q_LH_ON', 'Use Q', true)
submenu.label('lbS5', '----Misc----')
submenu.keytoggle('LockOn', 'LockOn', Keys.F1, true)
submenu.keydown('CastQ', 'Cast Q', Keys.A)
submenu.keydown('CastE', 'Cast E', Keys.T)
submenu.permashow('LockOn')

local submenu = menu.submenu('2. Target Selector', 300)
submenu.slider('TS_Mode', 'Target Selector Mode', 1,2,1, {'TS Primary', 'Get Weakest'})
submenu.checkbox('TS_Circles', 'Use Circles To ID Target(s)', true)
submenu.keydown('TS', 'Target Selection Hotkey', 0x01)

local submenu = menu.submenu('3. Draw Range', 150)
submenu.checkbox('qRange1', 'Show Q Range 1', true)
submenu.slider('qRangeColor1', 'Color of Q1 Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('qRange2', 'Show Q Range 2', true)
submenu.slider('qRangeColor2', 'Color of Q2 Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('eRange', 'Show E Range', true)
submenu.slider('eRangeColor', 'Color of E Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})
submenu.checkbox('rRange', 'Show R Range', false)
submenu.slider('rRangeColor', 'Color of R Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})

local submenu = menu.submenu('4. Item Options', 225)
submenu.label('lbI1', '--Offensive Items--')
submenu.checkbox('BC', '---Bilgewater Cutlass---', true)
submenu.checkbox('BORK', '---Blade Of The Ruined King---', true)
submenu.checkbox('MANA', '---Muramana---', true)
submenu.checkbox('RO', '---Randuin\'s Omen---', true)
submenu.checkbox('YG', '---Youmuu\'s Goshtblade---', true)
submenu.checkbox('ACItem_ON', 'Use Items in A/C mode', true)
submenu.checkbox('MItem_ON', 'Use Items in Mixed mode', true)

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
submenu.checkbox('KSBORK', 'KS w/ BORK', true)
submenu.checkbox('KSBC', 'KS w/ Cutlass', true)
submenu.checkbox('KSIGN', 'KS with Ignite', true)

local submenu = menu.submenu('8. Misc Options', 300)
submenu.checkbox('ShowPHP', 'Show Your % of HP', true)
submenu.label('lbM1', '--Auto Level--')
submenu.checkbox('ALevel_ON', 'Use Auto Leveler', false)
submenu.label('lbM2', 'Order - Q,E,Q,W,Q,R,Q,W,Q,W,R,W,W,E,E,R,E,E')

menu.label('lb01', ' ')
menu.label('lb02', 'UrgotIsKool Version '..tostring(Version) ..' by KoolKaracter')
------------------------------------------------------------  
------------------------End Of Menu-------------------------
------------------------------------------------------------


------------------------------------------------------------
------------------------Main Function-----------------------
------------------------------------------------------------
function Main()
	TargetSelector()
	RangeIndicators()
	AutoSummoners()
	AutoPots()
	if Cfg['1. Skill Options'].LockOn then LockOn() end
	if Cfg['1. Skill Options'].CastQ then UseQ(target) end
	if Cfg['1. Skill Options'].CastE then UseE(target) end
	if Cfg['7. Kill Steal Options'].KillSteal_ON then KillSteal() end
	if Cfg['8. Misc Options'].ShowPHP then ShowPercentHP() end
	if Cfg['8. Misc Options'].ALevel_ON then AutoLvl() end
	
	if yayo.Config.AutoCarry then 
		if target ~= nil then 
			if Cfg['4. Item Options'].ACItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].E_AC_ON then UseE(target) end
			if Cfg['1. Skill Options'].W_AC_ON then UseW(target) end
			if Cfg['1. Skill Options'].Q_AC_ON then 
				if target ~= nil and IsBuffed(target, 'UrgotCorrosiveDebuff_buf', 0) then 
					UseQ(target, qRange2, true) 
				else
					if target ~= nil then 
						UseQ(target, qRange1, false)
					end
				end
			end
			if Cfg['1. Skill Options'].R_AC_ON then UseR(target) end
		end
	end
	
	if yayo.Config.Mixed then 
		if target ~= nil then 
			if Cfg['4. Item Options'].MItem_ON then UseOffensiveItems(target) end
			if Cfg['1. Skill Options'].E_M_ON then UseE(target) end
			if Cfg['1. Skill Options'].W_M_ON then UseW(target) end
			if Cfg['1. Skill Options'].Q_M_ON then 				
				if IsBuffed(target, 'UrgotCorrosiveDebuff_buf', 0) then 
					UseQ(target, qRange2, true) 
				else
					UseQ(target, qRange1, false)
				end
			end
			if Cfg['1. Skill Options'].R_M_ON then UseR(target) end
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
function UseQ(targ, qRange, buffed)
	if targ ~= nil and qRange == nil and buffed == nil and IsSpellReady('Q') and targ.dead ~= 1 and GetDistance(targ, myHero) < qRange1 then -- for lane clear mode
			CastPosition,  HitChance,  Position = YP:GetLineCastPosition(targ, qDelay, qWidth, qRange1, qSpeed, myHero, true)
			if CastPosition and HitChance >= 2 then 
				local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z   
				if IsBuffed(myHero, 'ItemMuramanaToggle.troy') then UseItemOnTarget(3042, myHero) end
				CastSpellXYZ('Q', x, y, z)
			end
	elseif targ ~= nil and IsSpellReady('Q') and ValidTarget(targ, qRange) and targ.dead ~= 1 then 	
		if buffed then 
			if Cfg['4. Item Options'].MANA and Muramana() == 1 then UseItemOnTarget(3042,myHero) end
			CastSpellXYZ('Q',targ.x,targ.y,targ.z)
		else
			CastPosition,  HitChance,  Position = YP:GetLineCastPosition(targ, qDelay, qWidth, qRange, qSpeed, myHero, true)
			if CastPosition and HitChance >= 2 then 
				local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z   
				if Cfg['4. Item Options'].MANA and Muramana() == 1 then UseItemOnTarget(3042,myHero) end
				CastSpellXYZ('Q', x, y, z)
			end
		end
	end
end

function UseW(targ)
	if targ ~= nil and IsSpellReady('W') then CastSpellTarget('W', myHero) end
end

function UseE(targ)
	if targ ~= nil and IsSpellReady('E') and ValidTarget(targ, eRange) and targ.dead ~= 1 then 
		CastPosition,  HitChance,  Position = YP:GetCircularCastPosition(targ, eDelay, eWidth, eRange, eSpeed, myHero, eCollision)
		if CastPosition and HitChance >= 2 then 
			local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
			CastSpellXYZ('E', x, y, z)
		end
	end
end

function UseR(targ)
	if targ ~= nil and IsSpellReady('R') and ValidTarget(targ, rRange) and targ.dead ~= 1 then 
		CastSpellTarget('R', targ)
	end
end

function SpellClear()
	local minionTarget = GetLowestHealthEnemyMinion(975)
	--Q Farm
	if Cfg['1. Skill Options'].Q_LC_ON and minionTarget ~= nil then UseQ(minionTarget) end
	--E Farm
	if Cfg['1. Skill Options'].E_LC_ON and minionTarget ~= nil then UseE(minionTarget) end
end

function SpellLastHit()
	local minionTarget = GetLowestHealthEnemyMinion(qRange1)
	if IsSpellReady('Q') and minionTarget ~= nil and minionTarget.dead ~= 1 and ValidTarget(minionTarget) and getDmg('Q', minionTarget, myHero) > minionTarget.health then 
		if getDmg('AD', minionTarget, myHero) > minionTarget.health and IsAttackReady() and GetDistance(minionTarget, myHero) < 425 then 
			-- let yayo AA
		else
			CastPosition,  HitChance,  Position = YP:GetLineCastPosition(minionTarget, qDelay, qWidth, qRange1, qSpeed, myHero, true)
			if CastPosition and HitChance >= 2 then 
				local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
				CastSpellXYZ('Q', x, y, z)
			end
		end
	end
end

function LockOn()
	if (not yayo.Config.AutoCarry) and (not yayo.Config.Mixed) then 
		if target ~= nil and IsSpellReady('Q') and ValidTarget(target, qRange2) and IsBuffed(target, 'UrgotCorrosiveDebuff_buf', 0) then 
			if Cfg['4. Item Options'].MANA and Muramana() == 1 then UseItemOnTarget(3042,myHero) end
			CastSpellXYZ('Q',target.x,target.y,target.z)
		else
			for i = 1, objManager:GetMaxHeroes() do
			local enemy = objManager:GetHero(i)
				if enemy ~= nil and enemy.team ~= myHero.team and IsSpellReady('Q') and IsBuffed(enemy, 'UrgotCorrosiveDebuff_buf', 0) and ValidTarget(enemy, qRange2) then 
				if Cfg['4. Item Options'].MANA and Muramana() == 1 then UseItemOnTarget(3042,myHero) end
					CastSpellXYZ('Q',enemy.x,enemy.y,enemy.z)
				end
			end
		end
	end
end

function Muramana()
	local mur = 0
	if Cfg['4. Item Options'].MANA then 
		if GetInventorySlot(3042)==1 and myHero.SpellTime1 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==2 and myHero.SpellTime2 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==3 and myHero.SpellTime3 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==4 and myHero.SpellTime4 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==5 and myHero.SpellTime5 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==6 and myHero.SpellTime6 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		elseif GetInventorySlot(3042)==7 and myHero.SpellTime7 >= 1 and not IsBuffed(myHero, 'ItemMuramanaToggle.troy') then mur = 1
		else mur = 0
		end
	end
	return mur -- Returns 1 if Muramana is not on and you have it, returns 0 if you dont' have muramana or its already on
end

function Init()
	yayo.RegisterOnAttackCallback(OnAttack)
end

function OnAttack(targ)
	if targ ~= nil then
		if Cfg['4. Item Options'].MANA and ((targ.type == 20 and Muramana() == 1) or (targ.type ~= 20 and IsBuffed(myHero, 'ItemMuramanaToggle.troy'))) then UseItemOnTarget(3042,myHero) end
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
			target = GetWeakEnemy('PHYS', tsRange)
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
		target = GetWeakEnemy('PHYS', tsRange)
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
	if Cfg['3. Draw Range'].qRange1 then
		DrawCircleObject(myHero, qRange1, Cfg['3. Draw Range'].qRangeColor1)
	end
	if Cfg['3. Draw Range'].qRange2 then
		DrawCircleObject(myHero, qRange2, Cfg['3. Draw Range'].qRangeColor2)
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
function UseOffensiveItems(targ)
    AttackRange = myHero.range+(GetDistance(GetMinBBox(myHero)))
    if targ ~= nil then
		if Cfg['4. Item Options'].BC and (GetDistance(myHero, targ) < 400) then -- IR
			UseItemOnTarget(3144, targ) -- Bilgewater Cutlass
		end        
		if Cfg['4. Item Options'].BORK and (GetDistance(myHero, targ) < 500) then -- IR
			UseItemOnTarget(3153, targ) -- Blade of the Ruined King
		end    
		if Cfg['4. Item Options'].RO and (GetDistance(myHero, targ) < 400) then -- IR
			UseItemOnTarget(3143, myHero) -- Randuin's Omen
		end
		if Cfg['4. Item Options'].YG and (GetDistance(myHero, targ) < AttackRange+10) then -- AR
			UseItemOnTarget(3142, myHero) -- Youmuu's Ghostblade
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
        if IsBuffed(myHero, "FountainHeal") ~= true and IsBuffed(myHero, 'TeleportHome.troy') ~= true  and IsBuffed(myHero, 'TeleportHomeImproved.troy') ~= true then
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
	  -------------------------------------------------------------------------
		if Cfg['7. Kill Steal Options'].KSQ and ksTarg ~= nil and ksTarg.team ~= myHero.team and ValidTarget(ksTarg) and getDmg('Q', ksTarg, myHero) >= ksTarg.health then 
			if IsBuffed(ksTarg, 'UrgotCorrosiveDebuff_buf', 0) and GetDistance(myHero, ksTarg) < qRange2 then 
				UseQ(ksTarg, qRange2, true) 
			else
				if GetDistance(myHero, ksTarg) < qRange1 then UseQ(ksTarg, qRange1, false) end
			end
		end
		if Cfg['7. Kill Steal Options'].KSBC and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('BWC', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3144, ksTarg) end
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

function AutoLvl()
    if IsChatOpen() == 0 then
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

Init()
SetTimerCallback('Main')
