-- ************************** LBC META *****************************
-- * lbc_name = RengarIsKool.lua
-- * lbc_version = 1.1
-- * lbc_date = 09/23/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 3 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = KoolKaracter
-- * lbc_champion = Rengar // if this script is for a special champ
-- * lbc_tags = Rengar, assassin, cat, AD, jungler, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4444
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/Champs/RengarIsKool.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************

local ScriptName = 'RengarIsKool'									
local Version = '1.1'												
local Author = 'Koolkaracter'												
--[[	
__________                                    .___          ____  __.            .__   
\______   \ ____   ____    _________ _______  |   | ______ |    |/ _|____   ____ |  |  
 |       _// __ \ /    \  / ___\__  \\_  __ \ |   |/  ___/ |      < /  _ \ /  _ \|  |  
 |    |   \  ___/|   |  \/ /_/  > __ \|  | \/ |   |\___ \  |    |  (  <_> |  <_> )  |__
 |____|_  /\___  >___|  /\___  (____  /__|    |___/____  > |____|__ \____/ \____/|____/
        \/     \/     \//_____/     \/                 \/          \/                  
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
local aaRange = 125 + 60--myHero.range+(GetDistance(GetMinBBox(myHero)))
local qRange, wRange, eRange, rRange = aaRange, 470, 950, nil      						
local qSpeed, wSpeed, eSpeed, rSpeed = nil, nil, 1500, nil     						
local qDelay, wDelay, eDelay, rDelay = .5, .5, .5, .5
local qWidth, wWidth, eWidth, rWidth = nil, nil, 70, nil							
local qCollision, wCollision, eCollision, rCollision = false, false, true, false		
local tsRange = 950 	
local smitedamage = {390, 410, 430, 450, 480, 510, 540, 570, 600, 640, 680, 720, 760, 800, 850, 900, 950, 1000}	
local prefixes = { 'Worm', 'Dragon', 'AncientGolem', 'LizardElder' }	
															

------------------------------------------------------------  
---------------------------Menu-----------------------------
------------------------------------------------------------
Cfg, menu = uiconfig.add_menu('Rengar Is Kool', 250)
local submenu = menu.submenu('1. Skill Options', 150)
submenu.label('lbS1', '--AutoCarry Mode--')
submenu.checkbox('Q_AC_ON', 'Use Q', true)
submenu.checkbox('W_AC_ON', 'Use W', true)
submenu.checkbox('E_AC_ON', 'Use E', true)
submenu.label('lbS2', '----Mixed Mode----')
submenu.checkbox('Q_M_ON', 'Use Q', true)
submenu.checkbox('W_M_ON', 'Use W', true)
submenu.checkbox('E_M_ON', 'Use E', false)
submenu.label('lbS3', '----Lane Clear----')
submenu.checkbox('Q_LC_ON', 'Use Q', false)
submenu.checkbox('W_LC_ON', 'Use W', false)
submenu.checkbox('E_LC_ON', 'Use E', false)
submenu.label('lbS4', '----5 Stack Opts----')
submenu.checkbox('W_Stacks_Heal_ON', 'Use W Heal below %Hp', false)
submenu.slider('W_Stacks_Heal_Value', 'Use W Heal at x% Health', 0, 100, 35)
submenu.checkbox('W_Stacks_Heal_Auto_ON', 'Heal w/o Hotkey Pressed', false)

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
submenu.checkbox('smiteRange', 'Show Smite Range', false)
submenu.slider('smiteRangeColor', 'Color of Smite Indicator?', 1, 6, 1, {"Green","Red", "Aqua", "Light Purple", "Blue", "Dark Purple"})

local submenu = menu.submenu('4. Item Options', 225)
submenu.label('lbI1', '--Offensive Items--')
submenu.checkbox('BC', '---Bilgewater Cutlass---', true)
submenu.checkbox('BORK', '---Blade Of The Ruined King---', true)
submenu.checkbox('RO', '---Randuin\'s Omen---', true)
submenu.checkbox('RH', '---Ravenous Hydra---', true)
submenu.checkbox('T', '---Tiamat---', true)
submenu.checkbox('YG', '---Youmuu\'s Goshtblade---', true)
submenu.checkbox('ACItem_ON', 'Use Items in A/C mode', true)
submenu.checkbox('MItem_ON', 'Use Items in Mixed mode', true)
submenu.checkbox('LCItem_ON', 'Use Hydra/Tiamat in L/C mode', true)

local submenu = menu.submenu('5. Summoner Spell Options', 300)
submenu.checkbox('Auto_Ignite_ON', 'Ignite', true)
submenu.checkbutton('Auto_Ignite_Self_ON', 'Ignite Self Cast (creates circle when killable)', false)
submenu.checkbox('Auto_Exhaust_ON', 'Exhaust', true)
submenu.slider('AutoExhaustValue', 'Auto Exhaust Value', 0, 100, 30)
submenu.checkbox('Auto_Barrier_ON', 'Barrier', true)
submenu.slider('AutoBarrierValue', 'Auto Barrier Value', 0, 100, 15)
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
submenu.checkbox('KSW', 'KS with W', true)
submenu.checkbox('KSE', 'KS with E', true)
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
menu.label('lb02', 'Rengar Is Kool Version '..tostring(Version) ..' by KoolKaracter')
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
	onTick()
	if Cfg['7. Kill Steal Options'].KillSteal_ON then KillSteal() end
	if Cfg['8. Misc Options'].ShowPHP then ShowPercentHP() end
	if Cfg['8. Misc Options'].ALevel_ON then AutoLvl() end
	if Cfg['1. Skill Options'].W_Stacks_Heal_ON and Cfg['1. Skill Options'].W_Stacks_Heal_Auto_ON and myHero.health <= (myHero.maxHealth*(Cfg['1. Skill Options'].W_Stacks_Heal_Value / 100)) and myHero.mana == 5 then CastSpellTarget('W', myHero) end --health is below the slider % value

	if yayo.Config.AutoCarry then 
		if target ~= nil then 
			if Cfg['4. Item Options'].ACItem_ON then UseOffensiveItems(target) end
			CheckStacks(target, 'AC')
			if Cfg['1. Skill Options'].Q_AC_ON then UseQ(target) end
			CheckStacks(target, 'AC')
			if Cfg['1. Skill Options'].W_AC_ON then UseW(target) end
			CheckStacks(target, 'AC')
			if Cfg['1. Skill Options'].E_AC_ON then UseE(target) end
			CheckStacks(target, 'AC')
		end
	end
	
	if yayo.Config.Mixed then 
		if target ~= nil then 
			if Cfg['4. Item Options'].MItem_ON then UseOffensiveItems(target) end
			CheckStacks(target, 'M')
			if Cfg['1. Skill Options'].Q_M_ON then UseQ(target) end
			CheckStacks(target, 'M')
			if Cfg['1. Skill Options'].W_M_ON then UseW(target) end
			CheckStacks(target, 'M')
			if Cfg['1. Skill Options'].E_M_ON then UseE(target) end
			CheckStacks(target, 'M')
		end
	end
	
	if yayo.Config.LaneClear then SpellClear() end
end
------------------------------------------------------------
--------------------End Of Main Function--------------------
------------------------------------------------------------


------------------------------------------------------------
---------------------------Skills---------------------------						
------------------------------------------------------------
function UseQ(targ)
	local QRANGE
	if IsBuffed(myHero, 'Rengar_Base_P_Buf_Ring.troy') then 
		QRANGE = 590
	else
		QRANGE = aaRange
	end
	if GetDistance(targ, myHero) <= QRANGE and ValidTarget(targ) then 
		CastSpellTarget('Q', targ) 
		AttackTarget(targ)
	end	
end

function UseW(targ)
	if GetDistance(targ, myHero) <= wRange and ValidTarget(targ) then CastSpellTarget('W', myHero) end	
end

function UseE(targ)
	CastPosition,  HitChance,  Position = YP:GetLineCastPosition(targ, eDelay, eWidth, eRange, eSpeed, myHero, eCollision)
	if CastPosition and HitChance >= 2 then 
		local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
		CastSpellXYZ('E', x, y, z)
	end
end
     
function CheckStacks(targ, mode)
	if myHero.mana == 5 then 
		if Cfg['1. Skill Options'].W_Stacks_Heal_ON and myHero.health <= (myHero.maxHealth*(Cfg['1. Skill Options'].W_Stacks_Heal_Value / 100)) and myHero.mana == 5 then 
			CastSpellTarget('W', myHero) 
		else
			if mode ~= nil and ((mode == 'AC' and Cfg['1. Skill Options'].Q_AC_ON) or (mode == 'M' and Cfg['1. Skill Options'].Q_M_ON) or (mode == 'LC' and Cfg['1. Skill Options'].Q_LC_ON)) then 
				UseQ(targ) 
			end
		end
	end
end
	 
function SpellClear()
	local minionTarget = GetLowestHealthEnemyMinion(900)
	
	if Cfg['4. Item Options'].LCItem_ON and minionTarget ~= nil and GetDistance(minionTarget, myHero) < 400 then 
		UseItemOnTarget(3074, myHero) -- Ravenous Hydra
		UseItemOnTarget(3077, myHero) -- Tiamat
	end
	CheckStacks(minionTarget, 'LC')
	--Q Farm
	if Cfg['1. Skill Options'].Q_LC_ON and minionTarget ~= nil then UseQ(minionTarget) end
	CheckStacks(minionTarget, 'LC')
	--W Farm
	if Cfg['1. Skill Options'].W_LC_ON and minionTarget ~= nil then UseW(minionTarget) end
	CheckStacks(minionTarget, 'LC')
	--E Farm
	if Cfg['1. Skill Options'].E_LC_ON and minionTarget ~= nil then UseE(minionTarget) end
	CheckStacks(minionTarget, 'LC')
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
	if Cfg['3. Draw Range'].qRange then
		DrawCircleObject(myHero, qRange, Cfg['3. Draw Range'].qRangeColor)
	end
	if Cfg['3. Draw Range'].wRange then
		DrawCircleObject(myHero, wRange, Cfg['3. Draw Range'].wRangeColor)
	end
	if Cfg['3. Draw Range'].eRange then
		DrawCircleObject(myHero, eRange, Cfg['3. Draw Range'].eRangeColor)
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
			if Cfg['4. Item Options'].BORK and (GetDistance(myHero, target) < 500) then -- IR
				UseItemOnTarget(3153, target) -- Blade of the Ruined King
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
			if Cfg['4. Item Options'].YG and (GetDistance(myHero, target) < AttackRange+10) then -- AR
				UseItemOnTarget(3142, target) -- Youmuu's Ghostblade
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
end
 
function SummonerIgnite()
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
 
function CastSummonerIgn(targ)
    if ValidTarget(targ) and Summoners.Ignite.Key ~= nil then
        CastSpellTarget(Summoners.Ignite.Key, targ)
    end
end

function CastSummonerExh(targ)
    if ValidTarget(targ) and Summoners.Exhaust.Key ~= nil then
        CastSpellTarget(Summoners.Exhaust.Key, targ)
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
        if IsBuffed(myHero, "FountainHeal") ~= true then
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
		if myHero.mana == 5 then 
			if Cfg['7. Kill Steal Options'].KSW and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < wRange and getDmg('W', ksTarg, myHero) >= ksTarg.health then UseW(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSQ and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < qRange and getDmg('Q', ksTarg, myHero) >= ksTarg.health then UseQ(ksTarg) end
 			if Cfg['7. Kill Steal Options'].KSE and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < eRange and getDmg('E', ksTarg, myHero) >= ksTarg.health then UseE(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBC and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('BWC', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3144, ksTarg) end
			if Cfg['7. Kill Steal Options'].KST and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('TIAMAT', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3077, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSRH and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('HYDRA', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3074, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBORK and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 500 and getDmg('RUINEDKING', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3153, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSIGN and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 600 and getDmg('IGNITE', ksTarg, myHero) >= ksTarg.health  and (Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON ~= true) then CastSummonerIgn(ksTarg) end
		else
 			if Cfg['7. Kill Steal Options'].KSQ and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < qRange and getDmg('Q', ksTarg, myHero) >= ksTarg.health then UseQ(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSW and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < wRange and getDmg('W', ksTarg, myHero) >= ksTarg.health then UseW(ksTarg) end
 			if Cfg['7. Kill Steal Options'].KSE and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < eRange and getDmg('E', ksTarg, myHero) >= ksTarg.health then UseE(ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBC and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('BWC', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3144, ksTarg) end
			if Cfg['7. Kill Steal Options'].KST and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('TIAMAT', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3077, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSRH and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 400 and getDmg('HYDRA', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3074, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSBORK and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 500 and getDmg('RUINEDKING', ksTarg, myHero) >= ksTarg.health then UseItemOnTarget(3153, ksTarg) end
			if Cfg['7. Kill Steal Options'].KSIGN and ksTarg ~= nil and ValidTarget(ksTarg) and ksTarg.team ~= myHero.team and GetDistance(myHero, ksTarg) < 600 and getDmg('IGNITE', ksTarg, myHero) >= ksTarg.health  and (Cfg['5. Summoner Spell Options'].Auto_Ignite_Self_ON ~= true) then CastSummonerIgn(ksTarg) end
		end
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
		skillOrder = {Q,W,E,Q,Q,R,Q,W,Q,W,R,W,W,E,E,R,E,E}
	end
	if Cfg['8. Misc Options'].lvlOrder == 2 then 
		skillOrder = {Q,E,W,Q,Q,R,Q,E,Q,E,R,E,E,W,W,R,W,W}
	end
	if Cfg['8. Misc Options'].lvlOrder == 3 then 
		skillOrder = {W,Q,E,W,W,R,W,Q,W,Q,R,Q,Q,E,E,R,E,E}
	end	
	if Cfg['8. Misc Options'].lvlOrder == 4 then 
		skillOrder = {W,E,Q,W,W,R,W,E,W,E,R,E,E,Q,Q,R,Q,Q}
	end		
	if Cfg['8. Misc Options'].lvlOrder == 5 then 
		skillOrder = {E,Q,W,E,E,R,E,Q,E,Q,R,Q,Q,W,W,R,W,W}
	end
	if Cfg['8. Misc Options'].lvlOrder == 6 then 
		skillOrder = {E,W,Q,E,E,R,E,W,E,W,R,W,W,Q,Q,R,Q,Q}
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
