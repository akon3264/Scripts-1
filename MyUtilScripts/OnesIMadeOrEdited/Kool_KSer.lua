-- ************************** LBC META *****************************
-- * lbc_name = Kool_KSer.lua
-- * lbc_version = 1.0
-- * lbc_date = 11/1/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 5 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = koolkaracter
-- * lbc_champion =  // if this script is for a special champ
-- * lbc_tags = Killsteal, kill steal, kill, steal, ks, kser, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4577
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/MyUtilScripts/OnesIMadeOrEdited/Kool_KSer.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************

require 'spell_damage'
require 'yprediction'
require 'vals_lib'

local YP = YPrediction()
local uiconfig = require 'uiconfig'
local ignKey = nil


if myHero.SummonerD == 'summonerdot'  or myHero.SummonerF == 'summonerdot' then
	if myHero.SummonerD == 'summonerdot' then 
		ignKey = 'D'
	else 
		ignKey = 'F'
	end	
end

Cfg, menu = uiconfig.add_menu('Kool KSer', 300)
 
local submenu = menu.submenu('1. Q Options', 300)
submenu.checkbutton('KS_Q_ON', 'KS with Q', false)
submenu.checkbox('Q_Range_Checker', 'Check Q Range -- Green', false)
submenu.slider('Q_Type', 'Type of Spell', 1, 5, 1, {'Targeted', 'SelfCast', 'Line', 'Circle', 'Cone'})
submenu.slider('Q_Range', 'Q Range', 0, 1500, 600)
submenu.slider('Q_Width', 'Q Width or Radius', 0, 1000, 200)
submenu.slider('Q_Angle', 'Q Angle (Cone Only)', 0, 360, 30)
submenu.slider('Q_Speed', 'Q Speed', 0, 2500, 1500)
submenu.slider('Q_Delay', 'Q Delay', 0, 5, .5)
submenu.slider('Q_Collision', 'Q Collision', 1, 2, 1, {'True', 'False'})
submenu.slider('Q_Stage', 'Q Stage', 1, 3, 1)

local submenu = menu.submenu('2. W Options', 300)
submenu.checkbutton('KS_W_ON', 'KS with W', false)
submenu.checkbox('W_Range_Checker', 'Check W Range -- Blue', false)
submenu.slider('W_Type', 'Type of Spell', 1, 5, 1, {'Targeted', 'SelfCast', 'Line', 'Circle', 'Cone'})
submenu.slider('W_Range', 'W Range', 0, 1500, 600)
submenu.slider('W_Width', 'W Width or Radius', 0, 1000, 200)
submenu.slider('W_Angle', 'W Angle (Cone Only)', 0, 360, 30)
submenu.slider('W_Speed', 'W Speed', 0, 2500, 1500)
submenu.slider('W_Delay', 'W Delay', 0, 5, .5)
submenu.slider('W_Collision', 'W Collision', 1, 2, 1, {'True', 'False'})
submenu.slider('W_Stage', 'W Stage', 1, 3, 1)

local submenu = menu.submenu('3. E Options', 300)
submenu.checkbutton('KS_E_ON', 'KS with E', false)
submenu.checkbox('E_Range_Checker', 'Check E Range -- Purple', false)
submenu.slider('E_Type', 'Type of Spell', 1, 5, 1, {'Targeted', 'SelfCast', 'Line', 'Circle', 'Cone'})
submenu.slider('E_Range', 'E Range', 0, 1500, 600)
submenu.slider('E_Width', 'E Width or Radius', 0, 1000, 200)
submenu.slider('E_Angle', 'E Angle (Cone Only)', 0, 360, 30)
submenu.slider('E_Speed', 'E Speed', 0, 2500, 1500)
submenu.slider('E_Delay', 'E Delay', 0, 5, .5)
submenu.slider('E_Collision', 'E Collision', 1, 2, 1, {'True', 'False'})
submenu.slider('E_Stage', 'E Stage', 1, 3, 1)

