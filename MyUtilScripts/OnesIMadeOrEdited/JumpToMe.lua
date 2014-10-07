

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
