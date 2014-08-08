local ScriptName = 'autokool'
local Version = '2.9'
local Author = Koolkaracter

-- yupdate = * 2.9 http://pastebin.com/raw.php?i=bF1hT0mX http://pastebin.com/raw.php?i=ptZMiq2v


--[[      
 ____  __.            .__   __                               __                 /\                
|    |/ _|____   ____ |  | |  | ______ ____________    _____/  |_  ___________  )/______          
|      < /  _ \ /  _ \|  | |  |/ |__  \\_  __ \__  \ _/ ___\   __\/ __ \_  __ \  /  ___/          
|    |  (  <_> |  <_> )  |_|    < / __ \|  | \// __ \\  \___|  | \  ___/|  | \/  \___ \            
|____|__ \____/ \____/|____/__|_ (____  /__|  (____  /\___  >__|  \___  >__|    /____  >          
        \/                      \/    \/           \/     \/          \/             \/            
   _____          __            ____  __.            .__      _________            .__        __  
  /  _  \  __ ___/  |_  ____   |    |/ _|____   ____ |  |    /   _____/ ___________|__|______/  |_
 /  /_\  \|  |  \   __\/  _ \  |      < /  _ \ /  _ \|  |    \_____  \_/ ___\_  __ \  \____ \   __\
/    |    \  |  /|  | (  <_> ) |    |  (  <_> |  <_> )  |__  /        \  \___|  | \/  |  |_> >  |  
\____|__  /____/ |__|  \____/  |____|__ \____/ \____/|____/ /_______  /\___  >__|  |__|   __/|__|  
        \/                             \/                           \/     \/         |__|    

 
This script is version 2.0+.   This script does auto items, auto pots, and auto summoner spells.  
So basically it makes you Auto-Kool!
 
Supports the following Items:
---Bilgewater Cutlass
---Blackfire Torch
---Blackfire Torch
---Blade of the Ruined King
---Deathfire Grasp
---Entropy
---Face of the Mountain
---Frost Queens Claim
---Guardians Horn
---Hextech Gunblade
---Locket of Solari
---Odyns Veil
---Randuins Omen
---Ravenous Hydra
---Seraphs Embrace
---Sword of the Divine
---Tiamat
---Youmuus Ghostblade
---Zhonyas/Witchcap

Supports the following Potions:
---Biscuit
---Chrystalline Flask
---Elixir of Fortitude
---Health Potion
---Mana Potions
 
Supports the following Summoner Spells:
---Barrier
---Clarity
---Heal
---Exhaust (the % option is what % of your health to cast)
---Ignite (also takes into account targets health regen... not including regen from items)
 
Credit goes out to Val, LUA, Yonderboi, and Fiqt, and Maxxxel for some help. I also used a bun-cha parts from CConn81's Script, I changed a bit but still I contribute a large portion of the pots/summoners to him! Also a few others that I don't remember for a little help with the ally portion of the code.
 
Instructions -
 
Press Shift and go through menu to select only certain items, pots, summoners to use and what percentages to use them at.
Press Delete to toggle on or off AutoItems instead of having to go through menu(can be changed). This can be useful for champs like teemo that dont want to use items all the time.
 
***NOTE*** You might have to go into the menu and ensure all the boxes are selected the first time you use it.
 
Code:
Change Log:
v2.9 - Added Support for Cleanse, QuickSilver Sash, Dervish Blade, and  Mercurial Scimitar.  Only known problem is IsBuffed() returns true if particle is within 150 of your champ.. because of this if you walk over/extremely near another champ that is CC'd it might use your cleanse/QSS items. 

v2.8 - autokool will not be integrating yayo for the time being, however I have better enabled the use of autokool with anyscript to include your yayo scripts. 
---Split the items into Offensive/Defensive sections.  
---Added some script that allows integration with other scripts better.  Now your Champions scripts can call on AutoKool and still use all the functions (plus only use the OFFENSIVE items during your combo feature). 
---Added a require target/or not button for the Locket of Iron Solari(LoIS) and Face of the Mountain (FotM)
---Cleaned up scritp a little/removed unneeded items

---To Add autokool to your champion script(yayo or not) add the following to the top
require 'autokool' --Calls AutoKool Script

---Then add this to the top of your main function. 
KoolExternalChampScriptCheck(true) --Tells AutoKool Script that there is an external script that uses items and will only use Offensive items when this script tells it too via UseOffensiveItems(target) 

---Then add the following to your combo script(or location you want it to use Offensive items)
UseOffensiveItems(target) --This will use all offensive items on/near your scripts current target


--Example of adding Autokool to your champ script
require 'Utils'
require 'vals_lib'

require 'autokool'
 

local uiconfig = require 'uiconfig'
ChampConfig, menu = uiconfig.add_menu('Champ Config', 300)
menu.keydown("Combo", "Combo", Keys.A)
menu.permashow('Combo')

local target

function Run()
KoolExternalChampScriptCheck(true)
if ChampConfig.Combo then
	if target == nil then
		target = GetWeakEnemy('MAGIC', 625)
	end
		if target ~= nil then
			UseOffensiveItems(target)
			if GetDistance(myHero, target) < 625 and IsSpellReady("R") then 
				CastSpellTarget("R", target) 
			end			
			if GetDistance(myHero, target) < 625 and IsSpellReady("Q") then 
				CastSpellTarget("Q", target) 
			end
			if GetDistance(myHero, target) < 625 and IsSpellReady("W") then 
				CastSpellTarget("W", target) 
			end
			if IsSpellReady("Q") ~= true and IsSpellReady("W") ~= true and IsSpellReady("R") ~= true then 
				AttackTarget(target)
			end
		end
		if target == nil then 
			MoveMouse()
		end
end
SetTimerCallback('Run')
--end of example of adding Autokool to your champ script

v2.7 - Deleted

v2.6 - Deleted

v2.5.2 - fixed minor bug with heal potions, and Also, implemented an option on self cast ignite (Basically this function will highlight via a circle if the target is killable, then if they are highlighted
---RED (means killable and in range) and you press your ignite button then it will ignite them.. .no targeting needed. There will be 2 differnt circles,  Red and Orange.  Red means the target is killable and
---in range so hit your ignite button to ignite them.   Orange means they are killable but just out of range(100 or less) so if you have a speed boost, flash or something and want to go for it you know it
---would be worth, just use movement ability then press ignite button once it turns red (in range) and watch them die.


v2.5 - Added Support for guardians Horn (treats it same manor as Youmuus Ghostblade)
 
v2.4 - Fixed potions that would have multiple go off, if you manually popped a pot first.
 
v2.3 - Added option to use heal for allies (check the box under summoners menu).  Also added function to highlight target to let you know who it is going to use items on. Now will not use items, potions, or summoners while you are backing to the fountain.  (previously would use heal pots even if you were backing)
 
v2.2 - Added % health display (will help you know when you get close to your summoners/pots/items using)
 
v2.1.3 - Fixed a few typos, and repaired ignite, biscuits and elixirs.
 
v2.1.2 - Cleaned up menus a little more.
 
v2.1 - Cleaned up menus and added submenus (requires uiconfig V12 or greater, this is included in Yonderboi's installer)
 
v2.0 - Added Support for pots and Summoner Spells
 
v1.5 - Added support for Seraph's Embrace w/ checkbox and slider bar to be used as the percent of health to use the item at.
 
V1.4 - Added support for Zhonya's Hourglass and Wooglet's Witchcap and slider bar to be used as the percent of health to use the item at.
- moved the Face of Mountain and Locket of Iron Solari code to the right location so when you toggle the script off, those turn off as well.
 
v1.3 - Added the Face of the Mountain w/ checkbox and slider bar to be used as the percent of health to use the item at.
 
v1.2 -Added the Locket of Iron Solari w/ checkbox and slider bar to be used as the Percent of health to use the item at.
 
V1.1 - Added checkboxes to turn off individual items.
 
Known issues:
- none
]]--
 
require "Utils"
require 'vals_lib'
require 'champdb'
require 'IsInvulnerable'
require 'SKeys'
 
 
--Variables for Items
local target
local AttackRange = 10
local ShouldUseAntiCC
--End of Variables for Items

--Extra variables for Summoner Spells
local targetignite
local BadCC = {"Stun_glb", 
"AlZaharNetherGrasp_tar", 
"InfiniteDuress_tar", 
"skarner_ult_tail_tip", 
"SwapArrow_red", 
"summoner_banish", 
"Global_Taunt", 
"mordekaiser_cotg_tar", 
"Global_Fear", 
"Ahri_Charm_buf",
"leBlanc_shackle_tar", 
"LuxLightBinding_tar", 
"Fizz_UltimateMissle_Orbit", 
"Fizz_UltimateMissle_Orbit_Lobster", 
"RunePrison_tar", "DarkBinding_tar", 
"nassus_wither_tar", 
"Amumu_SadRobot_Ultwrap", 
"Amumu_Ultwrap", 
"maokai_elementalAdvance_root_01", 
"RengarEMax_tar", 
"VarusRHitFlash", 
"LOC_fear", 
"LOC_Stun", 
"LOC_Suppress", 
"LOC_Taunt"}
--End of Extra variables for Summoner Spells


--Config Menu
local uiconfig = require 'uiconfig'
CfgKoolSettings, menu = uiconfig.add_menu('1. Auto Kool', 300)
 
local submenuOItems = menu.submenu('1. Kool Offensive Items', 300)
submenuOItems.checkbutton('External_Script_ON', 'External Script uses Items', false)
submenuOItems.keytoggle('Kool_Offensive_Items_ON', 'Offensive Items', 46, true)--Delete to toggle
submenuOItems.checkbox('BC', '---Bilgewater Cutlass---', true)
submenuOItems.checkbox('BFT', '---Blackfire Torch---', true)
submenuOItems.checkbox('BFT', '---Blackfire Torch---', true)
submenuOItems.checkbox('BORK', '---Blade of the Ruined King---', true)
submenuOItems.checkbox('DFG', '---Deathfire Grasp---', true)
submenuOItems.checkbox('En', '---Entropy---', true)
submenuOItems.checkbox('FQC', '---Frost Queens Claim---', true)
submenuOItems.checkbox('GH', '---Guardians Horn---', true)
submenuOItems.checkbox('HG', '---Hextech Gunblade---', true)
submenuOItems.checkbox('OV', '---Odyns Veil---', true)
submenuOItems.checkbox('RO', '---Randuins Omen---', true)
submenuOItems.checkbox('RH', '---Ravenous Hydra---', true)
submenuOItems.checkbox('SOD', '---Sword of the Divine---', true)
submenuOItems.checkbox('T', '---Tiamat---', true)
submenuOItems.checkbox('YG', '---Youmuus Ghostblade---', true)
submenuOItems.permashow("Kool_Offensive_Items_ON")

local submenuDItems = menu.submenu('2. Kool Defensive Items', 350)
submenuDItems.checkbutton('Kool_Defensive_Items_ON', 'Defensive Items', true)
submenuDItems.checkbox('QSS', 'Quicksilver Sash and like items', true)
submenuDItems.checkbutton('Require_Targ_For_D_I_ON', 'Require Targ near Ally for LoIS and FotM', true)
submenuDItems.checkbox('Locket', 'Auto Use Locket of Solari', true)
submenuDItems.slider('LocketValue', 'Use Locket at X% health', 0, 100, 20)
submenuDItems.checkbox('FOM', 'Auto Use Face of the Mountain', true)
submenuDItems.slider('FOMValue', 'Use Face of the Mountain at X% health', 0, 100, 20)
submenuDItems.checkbox('ZH', 'Auto Use Zhonyas/Witchcap', true)
submenuDItems.slider('ZHValue', 'Use Zhonyas/Witchcap at X% health', 0, 100, 20)
submenuDItems.checkbox('SE', 'Auto Use Seraphs Embrace', true)
submenuDItems.slider('SEValue', 'Use Seraphs Embrace at X% health', 0, 100, 20)
submenuDItems.permashow("Kool_Defensive_Items_ON")
 
local submenuPotions = menu.submenu('3. Kool Potions', 300)
submenuPotions.checkbutton('Kool_Potions_ON', 'Master Auto Potions', true)
submenuPotions.checkbox('Health_Potion_ON', 'Health Potions', true)
submenuPotions.slider('Health_Potion_Value', 'Health Potion Value', 0, 100, 75)
submenuPotions.checkbox('Biscuit_ON', 'Biscuit', true)
submenuPotions.slider('Biscuit_Value', 'Biscuit Value', 0, 100, 60)
submenuPotions.checkbox('Chrystalline_Flask_ON', 'Chrystalline Flask', true)
submenuPotions.slider('Chrystalline_Flask_Value', 'Chrystalline Flask Value', 0, 100, 75)
submenuPotions.checkbox('Elixir_of_Fortitude_ON', 'Elixir of Fortitude', true)
submenuPotions.slider('Elixir_of_Fortitude_Value', 'Elixir of Fortitude Value', 0, 100, 30)
submenuPotions.checkbox('Mana_Potion_ON', 'Mana Potions', true)
submenuPotions.slider('Mana_Potion_Value', 'Mana Potion Value', 0, 100, 75)
 
local submenuSummoners = menu.submenu('4. Kool Summoners', 300)
submenuSummoners.checkbutton('Kool_Summoner_Spells_ON', 'Master Auto Summoner Spells', true)
submenuSummoners.checkbox('Auto_Cleanse_ON', 'Cleanse', true)
submenuSummoners.checkbox('Auto_Ignite_ON', 'Ignite', true)
submenuSummoners.checkbutton('Auto_Ignite_Self_ON', 'Ignite Self Cast (creates circle when killable)', false)
submenuSummoners.checkbox('Auto_Exhaust_ON', 'Exhaust', true)
submenuSummoners.slider('AutoExhaustValue', 'Auto Exhaust Value', 0, 100, 30)
submenuSummoners.checkbox('Auto_Barrier_ON', 'Barrier', true)
submenuSummoners.slider('AutoBarrierValue', 'Auto Barrier Value', 0, 100, 15)
submenuSummoners.checkbox('Auto_Clarity_ON', 'Clarity', true)
submenuSummoners.slider('AutoClarityValue', 'Auto Clarity Value', 0, 100, 40)
submenuSummoners.checkbox('Auto_Heal_ON', 'Heal', true)
submenuSummoners.checkbox('Auto_HealAlly_ON', 'Use Heal To Protect Allies', true)
submenuSummoners.slider('AutoHealValue', 'Auto Heal Value', 0, 100, 15)

menu.checkbutton('ShowPHP', 'Show % of HP', true)
menu.checkbutton('CircleTarget', 'Highlight Target', true)
--End of Config Menu

function MainRun()
        if IsLolActive() and IsChatOpen() == 0 then
                if IsBuffed(myHero, 'TeleportHome') ~= true then
					KoolExternalChampScriptCheck()
	                if CfgKoolSettings['1. Kool Offensive Items'].Kool_Offensive_Items_ON then 
						UseOffensiveItems()
					end
                    if CfgKoolSettings['2. Kool Defensive Items'].Kool_Defensive_Items_ON then 
						UseDefensiveItems()
					end
			if CfgKoolSettings['3. Kool Potions'].Kool_Potions_ON then AutoPots() end
                if CfgKoolSettings['4. Kool Summoners'].Kool_Summoner_Spells_ON then AutoSummoners() end
                if CfgKoolSettings.ShowPHP then ShowPercentHP() end
                if CfgKoolSettings.CircleTarget then CircleTarg() end
            else
                if CfgKoolSettings.ShowPHP then ShowPercentHP() end
                if CfgKoolSettings.CircleTarget then CircleTarg() end 
            end
        end
 end

--Use Items Functions
function AutoItemsCD()    
    if myHero.SpellTime1 > 1.0 then -- Checks if items are on cooldown
	RDY1 = true
    else RDY1 = false
    end
    if myHero.SpellTime2 > 1.0 then
 	RDY2 = true
    else RDY2 = false
    end
    if myHero.SpellTime3 > 1.0 then
 	RDY3 = true
    else RDY3 = false
    end
    if myHero.SpellTime4 > 1.0 then
  	RDY4 = true
    else RDY4 = false
    end
    if myHero.SpellTime5 > 1.0 then
	RDY5 = true
    else RDY5 = false
    end
    if myHero.SpellTime6 > 1.0 then
	RDY6 = true
    else RDY6 = false
    end
    if myHero.SpellTime7 > 1.0 then
	RDY7 = true
    else RDY7 = false
    end  
end
 
function UseOffensiveItems(target)

    AttackRange = myHero.range+(GetDistance(GetMinBBox(myHero)))

    if target == nil then
	target = GetWeakEnemy('PHYS', 900)
    end

    if target ~= nil then
	    AutoItemsCD() 
		if (RDY1 or RDY2 or RDY3 or RDY4 or RDY5 or RDY6 or RDY7) then
			if CfgKoolSettings['1. Kool Offensive Items'].BC and (GetDistance(myHero, target) < 400) then -- In Item Range (IR)
				UseItemOnTarget(3144, target) -- Bilgewater Cutlass
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].HG and (GetDistance(myHero, target) < 700) then -- IR
				UseItemOnTarget(3146, target) -- Hextech Gunblade
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].BORK and (GetDistance(myHero, target) < 500) then -- IR
				UseItemOnTarget(3153, target) -- Blade of the Ruined King
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].DFG and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3128, target) -- Deathfire Grasp
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].FQC and (GetDistance(myHero, target) < 850) then -- IR
				UseItemOnTarget(3092, target) -- Frost Queen's Claim
			end
			if CfgKoolSettings['1. Kool Offensive Items'].BFT and (GetDistance(myHero, target) < 750) then -- IR
				UseItemOnTarget(3188, target) -- Blackfire Torch
			end    
			if CfgKoolSettings['1. Kool Offensive Items'].OV and (GetDistance(myHero, target) < 525) then -- IR
				UseItemOnTarget(3180, target) -- Odyn's Veil
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].RO and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3143, target) -- Randuin's Omen
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].RH and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3074, target) -- Ravenous Hydra
			end    
			if CfgKoolSettings['1. Kool Offensive Items'].T and (GetDistance(myHero, target) < 400) then -- IR
				UseItemOnTarget(3077, target) -- Tiamat
			end    
			if CfgKoolSettings['1. Kool Offensive Items'].SOD and (GetDistance(myHero, target) < AttackRange+10) then -- In AA Range (AR)
				UseItemOnTarget(3131, target) -- Sword of the Divine
			end        
			if CfgKoolSettings['1. Kool Offensive Items'].YG and (GetDistance(myHero, target) < AttackRange+10) then -- AR
				UseItemOnTarget(3142, target) -- Youmuu's Ghostblade
			end
			if CfgKoolSettings['1. Kool Offensive Items'].En and (GetDistance(myHero, target) < AttackRange+10) then -- AR
				UseItemOnTarget(3184, target) -- Entropy
			end
			if CfgKoolSettings['1. Kool Offensive Items'].GH and (GetDistance(myHero, target) < AttackRange+10) then -- AR
				UseItemOnTarget(3142, target) -- Guardians Horn
			end
		end
     end