local submenu = menu.submenu('4. R Options', 300)
submenu.checkbutton('KS_R_ON', 'KS with R', false)
submenu.checkbox('R_Range_Checker', 'Check R Range -- Red', false)
submenu.slider('R_Type', 'Type of Spell', 1, 5, 1, {'Targeted', 'SelfCast', 'Line', 'Circle', 'Cone'})
submenu.slider('R_Range', 'R Range', 0, 1500, 600)
submenu.slider('R_Width', 'R Width or Radius', 0, 1000, 200)
submenu.slider('R_Angle', 'R Angle (Cone Only)', 0, 360, 30)
submenu.slider('R_Speed', 'R Speed', 0, 2500, 1500)
submenu.slider('R_Delay', 'R Delay', 0, 5, .5)
submenu.slider('R_Collision', 'R Collision', 1, 2, 1, {'True', 'False'})
submenu.slider('R_Stage', 'R Stage', 1, 3, 1)

local submenu = menu.submenu('5. Ignite Options', 300)
if ignKey ~= nil then 
	submenu.checkbutton('KS_Ign_ON', 'KS with Ignite', false)
else
	submenu.label('lb01', 'You do not have Ignite')
end

local submenu = menu.submenu('6. Item Options', 300)
submenu.checkbutton('KS_Items_ON', 'KS with Items', false)
submenu.checkbox('KSBFT', 'KS with BFT', true) -- Black fire Torch
submenu.checkbox('KSBORK', 'KS with BORK', true) -- Blade of the Ruined King
submenu.checkbox('KSBWC', 'KS with BWC', true) -- Bilgewater Cutless
submenu.checkbox('KSDFG', 'KS with DFG', true) -- Deathfire Grasp
submenu.checkbox('KSFQC', 'KS with FQC', true) -- Frost Queen's Claim	
submenu.checkbox('KSHTGB', 'KS with HTGB', true) -- Hextech Gunblade
submenu.checkbox('KSRH', 'KS with RH', true) -- Ravenous Hydra
submenu.checkbox('KST', 'KS with T', true) -- Tiamat                   

function Main()
	if Cfg['1. Q Options'].Q_Range_Checker or Cfg['2. W Options'].W_Range_Checker or Cfg['3. E Options'].E_Range_Checker or Cfg['4. R Options'].R_Range_Checker then RangeChecker() end
	if Cfg['1. Q Options'].KS_Q_ON then KSSpells('Q', Cfg['1. Q Options'].Q_Range, Cfg['1. Q Options'].Q_Type, Cfg['1. Q Options'].Q_Width, Cfg['1. Q Options'].Q_Angle, Cfg['1. Q Options'].Q_Speed, Cfg['1. Q Options'].Q_Delay, Cfg['1. Q Options'].Q_Collision, Cfg['1. Q Options'].Q_Stage) end
	if Cfg['2. W Options'].KS_W_ON then KSSpells('W', Cfg['2. W Options'].W_Range, Cfg['2. W Options'].W_Type, Cfg['2. W Options'].W_Width, Cfg['2. W Options'].W_Angle, Cfg['2. W Options'].W_Speed, Cfg['2. W Options'].W_Delay, Cfg['2. W Options'].W_Collision, Cfg['2. W Options'].W_Stage) end
	if Cfg['3. E Options'].KS_E_ON then KSSpells('E', Cfg['3. E Options'].E_Range, Cfg['3. E Options'].E_Type, Cfg['3. E Options'].E_Width, Cfg['3. E Options'].E_Angle, Cfg['3. E Options'].E_Speed, Cfg['3. E Options'].E_Delay, Cfg['3. E Options'].E_Collision, Cfg['3. E Options'].E_Stage) end
	if Cfg['4. R Options'].KS_R_ON then KSSpells('R', Cfg['4. R Options'].R_Range, Cfg['4. R Options'].R_Type, Cfg['4. R Options'].R_Width, Cfg['4. R Options'].R_Angle, Cfg['4. R Options'].R_Speed, Cfg['4. R Options'].R_Delay, Cfg['4. R Options'].R_Collision, Cfg['4. R Options'].R_Stage) end
	if ignKey ~= nil and Cfg['5. Ignite Options'].KS_Ign_ON then KSIgn() end
	if Cfg['6. Item Options'].KS_Items_ON then KSItems() end
end

function KSIgn()
	for i = 1, objManager:GetMaxHeroes() do
		local champ = objManager:GetHero(i)
		if champ ~= nil and champ.team ~= myHero.team and ValidTarget(champ, 600) and ignKey ~= nil and IsSpellReady(ignKey) == 1 then 
			if getDmg('IGNITE', champ, myHero) >= champ.health then CastSpellTarget(ignKey, target) end
		end
	end
