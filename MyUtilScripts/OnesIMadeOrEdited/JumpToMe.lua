-- ************************** LBC META *****************************
-- * lbc_name = JumpToMe.lua
-- * lbc_version = 1.0
-- * lbc_date = 10/06/2014 // use correct date format mm/dd/yyyy
-- * lbc_status = 3 // 0 = unknowen; 1 = alpha/wip; 2 = beta; 3 = ready; 4 = required; 5 = outdated
-- * lbc_type = 5 // 0 = others; 1 = binaries; 2 = libs; 3 = champion; 4 = hotkey; 5 = utility
-- * lbc_creator = koolkaracter
-- * lbc_champion = // if this script is for a special champ
-- * lbc_tags = LeeSin, Katarina, Jax, Braum, Ward Hop, Jump, Kool, kool, iskool, koolkaracter
-- * lbc_link = http://leaguebot.net/forum/Upload/showthread.php?tid=4488
-- * lbc_source = https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/MyUtilScripts/OnesIMadeOrEdited/JumpToMe.lua
-- * lbc_update = // only if you have a new version on a new source
-- ************************** LBC META *****************************

local Allies = {}
local AlliesIndex = 1

--Populate Allies Table
for i = 1, objManager:GetMaxHeroes(), 1 do
	Champ = objManager:GetHero(i)
	if Champ ~= nil and Champ.team == myHero.team then
		if Allies[Champ.name] == nil then
			Allies[Champ.name] = { Unit = Champ, Number = AlliesIndex, name = Champ.name }
			AlliesIndex = AlliesIndex + 1
			tableFull = false
		end
	end
end

--Primary function
function Run()
	for i, Ally in pairs(Allies) do
		if Ally ~= nil and Ally.name ~= myHero.namez then
			if Ally.name == 'LeeSin' then CustomCircle(700,1,1,Ally.Unit) end
			if Ally.name == 'Katarina' then CustomCircle(700,1,1,Ally.Unit) end
			if Ally.name == 'Jax' then CustomCircle(700,1,1,Ally.Unit) end
			if Ally.name == 'Braum' then CustomCircle(650,1,1,Ally.Unit) end
		end
	end
end

--Mandatory function to continue to run
SetTimerCallback("Run")