end


function UseDefensiveItems(target)
    	AutoItemsCD() 
    	if target == nil then
		target = GetWeakEnemy('PHYS', 900)
    	end  
     
	if (RDY1 or RDY2 or RDY3 or RDY4 or RDY5 or RDY6 or RDY7) and IsBuffed(myHero, "FountainHeal") ~= true then

		for i = 1, objManager:GetMaxHeroes() do
		local ally = objManager:GetHero(i)
		if CfgKoolSettings['2. Kool Defensive Items'].Require_Targ_For_D_I_ON and ally ~= nil and ally.team == myHero.team and ally.visible == 1 and GetDistance(myHero, ally) < 600 then
	        if target ~= nil and CfgKoolSettings['2. Kool Defensive Items'].Locket and ally.health <= (ally.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].LocketValue / 100)) and GetDistance(ally, target) < 900 then --If health is below the slider % value
	            UseItemOnTarget(3190,ally) -- Locket of Iron Solari
	        end
	        if target ~= nil and CfgKoolSettings['2. Kool Defensive Items'].FOM and ally.health <= (ally.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].FOMValue / 100)) and GetDistance(ally, target) < 900 then --If health is below the slider % value
	            UseItemOnTarget(3401,ally) -- Face of the Mountain
	        end

		elseif CfgKoolSettings['2. Kool Defensive Items'].Require_Targ_For_D_I_ON ~= true and ally ~= nil and ally.team == myHero.team and ally.visible == 1 and GetDistance(myHero, ally) < 600 then
		
	        if CfgKoolSettings['1. Kool Offensive Items'].Locket and ally.health <= (ally.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].LocketValue / 100)) then --If health is below the slider % value
	            UseItemOnTarget(3190,ally) -- Locket of Iron Solari
	        end
	        if CfgKoolSettings['1. Kool Offensive Items'].FOM and ally.health <= (ally.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].FOMValue / 100)) then --If health is below the slider % value
	            UseItemOnTarget(3401,ally) -- Face of the Mountain
	        end
		end
		end
       
	    if CfgKoolSettings['2. Kool Defensive Items'].ZH and myHero.health <= (myHero.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].ZHValue / 100)) then --If health is below the slider % value
	        UseItemOnTarget(3157,myHero) -- Zhonya's Hourglass
	        UseItemOnTarget(3090,myHero) -- Wooglet's Witchap
	    end
               
		if CfgKoolSettings['2. Kool Defensive Items'].SE and myHero.health <= (myHero.maxHealth*(CfgKoolSettings['2. Kool Defensive Items'].SEValue / 100)) then --If health is below the slider % value
	        UseItemOnTarget(3040,myHero) -- Seraph's Embrace
	    end
	end