end

function KSItems()
	for i = 1, objManager:GetMaxHeroes() do
		local champ = objManager:GetHero(i)
		if champ ~= nil and champ.team ~= myHero.team and ValidTarget(champ) then 
			if Cfg['6. Item Options'].KSBFT and GetDistance(champ, myHero) < 750 and getDmg('BLACKFIRE', champ, myHero) > champ.health then UseItemOnTarget(3188, champ) end	
			if Cfg['6. Item Options'].KSBORK and GetDistance(champ, myHero) < 500 and getDmg('RUINEDKING', champ, myHero) > champ.health then UseItemOnTarget(3153, champ) end
			if Cfg['6. Item Options'].KSBWC and GetDistance(champ, myHero) < 450 and getDmg('BWC', champ, myHero) > champ.health then UseItemOnTarget(3144, champ) end
			if Cfg['6. Item Options'].KSDFG and GetDistance(champ, myHero) < 750 and getDmg('DFG', champ, myHero) > champ.health then UseItemOnTarget(3128, champ) end
			if Cfg['6. Item Options'].KSFQC and GetDistance(champ, myHero) < 750 and CalcMagicDamage(champ, (50+(5*myHero.selflevel))) > champ.health then UseItemOnTarget(3092, champ) end
			if Cfg['6. Item Options'].KSHTGB and GetDistance(champ, myHero) < 700 and getDmg('HXG', champ, myHero) > champ.health then UseItemOnTarget(3146, champ) end
			if Cfg['6. Item Options'].KSRH and GetDistance(champ, myHero) < 400 and getDmg('HYDRA', champ, myHero) > champ.health then UseItemOnTarget(3074, myHero) end
			if Cfg['6. Item Options'].KST and GetDistance(champ, myHero) < 400 and getDmg('TIAMAT', champ, myHero) > champ.health then UseItemOnTarget(3077, myHero) end
		end
	end
end 

function KSSpells(spell, range, spelltype, width, angle, speed, delay, collision, stage)-- FINSIH THIS ONE......
	for i = 1, objManager:GetMaxHeroes() do
		local champ = objManager:GetHero(i)
		if champ ~= nil and champ.team ~= myHero.team and ValidTarget(champ, range) and IsSpellReady(spell) and getDmg(spell, champ, myHero, stage) > champ.health then 
			if collision == 1 then 
				collision = true
			else
				collision = false
			end
			if spelltype == 1 then --Targeted
				CastSpellTarget(spell, champ)
			elseif spelltype == 2 then  -- SelfCast
				CastSpellTarget(spell, myHero)
			elseif spelltype == 3 then  --Line
				CastPosition,  HitChance,  Position = YP:GetLineCastPosition(champ, delay, width, range, speed, myHero, collision)
				if CastPosition and HitChance >= 2 then 
					local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
					CastSpellXYZ(spell, x, y, z)
				end
			elseif spelltype == 4 then --Circle
				CastPosition,  HitChance,  Position = YP:GetCircularCastPosition(champ, delay, width, range, speed, myHero, collision)
				if CastPosition and HitChance >= 2 then 
					local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
					CastSpellXYZ(spell, x, y, z)
				end	
			elseif spelltype == 5 then 
				CastPosition,  HitChance,  Position = YP:GetConeAOECastPosition(champ, delay, angle, range, speed, myHero)
				if CastPosition and HitChance >= 2 then 
					local x, y, z = CastPosition.x, CastPosition.y, CastPosition.z                
					CastSpellXYZ('Q', x, y, z)
				end		
			end
		end
	end
end

function RangeChecker()
	if Cfg['1. Q Options'].Q_Range_Checker then DrawCircleObject(myHero, Cfg['1. Q Options'].Q_Range, 1) end
	if Cfg['2. W Options'].W_Range_Checker then DrawCircleObject(myHero, Cfg['2. W Options'].W_Range, 5) end
	if Cfg['3. E Options'].E_Range_Checker then DrawCircleObject(myHero, Cfg['3. E Options'].E_Range, 6) end
	if Cfg['4. R Options'].R_Range_Checker then DrawCircleObject(myHero, Cfg['4. R Options'].R_Range, 2) end
end

SetTimerCallback('Main') 