end

function KoolExternalChampScriptCheck(scrip)

	if scrip or CfgKoolSettings['1. Kool Offensive Items'].External_Script_ON then
		CfgKoolSettings['1. Kool Offensive Items'].Kool_Offensive_Items_ON = false
	end
end

--End of Use Items functions

 
--Use Potions functions
function AutoPots()
        if IsBuffed(myHero, "FountainHeal") ~= true then
                if myHero.health < myHero.maxHealth * (CfgKoolSettings['3. Kool Potions'].Health_Potion_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        usePotion()
                end
                if myHero.health < myHero.maxHealth * (CfgKoolSettings['3. Kool Potions'].Biscuit_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion')~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        useBiscuit()
                end    
                if myHero.health < myHero.maxHealth * (CfgKoolSettings['3. Kool Potions'].Chrystalline_Flask_Value / 100) and IsBuffed(myHero, 'Global_Item_HealthPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_HealthPotion') ~= true then
                        useFlask()
                end    
                if myHero.health < myHero.maxHealth * (CfgKoolSettings['3. Kool Potions'].Elixir_of_Fortitude_Value / 100) and IsBuffed(myHero, 'PotionofGiantStrength_itm') ~= true  then
                        useElixir()
                end
                if myHero.mana < myHero.maxMana * (CfgKoolSettings['3. Kool Potions'].Mana_Potion_Value / 100) and IsBuffed(myHero, 'Global_Item_ManaPotion') ~= true and IsBuffed(myHero, 'GLOBAL_Item_ManaPotion') ~= true then
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
 
--End of Use Potions functions
 
---Summoner Spell functions
function AutoSummoners()
        if CfgKoolSettings['4. Kool Summoners'].Auto_Ignite_ON then SummonerIgnite() end
        if CfgKoolSettings['4. Kool Summoners'].Auto_Barrier_ON then SummonerBarrier() end
        if CfgKoolSettings['4. Kool Summoners'].Auto_Heal_ON then SummonerHeal() end
        if CfgKoolSettings['4. Kool Summoners'].Auto_Exhaust_ON then SummonerExhaust() end
        if CfgKoolSettings['4. Kool Summoners'].Auto_Clarity_ON then SummonerClarity() end
		if CfgKoolSettings['4. Kool Summoners'].Auto_Cleanse_ON then SummonerCleanse() end
end
 
function SummonerIgnite()

--[[
This Ignite scripts calculates the targets health regen and
determines if you can kill the target taking in account their
natural health regen. This does not yet take into account health
regen from items... Some day perhaps!
]]--	

	if myHero.SummonerD == 'SummonerDot'  or myHero.SummonerF == 'SummonerDot' then --Dont waist time/energy if you dont have ignite 
		if myHero.SummonerD == 'SummonerDot' then 
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

				if CfgKoolSettings['4. Kool Summoners'].Auto_Ignite_Self_ON then 
					if (ignKey == Keys.D and myHero.SpellTimeD > 1) or (ignKey == Keys.F and myHero.SpellTimeF > 1 )then
						if targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) < 600 then
							CustomCircle(100,8,2,targetIgnite)--RED
									targCircle = 2	--Ready to Cast     	                       		
						elseif targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) > 599 and GetDistance(myHero, targetIgnite) < 700 then
							CustomCircle(100,8,8,targetIgnite) --ORANGE
							targCircle = 1 --Ready to cast but target is just out of range (100 away)
						else
							targCircle = 0
						end
					
						if targCircle == 2 and KeyDown(ignKey) then CastSummonerIgnite(targetIgnite) end --Cast ignite on killable target when ignite key is pressed
					end
				else
					if targetIgnite.health < ignDamageAfterRegen and GetDistance(myHero, targetIgnite) < 600 then CastSummonerIgnite(targetIgnite) end

				end 				                   		
			end
		end
	end
end
 
 
function SummonerBarrier()
                if myHero.SummonerD == 'SummonerBarrier' or myHero.SummonerF == 'SummonerBarrier' then
                        if myHero.health < myHero.maxHealth*(CfgKoolSettings['4. Kool Summoners'].AutoBarrierValue / 100) then
                                CastSummonerBarrier()
                        end
                end
end
 
function SummonerHeal()
        if myHero.SummonerD == 'SummonerHeal' or myHero.SummonerF == 'SummonerHeal' then
                if CfgKoolSettings['4. Kool Summoners'].Auto_HealAlly_ON then --will activate when alley within range is below X%
                        for h = 1, objManager:GetMaxHeroes() do
                                        local allyH = objManager:GetHero(h)
                                        if (allyH ~= nil and allyH.team == myHero.team and allyH.visible == 1 and GetDistance(myHero, allyH) < 700) or allyH == myHero then
                                                        if allyH.health <= (allyH.maxHealth*(CfgKoolSettings['4. Kool Summoners'].AutoHealValue / 100)) then --If health is below the slider % value
															CastSummonerHeal()                            
                                                        end
                                        end
                        end
                else --HealAlly not on, will just activate on self
                        if myHero.health < myHero.maxHealth*(CfgKoolSettings['4. Kool Summoners'].AutoHealValue / 100) then
                                CastSummonerHeal()
                        end
                end
        end
end
 
function SummonerExhaust()
        if target ~= nil then
                if myHero.SummonerD == 'SummonerExhaust' or myHero.SummonerF == 'SummonerExhaust' then
                        if myHero.health < myHero.maxHealth*(CfgKoolSettings['4. Kool Summoners'].AutoExhaustValue / 100) and GetDistance(myHero, target) < 650 then
                                if myHero.health < target.health then
                                        CastSummonerExhaust(target)
                                end
                        end
                end
        end
end
 
function SummonerClarity()
                if myHero.SummonerD == 'SummonerMana' or myHero.SummonerF == 'SummonerMana' then
                        if myHero.mana < myHero.maxMana*(CfgKoolSettings['4. Kool Summoners'].AutoClarityValue / 100) then
                                CastSummonerClarity()
                        end
                end
end


function SummonerCleanse()
	if myHero.SummonerD == 'SummonerBoost'or myHero.SummonerF == 'SummonerBoost' then
		if ShouldCleanse() then
			UseQSSOrCleanse()
		end
	end
end

--End of Summoner Spell functions
 
--Show % of HP
function ShowPercentHP()
 
        local myHP = ((myHero.health / myHero.maxHealth) * 100)
        myHP = string.format('%d%%', myHP)
        DrawTextObject(myHP,myHero,Color.White)
       
end
--End of Show % of HP
 
--Circle Target
function CircleTarg()
        if target ~= nil then
                CustomCircle(60,4,1,target)
        end
end
 --End of Circle Target
 
 --Misc QSS CLeanse Functions
function ShouldCleanse()
	local shouldCleanse = false
	local i = 1
	while BadCC[i] ~= nil do
		if IsBuffed(myHero, BadCC[i]) == true then 
			shouldCleanse = true
		end
		i = i + 1
	end
	return shouldCleanse
end
       
function ItemNotOnCD(itemNum)
	local isReady = false

	if itemNum == "1" or itemNum == 1 then
		if myHero.SpellTime1 > 1 then
			isReady = true
		end
	end
	if itemNum == "2" or itemNum == 2 then
		if myHero.SpellTime2 > 1 then
			isReady = true
		end
	end
	if itemNum == "3" or itemNum == 3 then
		if myHero.SpellTime3 > 1 then
			isReady = true
		end
	end
	if itemNum == "4" or itemNum == 4 then
		if myHero.SpellTime4 > 1 then
			isReady = true
		end
	end
	if itemNum == "5" or itemNum == 5 then
		if myHero.SpellTime5 > 1 then
			isReady = true
		end
	end
	if itemNum == "6" or itemNum == 6 then
		if myHero.SpellTime6 > 1 then
			isReady = true
		end
	end
	if itemNum == "7" or itemNum == 7 then
		if myHero.SpellTime7 > 1 then
			isReady = true
		end
	end
	
	return isReady
end

function QSSItemRdy()

	local DervishBlade = GetInventorySlot(3137)
	local MercurialScimitar = GetInventorySlot(3139)
	local QuickSilverSash = GetInventorySlot(3140)

	if ItemNotOnCD(DervishBlade) or ItemNotOnCD(MercurialScimitar) or ItemNotOnCD(QuickSilverSash) then
			return true
	else
		return false
	end

end

function CleanseRdy()
	if myHero.SummonerD == 'SummonerBoost'or myHero.SummonerF == 'SummonerBoost' then
		if myHero.SummonerD == 'SummonerBoost' then

			if myHero.SpellTimeD > 1 then 
				return true 
			else 
				return false
			end
		else
			if myHero.SpellTimeF > 1 then 
				return true 
			else 
				return false
			end
		end

	else
		return false
	end
end

function UseQSSOrCleanse()

	if CfgKoolSettings['2. Kool Defensive Items'].Kool_Defensive_Items_ON and CfgKoolSettings['2. Kool Defensive Items'].QSS and CfgKoolSettings['4. Kool Summoners'].Kool_Summoner_Spells_ON and CfgKoolSettings['4. Kool Summoners'].Auto_Cleanse_ON then

		if QSSItemRdy() then   
			UseItemOnTarget(3137, myHero) -- Dervish Blade
			UseItemOnTarget(3139, myHero) -- Mercurial Scimitar
			UseItemOnTarget(3140, myHero) -- Quicksilver Sash
		elseif CleanseRdy() then

			if myHero.SummonerD == 'SummonerBoost' then
				CastSpellTarget('D',myHero)
			else
				CastSpellTarget('F',myHero)
			end

		end

	elseif CfgKoolSettings['2. Kool Defensive Items'].Kool_Defensive_Items_ON and CfgKoolSettings['2. Kool Defensive Items'].QSS then

		if QSSItemRdy() then
			UseItemOnTarget(3137, myHero) -- Dervish Blade
			UseItemOnTarget(3139, myHero) -- Mercurial Scimitar
			UseItemOnTarget(3140, myHero) -- Quicksilver Sash
		end

	elseif CfgKoolSettings['4. Kool Summoners'].Kool_Summoner_Spells_ON and CfgKoolSettings['4. Kool Summoners'].Auto_Cleanse_ON then
		if CleanseRdy() then

			if myHero.SummonerD == 'SummonerBoost' then
				CastSpellTarget('D',myHero)
			else
				CastSpellTarget('F',myHero)
			end
		end
	else
		--do nothing because both are turned off or not available
	end
end

--End of Misc QSS Cleanse Functions
 
 
SetTimerCallback("MainRun")
