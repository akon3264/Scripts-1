if myHero.name == "Elise" or  myHero.name == "Jayce" or  myHero.name == "Leblanc" or  myHero.name == "Khazix" or  myHero.name == "Nidalee" then return end --Currently not supported champions. 
--[[
 ____  __.            .__      ___________   .__.__  .__                                             
|    |/ _|____   ____ |  |    /   _____/  | _|__|  | |  | ________                                   
|      < /  _ \ /  _ \|  |    \_____  \|  |/ /  |  | |  | \___   /                                   
|    |  (  <_> |  <_> )  |__  /        \    <|  |  |_|  |__/    /                                    
|____|__ \____/ \____/|____/ /_______  /__|_ \__|____/____/_____ \                                   
        \/                           \/     \/                  \/                                   
__________          ____  __.            .__   ____  __.                           __                
\______   \___.__. |    |/ _|____   ____ |  | |    |/ _|____ ____________    _____/  |_  ___________ 
 |    |  _<   |  | |      < /  _ \ /  _ \|  | |      < \__  \\_  __ \__  \ _/ ___\   __\/ __ \_  __ \
 |    |   \\___  | |    |  (  <_> |  <_> )  |_|    |  \ / __ \|  | \// __ \\  \___|  | \  ___/|  | \/
 |______  // ____| |____|__ \____/ \____/|____/____|__ (____  /__|  (____  /\___  >__|  \___  >__|   
        \/ \/              \/                         \/    \/           \/     \/          \/       
]]--

local ScriptName = 'KoolSkillz'
local Version = '.5'
local Author = Koolkaracter

-- yupdate = * .5 https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/MyUtilScripts/OnesIMadeOrEdited/KoolSkillz/KoolSkillz.lua https://raw.githubusercontent.com/koolkaracter/Scripts/AutoKool/MyUtilScripts/OnesIMadeOrEdited/KoolItems/KoolItemsVersion.lua

--[[
Champion that currently are not supported at all:
Any Champion that doesn't have abilities that you cast directly on a target (i.e. enemycast)... So champs that are all skillshots/self cast (this will change with skillshot update, v 1.0
Elise
Jayce
Leblanc
Khazix
Nidalee
]]--

--[[
Champions that are partially supported:
None Yet (this will change at the beginning phase of the skill shot section, when I have to have different changes in ranges and such. 
]]--

--[[
ToDo List:
--Complete table with skillshot type(AOE, Line, Cone... )
--Complete table with skillshot collision
--Add Skillshot yPred functions for all champs with skillshots
--Add Ally Selector
--Add Ally Cast on Ally Selected
--Add full support for champs with multiple versions of spells(Elise, LeeSin, Jayce, leblanc, Urgot(q range), Fizz(E), Khazix(range changes), Nidalee, Shyvanna(e), yasuo(Q range changes)) 
--Add Supt for EveryCast(Jax's Q, Katarina's E)
--Add Supt for SelfEnemyCast(Lissandra's Ult)
--Add Supt for Teemo's shrooms to just drop in plance not try to walk to enemy. 
--Add Supt to cast on lowest % health Ally
--Add Range Indicator Option
]]--

require 'yprediction'

local yayo = require 'yayo'
local uiconfig = require 'uiconfig'
local YP = YPrediction()
local champName = myHero.name
local qSupported, wSupported, eSupported, rSupported = false, false, false, false
local target = nil
print(champName)
QInfo = {range = nil, width = nil, speed = nil, delay = nil, dmgType = nil}
WInfo = {range = nil, width = nil, speed = nil, delay = nil, dmgType = nil}
EInfo = {range = nil, width = nil, speed = nil, delay = nil, dmgType = nil}
RInfo = {range = nil, width = nil, speed = nil, delay = nil, dmgType = nil}

------------------------------------------------------------
------------------Champion Information Table----------------
------------------------------------------------------------
ChampInfo = {
  Aatrox = { 
	Q = {
    charName = 'Aatrox',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Aatrox',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Aatrox',
    spellSlot = 'E',
    range = 1000,
    width = 150,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Aatrox',
    spellSlot = 'R',
    range = 550,
    width = 550,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Ahri = {
	Q = {
    charName = 'Ahri',
    spellSlot = 'Q',
    range = 880,
    width = 80,
    speed = 1100,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Ahri',
    spellSlot = 'W',
    range = 800,
    width = 800,
    speed = 1800,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Ahri',
    spellSlot = 'E',
    range = 975,
    width = 60,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Ahri',
    spellSlot = 'R',
    range = 450,
    width = 0,
    speed = 2200,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Akali = {
    Q = {
    charName = 'Akali',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 1000,
    delay = 0.65,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Akali',
    spellSlot = 'W',
    range = 700,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Akali',
    spellSlot = 'E',
    range = 325,
    width = 325,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Akali',
    spellSlot = 'R',
    range = 800,
    width = 0,
    speed = 2200,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Alistar = {
	Q = {
    charName = 'Alistar',
    spellSlot = 'Q',
    range = 365,
    width = 365,
    speed = 20,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Alistar',
    spellSlot = 'W',
    range = 650,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Alistar',
    spellSlot = 'E',
    range = 575,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _E
	},
	R = {
    charName = 'Alistar',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 828,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    qssSlot = _R
	}
  },
  Amumu = {
	Q = {
    charName = 'Amumu',
    spellSlot = 'Q',
    range = 1100,
    width = 80,
    speed = 2000,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Amumu',
    spellSlot = 'W',
    range = 300,
    width = 300,
    speed = math.huge,
    delay = 0.47,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Amumu',
    spellSlot = 'E',
    range = 350,
    width = 350,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Amumu',
    spellSlot = 'R',
    range = 550,
    width = 550,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 0
	}
  },
  Anivia = {
	Q = {
    charName = 'Anivia',
    spellSlot = 'Q',
    range = 1200,
    width = 110,
    speed = 850,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Anivia',	
    spellSlot = 'W',
    range = 1000,
    width = 400,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Anivia',
    spellSlot = 'E',
    range = 650,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Anivia',
    spellSlot = 'R',
    range = 675,
    width = 400,
    speed = math.huge,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Annie = {
    Q = {
    charName = 'Annie',
    spellSlot = 'Q',
    range = 623,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'Kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Annie',
    spellSlot = 'W',
    range = 623,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'Kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Annie',
    spellSlot = 'E',
    range = 100,
    width = 0,
    speed = 20,
    delay = 0,
    spellType = 'selfCast',
    rickLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    aaShieldSlot = _E
	},
	R = {
    charName = 'Annie',
    spellSlot = 'R',
    range = 600,
    width = 290,
    delay = 0.5,
    spellType = 'skillShot',
    risklevel = 'Kill',
    cc = false,
    hitLineCheck = true,
    timer = 0
	}
  },
  Ashe = {
	Q = {
    charName = 'Ashe',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Ashe',
    spellSlot = 'W',
    range = 1200,
    width = 250,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Ashe',
    spellSlot = 'E',
    range = 2500,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Ashe',
    spellSlot = 'R',
    range = 50000,
    width = 130,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Blitzcrank = {
	Q = {
    charName = 'Blitzcrank',
    spellSlot = 'Q',
    range = 925,
    width = 70,
    speed = 1800,
    delay = 0.22,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Blitzcrank',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Blitzcrank',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Blitzcrank',
    spellSlot = 'R',
    range = 600,
    width = 600,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Brand = {
	Q = {
    charName = 'Brand',
    spellSlot = 'Q',
    range = 1150,
    width = 80,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Brand',
    spellSlot = 'W',
    range = 240,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Brand',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = 1800,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Brand',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 1000,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 230 - GetLatency()
	}
  },
  Braum = {
	Q = {
    charName = 'Braum',
    spellSlot = 'Q',
    range = 1100,
    width = 100,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extremeq',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Braum',
    spellSlot = 'W',
    range = 650,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmgr',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Braum',
    spellSlot = 'E',
    range = 250,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'skillshot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Braum',
    spellSlot = 'R',
    range = 1250,
    width = 180,
    speed = 1200,
    delay = 0,
    spellType = 'skillshot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Caitlyn = {
	Q = {
    charName = 'Caitlyn',
    spellSlot = 'Q',
    range = 2000,
    width = 90,
    speed = 2200,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Caitlyn',
    spellSlot = 'W',
    range = 800,
    width = 0,
    speed = 1400,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Caitlyn',
    spellSlot = 'E',
    range = 950,
    width = 80,
    speed = 2000,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Caitlyn',
    spellSlot = 'R',
    range = 2500,
    width = 0,
    speed = 1500,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 1350 - GetLatency()
	}
  },
  Cassiopeia = {
	Q = {
    charName = 'Cassiopeia',
    spellSlot = 'Q',
    range = 925,
    width = 130,
    speed = math.huge,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Cassiopeia',
    spellSlot = 'W',
    range = 925,
    width = 212,
    speed = 2500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Cassiopeia',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 1900,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Cassiopeia',
    spellSlot = 'R',
    range = 875,
    width = 210,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true,
    timer = 0
	}
  },
  Chogath = {
	Q = {
    charName = 'Chogath',
    spellSlot = 'Q',
    range = 1000,
    width = 250,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Chogath',
    spellSlot = 'W',
    range = 675,
    width = 210,
    speed = math.huge,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Chogath',
    spellSlot = 'E',
    range = 0,
    width = 170,
    speed = 347,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Chogath',
    spellSlot = 'R',
    range = 230,
    width = 0,
    speed = 500,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Corki = {
	Q = {
    charName = 'Corki',
    spellSlot = 'Q',
    range = 875,
    width = 250,
    speed = math.huge,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Corki',
    spellSlot = 'W',
    range = 875,
    width = 160,
    speed = 700,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Corki',
    spellSlot = 'E',
    range = 750,
    width = 100,
    speed = 902,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Corki',
    spellSlot = 'R',
    range = 1225,
    width = 40,
    speed = 828.5,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Darius = {
	Q = {
    charName = 'Darius',
    spellSlot = 'Q',
    range = 425,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Darius',
    spellSlot = 'W',
    range = 210,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Darius',
    spellSlot = 'E',
    range = 540,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Darius',
    spellSlot = 'R',
    range = 460,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Diana = {
	Q = {
    charName = 'Diana',
    spellSlot = 'Q',
    range = 900,
    width = 75,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Diana',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Diana',
    spellSlot = 'E',
    range = 300,
    width = 300,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Diana',
    spellSlot = 'R',
    range = 800,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	}
  },
  DrMundo = {
	Q = {
    charName = 'DrMundo',
    spellSlot = 'Q',
    range = 1000,
    width = 75,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'DrMundo',
    spellSlot = 'W',
    range = 225,
    width = 225,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'DrMundo',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'DrMundo',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Draven = {
	Q = {
    charName = 'Draven',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Draven',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Draven',
    spellSlot = 'E',
    range = 1050,
    width = 130,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Draven',
    spellSlot = 'R',
    range = 20000,
    width = 160,
    speed = 2000,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Elise = {          -- Need to add Support for her different versions. 
	Q1 = {
    charName = 'Elise',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = 2200,
    delay = 0.75,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W1 = {
    charName = 'Elise',
    spellSlot = 'W',
    range = 950,
    width = 235,
    speed = 5000,
    delay = 0.75,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E1 = {
    charName = 'Elise',
    spellSlot = 'E',
    range = 1075,
    width = 70,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = true
	},
	R1 = {
    charName = 'Elise',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	Q2 = {
    charName = 'Elise',
    spellSlot = 'QM',
    range = 475,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W2 = {
    charName = 'Elise',
    spellSlot = 'WM',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E2 = {
    charName = 'Elise',
    spellSlot = 'EM',
    range = 975,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'enemyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R2 = {
    charName = 'Elise',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Evelynn = {
	Q = {
    charName = 'Evelynn',
    spellSlot = 'Q',
    range = 500,
    width = 500,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Evelynn',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    slowSlot = _W
	},
	E = {
    charName = 'Evelynn',
    spellSlot = 'E',
    range = 290,
    width = 0,
    speed = 900,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Evelynn',
    spellSlot = 'R',
    range = 650,
    width = 350,
    speed = 1300,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Ezreal = {
	Q = {
    charName = 'Ezreal',
    spellSlot = 'Q',
    range = 1200,
    width = 60,
    speed = 2000,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Ezreal',
    spellSlot = 'W',
    range = 1050,
    width = 80,
    speed = 1600,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Ezreal',
    spellSlot = 'E',
    range = 475,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Ezreal',
    spellSlot = 'R',
    range = 20000,
    width = 160,
    speed = 2000,
    delay = 1,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  FiddleSticks = {
	Q = {
    charName = 'FiddleSticks',
    spellSlot = 'Q',
    range = 575,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'FiddleSticks',
    spellSlot = 'W',
    range = 575,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
   },
	E = {
    charName = 'FiddleSticks',
    spellSlot = 'E',
    range = 750,
    width = 0,
    speed = 1100,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'FiddleSticks',
    spellSlot = 'R',
    range = 800,
    width = 600,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false,
    timer = 0
	}
  },
  Fiora = {
	Q = {
    charName = 'Fiora',
    spellSlot = 'Q',
    range = 300,
    width = 0,
    speed = 2200,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Fiora',
    spellSlot = 'W',
    range = 100,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    aaShieldSlot = _W
	},
	E = {
    charName = 'Fiora',
    spellSlot = 'E',
    range = 210,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Fiora',
    spellSlot = 'R',
    range = 210,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 280 - GetLatency()
	}
  },
  Fizz = {
	Q = {
    charName = 'Fizz',
    spellSlot = 'Q',
    range = 550,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Fizz',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
--[[E1 = {
    charName = 'Fizz',
    spellSlot = 'E',
    range = 400,
    width = 120,
    speed = 1300,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    shieldSlot = _E
	},                     ]] --  Check if this is needed for the E or if I can just use 2nd E(below)
	E = {
    charName = 'Fizz',
    spellSlot = 'E',
    range = 400,
    width = 500,
    speed = 1300,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = { 						--Look into making this always max range
    charName = 'Fizz',
    spellSlot = 'R',
    range = 1275,
    width = 250,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Galio = {
	Q = {
    charName = 'Galio',
    spellSlot = 'Q',
    range = 940,
    width = 120,
    speed = 1300,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Galio',
    spellSlot = 'W',
    range = 800,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Galio',
    spellSlot = 'E',
    range = 1180,
    width = 140,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Galio',
    spellSlot = 'R',
    range = 560,
    width = 560,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 0
	}
  },
  Gangplank = {
	Q = {
    charName = 'Gangplank',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = 2000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Gangplank',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _W,
    qssSlot = _W
	},
	E = {
    charName = 'Gangplank',
    spellSlot = 'E',
    range = 1300,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Gangplank',
    spellSlot = 'R',
    range = 20000,
    width = 525,
    speed = 500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	}
  },
  Garen = {
	Q = {
    charName = 'Garen',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.2,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    slowSlot = _Q
	},
	W = {
    charName = 'Garen',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Garen',
    spellSlot = 'E',
    range = 325,
    width = 325,
    speed = 700,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Garen',
    spellSlot = 'R',
    range = 400,
    width = 0,
    speed = math.huge,
    delay = 0.12,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Gragas = {
	Q = {
    charName = 'Gragas',
    spellSlot = 'Q',
    range = 1100,
    width = 320,
    speed = 1000,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Gragas',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Gragas',
    spellSlot = 'E',
    range = 1100,
    width = 50,
    speed = 1000,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Gragas',
    spellSlot = 'R',
    range = 1100,
    width = 700,
    speed = 1000,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Graves = {
	Q = {
    charName = 'Graves',
    spellSlot = 'Q',
    range = 1100,
    width = 10,
    speed = 902,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Graves',
    spellSlot = 'W',
    range = 1100,
    width = 250,
    speed = 1650,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Graves',
    spellSlot = 'E',
    range = 425,
    width = 50,
    speed = 1000,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Graves',
    spellSlot = 'R',
    range = 1000,
    width = 100,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Hecarim = {
	Q = {
    charName = 'Hecarim',
    spellSlot = 'Q',
    range = 350,
    width = 350,
    speed = 1450,
    delay = 0.3,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Hecarim',
    spellSlot = 'W',
    range = 525,
    width = 525,
    speed = 828.5,
    delay = 0.12,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Hecarim',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = math.huge,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Hecarim',
    spellSlot = 'R',
    range = 1350,
    width = 200,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Heimerdinger = {
	Q = {
    charName = 'Heimerdinger',
    spellSlot = 'Q',
    range = 350,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Heimerdinger',
    spellSlot = 'W',
    range = 1525,
    width = 200,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Heimerdinger',
    spellSlot = 'E',
    range = 970,
    width = 120,
    speed = 2500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Heimerdinger',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.23,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Irelia = {
	Q = {
    charName = 'Irelia',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 2200,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Irelia',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 347,
    delay = 0.23,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Irelia',
    spellSlot = 'E',
    range = 325,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Irelia',
    spellSlot = 'R',
    range = 1200,
    width = 0,
    speed = 779,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Janna = {
	Q = {
    charName = 'Janna',
    spellSlot = 'Q',
    range = 1800,
    width = 200,
    speed = math.huge,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Janna',
    spellSlot = 'W',
    range = 600,
    width = 0,
    speed = 1600,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Janna',
    spellSlot = 'E',
    range = 800,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Janna',
    spellSlot = 'R',
    range = 725,
    width = 725,
    speed = 828.5,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	}
  },
  JarvanIV = {
	Q = {
    charName = 'JarvanIV',
    spellSlot = 'Q',
    range = 700,
    width = 70,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'JarvanIV',
    spellSlot = 'W',
    range = 300,
    width = 300,
    speed = 0,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'JarvanIV',
    spellSlot = 'E',
    range = 830,
    width = 75,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'JarvanIV',
    spellSlot = 'R',
    range = 650,
    width = 325,
    speed = 0,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Jax = {
	Q = {
    charName = 'Jax',
    spellSlot = 'Q',
    range = 210,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',   --Everycast.. check this out on what to do with it.? probably disable
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Jax',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Jax',
    spellSlot = 'E',
    range = 425,
    width = 425,
    speed = 1450,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Jax',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Jayce = {
	Q1 = { --Start with hammer form
    charName = 'Jayce',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W1 = {
    charName = 'Jayce',
    spellSlot = 'W',
    range = 285,
    width = 285,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E1 = {
    charName = 'Jayce',
    spellSlot = 'E',
    range = 300,
    width = 80,
    speed = math.huge,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R1 = {
    charName = 'Jayce',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.75,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	Q2 = {
    charName = 'Jayce',
    spellSlot = 'QM',
    range = 1050,
    width = 80,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W2 = {
    charName = 'Jayce',
    spellSlot = 'WM',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.75,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E2 = {
    charName = 'Jayce',
    spellSlot = 'EM',
    range = 685,
    width = 0,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R2 = {
    charName = 'Jayce',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.75,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Jinx = {
	Q = {
    charName = 'Jinx',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Jinx',
    spellSlot = 'W',
    range = 1550,
    width = 70,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Jinx',
    spellSlot = 'E',
    range = 900,
    width = 550,
    speed = 1000,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Jinx',
    spellSlot = 'R',
    range = 25000,
    width = 120,
    speed = math.huge,
    delay = 0,
    spellType = 'skillshot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Karthus = {
	Q = {
    charName = 'Karthus',
    spellSlot = 'Q',
    range = 875,
    width = 160,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Karthus',
    spellSlot = 'W',
    range = 1090,
    width = 525,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Karthus',
    spellSlot = 'E',
    range = 550,
    width = 550,
    speed = 1000,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Karthus',
    spellSlot = 'R',
    range = 20000,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 2200
	}
  },
  Karma = {
	Q = {
    charName = 'Karma',
    spellSlot = 'Q',
    range = 950,
    width = 90,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Karma',
    spellSlot = 'W',
    range = 700,
    width = 60,
    speed = 2000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Karma',
    spellSlot = 'E',
    range = 800,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Karma',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 1300,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Kassadin = {
	Q = {
    charName = 'Kassadin',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = trueww,
    hitLineCheck = false
	},
	W = {
    charName = 'Kassadin',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Kassadin',
    spellSlot = 'E',
    range = 700,
    width = 10,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Kassadin',
    spellSlot = 'R',
    range = 675,
    width = 150,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Katarina = { 
	Q = {
    charName = 'Katarina',
    spellSlot = 'Q',
    range = 675,
    width = 0,
    speed = 1800,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Katarina',
    spellSlot = 'W',
    range = 400,
    width = 400,
    speed = 1800,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Katarina',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Katarina',
    spellSlot = 'R',
    range = 550,
    width = 550,
    speed = 1450,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Kayle = {
	Q = {
    charName = 'Kayle',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Kayle',
    spellSlot = 'W',
    range = 900,
    width = 0,
    speed = math.huge,
    delay = 0.22,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _W
	},
	E = {
    charName = 'Kayle',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = 779,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Kayle',
    spellSlot = 'R',
    range = 900,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Kennen = {
	Q = {
    charName = 'Kennen',
    spellSlot = 'Q',
    range = 1000,
    width = 50,
    speed = 1700,
    delay = 0.69,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Kennen',
    spellSlot = 'W',
    range = 900,
    width = 900,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Kennen',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Kennen',
    spellSlot = 'R',
    range = 550,
    width = 550,
    speed = 779,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Khazix = {			-- handle Khas Range changes...
	Q1 = {
    charName = 'Khazix',
    spellSlot = 'Q',
    range = 325,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Khazix',
    spellSlot = 'W',
    range = 1000,
    width = 60,
    speed = 828.5,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E1 = {
    charName = 'Khazix',
    spellSlot = 'E',
    range = 600,
    width = 300,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Khazix',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	Q2 = {
    charName = 'Khazix',
    spellSlot = 'Q',
    range = 375,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E2 = {
    charName = 'Khazix',
    spellSlot = 'E',
    range = 900,
    width = 300,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  KogMaw = {
	Q = {
    charName = 'KogMaw',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'KogMaw',
    spellSlot = 'W',
    range = 130,
    width = 0,
    speed = 2000,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'KogMaw',
    spellSlot = 'E',
    range = 1000,
    width = 120,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'KogMaw',
    spellSlot = 'R',
    range = 1400,
    width = 225,
    speed = 2000,
    delay = 0.6,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Leblanc = {     -- Possible method for getting Leblancs R range.. 
	Q = {
    charName = 'Leblanc',
    spellSlot = 'Q',
    range = 700,
    width = 0,
    speed = 2000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Leblanc',
    spellSlot = 'W',
    range = 600,
    width = 220,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Leblanc',
    spellSlot = 'E',
    range = 925,
    width = 70,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R1 = {
    charName = 'Leblanc',
    spellSlot = 'R',
    range = 700,
    width = 0,
    speed = 2000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R2 = {
    charName = 'Leblanc',
    spellSlot = 'R',
    range = 600,
    width = 220,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R3 = {
    charName = 'Leblanc',
    spellSlot = 'R',
    range = 925,
    width = 70,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  LeeSin = { 
	Q = {
    charName = 'LeeSin',
    spellSlot = 'Q',
    range = 1000,
    width = 60,
    speed = 1800,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'LeeSin',
    spellSlot = 'W',
    range = 700,
    width = 0,
    speed = 1500,
    delay = 0,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'LeeSin',
    spellSlot = 'E',
    range = 425,
    width = 425,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'LeeSin',
    spellSlot = 'R',
    range = 375,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Leona = {
	Q = {
    charName = 'Leona',
    spellSlot = 'Q',
    range = 215,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Leona',
    spellSlot = 'W',
    range = 500,
    width = 0,
    speed = 0,
    delay = 3,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Leona',
    spellSlot = 'E',
    range = 900,
    width = 100,
    speed = 2000,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Leona',
    spellSlot = 'R',
    range = 1200,
    width = 315,
    speed = math.huge,
    delay = 0.7,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Lissandra = {
	Q = {
    charName = 'Lissandra',
    spellSlot = 'Q',
    range = 725,
    width = 75,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Lissandra',
    spellSlot = 'W',
    range = 450,
    width = 450,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Lissandra',
    spellSlot = 'E',
    range = 1050,
    width = 110,
    speed = 850,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Lissandra',
    spellSlot = 'R',
    range = 550,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'enemyCast',    -- selfEnemyCast   Will need to fix this for option possibly. 
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 0,
    zhonyaSlot = _R
	}
  },
  Lucian = {
	Q = {
    charName = 'Lucian',
    spellSlot = 'Q',
    range = 550,
    width = 65,
    speed = 500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Lucian',
    spellSlot = 'W',
    range = 1000,
    width = 80,
    speed = 500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Lucian',
    spellSlot = 'E',
    range = 650,
    width = 50,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Lucian',
    spellSlot = 'R',
    range = 1400,
    width = 60,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Lulu = { 
	Q = {
    charName = 'Lulu',
    spellSlot = 'Q',
    range = 925,
    width = 80,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Lulu',
    spellSlot = 'W',
    range = 650,
    width = 0,
    speed = 2000,
    delay = 0.64,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Lulu',
    spellSlot = 'E',
    range = 650,
    width = 0,
    speed = math.huge,
    delay = 0.64,
    spellType = 'everyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Lulu',
    spellSlot = 'R',
    range = 900,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Lux = {
	Q = {
    charName = 'Lux',
    spellSlot = 'Q',
    range = 1300,
    width = 80,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Lux',
    spellSlot = 'W',
    range = 1075,
    width = 150,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Lux',
    spellSlot = 'E',
    range = 1100,
    width = 275,
    speed = 1300,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Lux',
    spellSlot = 'R',
    range = 3340,
    width = 190,
    speed = 3000,
    delay = 1.75,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Malphite = {
	Q = {
    charName = 'Malphite',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Malphite',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Malphite',
    spellSlot = 'E',
    range = 400,
    width = 400,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Malphite',
    spellSlot = 'R',
    range = 1000,
    width = 270,
    speed = 700,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 0
	}
  },
  Malzahar = {
	Q = {
    charName = 'Malzahar',
    spellSlot = 'Q',
    range = 900,
    width = 110,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Malzahar',
    spellSlot = 'W',
    range = 800,
    width = 250,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Malzahar',
    spellSlot = 'E',
    range = 650,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Malzahar',
    spellSlot = 'R',
    range = 700,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Maokai = {
	Q = {
    charName = 'Maokai',
    spellSlot = 'Q',
    range = 600,
    width = 110,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Maokai',
    spellSlot = 'W',
    range = 650,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Maokai',
    spellSlot = 'E',
    range = 1100,
    width = 250,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Maokai',
    spellSlot = 'R',
    range = 625,
    width = 575,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  MasterYi = {
	Q = {
    charName = 'MasterYi',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 4000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'MasterYi',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'MasterYi',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.23,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'MasterYi',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.37,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    slowSlot = _R
	}
  },
  MissFortune = {
	Q = {
    charName = 'MissFortune',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'MissFortune',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'MissFortune',
    spellSlot = 'E',
    range = 1000,
    width = 400,
    speed = 500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'MissFortune',
    spellSlot = 'R',
    range = 1400,
    width = 100,
    speed = 775,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = false,
    hitLineCheck = true
	}
  },
  Mordekaiser = {
	Q = {
    charName = 'Mordekaiser',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Mordekaiser',
    spellSlot = 'W',
    range = 750,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Mordekaiser',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Mordekaiser',
    spellSlot = 'R',
    range = 850,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Morgana = {
	Q = {
    charName = 'Morgana',
    spellSlot = 'Q',
    range = 1300,
    width = 110,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Morgana',
    spellSlot = 'W',
    range = 1075,
    width = 350,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Morgana',
    spellSlot = 'E',
    range = 750,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Morgana',
    spellSlot = 'R',
    range = 600,
    width = 600,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true,
    timer = 2800
	}
  },
  Nami = { 
	Q = {
    charName = 'Nami',
    spellSlot = 'Q',
    range = 875,
    width = 200,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Nami',
    spellSlot = 'W',
    range = 725,
    width = 0,
    speed = 1100,
    delay = 0.5,
    spellType = 'everyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    healSlot = _W
	},
	E = {
    charName = 'Nami',
    spellSlot = 'E',
    range = 800,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Nami',
    spellSlot = 'R',
    range = 2550,
    width = 600,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Nasus = {
	Q = {
    charName = 'Nasus',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Nasus',
    spellSlot = 'W',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Nasus',
    spellSlot = 'E',
    range = 850,
    width = 400,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Nasus',
    spellSlot = 'R',
    range = 1,
    width = 350,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Nautilus = {
	Q = {
    charName = 'Nautilus',
    spellSlot = 'Q',
    range = 950,
    width = 80,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Nautilus',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Nautilus',
    spellSlot = 'E',
    range = 600,
    width = 600,
    speed = 1300,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Nautilus',
    spellSlot = 'R',
    range = 1500,
    width = 60,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 450 - GetLatency()
	}
  },
  Nidalee = { 							--    Deal with nidalles forms
	Q1 = {
    charName = 'Nidalee',
    spellSlot = 'Q',
    range = 1500,
    width = 60,
    speed = 1300,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W1 = {
    charName = 'Nidalee',
    spellSlot = 'W',
    range = 900,
    width = 125,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E1 = {
    charName = 'Nidalee',
    spellSlot = 'E',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _E
	},
	R = {    -- Only 1 R
    charName = 'Nidalee',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	Q2 = {
    charName = 'Nidalee',
    spellSlot = 'QM',
    range = 50,
    width = 0,
    speed = 500,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W2 = {
    charName = 'Nidalee',
    spellSlot = 'WM',
    range = 375,
    width = 150,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E2 = {
    charName = 'Nidalee',
    spellSlot = 'EM',
    range = 300,
    width = 300,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Nocturne = {
	Q = {
    charName = 'Nocturne',
    spellSlot = 'Q',
    range = 1125,
    width = 60,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Nocturne',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Nocturne',
    spellSlot = 'E',
    range = 500,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	R = {          --Requires hitting button 2 times. 
    charName = 'Nocturne',
    spellSlot = 'R',
    range = 2000,
    width = 0,
    speed = 500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Nunu = {
	Q = {
    charName = 'Nunu',
    spellSlot = 'Q',
    range = 125,
    width = 60,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Nunu',
    spellSlot = 'W',
    range = 700,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Nunu',
    spellSlot = 'E',
    range = 550,
    width = 0,
    speed = 1000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Nunu',
    spellSlot = 'R',
    range = 650,
    width = 650,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Olaf = {
	Q = {
    charName = 'Olaf',
    spellSlot = 'Q',
    range = 1000,
    width = 90,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Olaf',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Olaf',
    spellSlot = 'E',
    range = 325,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Olaf',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    qssSlot = _R
	}
  },
  Oriana = {
	Q = {
    charName = 'Orianna',
    spellSlot = 'Q',
    range = 1100,
    width = 145,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Orianna',
    spellSlot = 'W',
    range = 0,
    width = 260,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Orianna',
    spellSlot = 'E',
    range = 1095,
    width = 145,
    speed = 1200,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Orianna',
    spellSlot = 'R',
    range = 0,
    width = 425,
    speed = 1200,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Pantheon = { 
	Q = {
    charName = 'Pantheon',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Pantheon',
    spellSlot = 'W',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Pantheon',
    spellSlot = 'E',
    range = 600,
    width = 100,
    speed = 775,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Pantheon',
    spellSlot = 'R',
    range = 5500,
    width = 1000,
    speed = 3000,
    delay = 1,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Poppy = {
	Q = {
    charName = 'Poppy',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Poppy',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Poppy',
    spellSlot = 'E',
    range = 525,
    width = 0,
    speed = 1450,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Poppy',
    spellSlot = 'R',
    range = 900,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Quinn = { 
	Q = {
    charName = 'Quinn',
    spellSlot = 'Q',
    range = 1025,
    width = 80,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Quinn',
    spellSlot = 'W',
    range = 2100,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Quinn',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 775,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Quinn',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Rammus = {
	Q = {
    charName = 'Rammus',
    spellSlot = 'Q',
    range = 0,
    width = 200,
    speed = 775,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Rammus',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    aaShieldSlot = _W
	},
	E = {
    charName = 'Rammus',
    spellSlot = 'E',
    range = 325,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Rammus',
    spellSlot = 'R',
    range = 300,
    width = 300,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Renekton = {
	Q = {
    charName = 'Renekton',
    spellSlot = 'Q',
    range = 1,
    width = 450,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Renekton',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Renekton',
    spellSlot = 'E',
    range = 450,
    width = 50,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Renekton',
    spellSlot = 'R',
    range = 1,
    width = 530,
    speed = 775,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Rengar = { 
	Q = {
    charName = 'Rengar',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Rengar',
    spellSlot = 'W',
    range = 1,
    width = 500,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Rengar',
    spellSlot = 'E',
    range = 1000,
    width = 70,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Rengar',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Riven = {
	Q = {
    charName = 'Riven',
    spellSlot = 'Q',
    range = 250,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Riven',
    spellSlot = 'W',
    range = 260,
    width = 260,
    speed = 1500,
    delay = 0.25,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Riven',
    spellSlot = 'E',
    range = 325,
    width = 0,
    speed = 1450,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Riven',
    spellSlot = 'R',
    range = 900,
    width = 200,
    speed = 1450,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	}
  },
  Rumble = {
	Q = {
    charName = 'Rumble',
    spellSlot = 'Q',
    range = 600,
    width = 10,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Rumble',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Rumble',
    spellSlot = 'E',
    range = 850,
    width = 90,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = { 					-- check if this works... not sure how to cast it. 
    charName = 'Rumble',
    spellSlot = 'R',
    range = 1700,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Ryze = {
	Q = {
    charName = 'Ryze',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',	
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Ryze',
    spellSlot = 'W',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Ryze',
    spellSlot = 'E',
    range = 600,
    width = 0,
    speed = 1000,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Ryze',
    spellSlot = 'R',
    range = 625,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Sejuani = {
	Q = {
    charName = 'Sejuani',
    spellSlot = 'Q',
    range = 650,
    width = 75,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Sejuani',
    spellSlot = 'W',
    range = 1,
    width = 350,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Sejuani',
    spellSlot = 'E',
    range = 1,
    width = 1000,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Sejuani',
    spellSlot = 'R',
    range = 1175,
    width = 110,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Shaco = {
	Q = {
    charName = 'Shaco',
    spellSlot = 'Q',
    range = 400,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Shaco',
    spellSlot = 'W',
    range = 425,
    width = 60,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Shaco',
    spellSlot = 'E',
    range = 625,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Shaco',
    spellSlot = 'R',
    range = 1125,
    width = 250,
    speed = 395,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Shen = {
	Q = {
    charName = 'Shen',
    spellSlot = 'Q',
    range = 475,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Shen',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Shen',
    spellSlot = 'E',
    range = 600,
    width = 50,
    speed = 1000,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Shen',
    spellSlot = 'R',
    range = 25000,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Shyvana = {    --MIGHT ADD E FOR DRAG FORM(NO CAN BLOCK)
	Q = {
    charName = 'Shyvana',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Shyvana',
    spellSlot = 'W',
    range = 0,
    width = 325,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Shyvana',
    spellSlot = 'E',
    range = 925,
    width = 60,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Shyvana',
    spellSlot = 'R',
    range = 1000,
    width = 160,
    speed = 700,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = true
	}
  },
  Singed = {
	Q = {
    charName = 'Singed',
    spellSlot = 'Q',
    range = 0,
    width = 400,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Singed',
    spellSlot = 'W',
    range = 1175,
    width = 350,
    speed = 700,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Singed',
    spellSlot = 'E',
    range = 125,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Singed',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Sion = {
	Q = {
    charName = 'Sion',
    spellSlot = 'Q',
    range = 550,
    width = 0,
    speed = 1600,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Sion',
    spellSlot = 'W',
    range = 550,
    width = 550,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Sion',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Sion',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = 500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Sivir = {
	Q = {
    charName = 'Sivir',
    spellSlot = 'Q',
    range = 1165,
    width = 90,
    speed = 1350,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Sivir',
    spellSlot = 'W',
    range = 565,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Sivir',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _E
	},
	R = {
    charName = 'Sivir',
    spellSlot = 'R',
    range = 1000,
    width = 1000,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Skarner = {
	Q = {
    charName = 'Skarner',
    spellSlot = 'Q',
    range = 350,
    width = 350,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Skarner',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Skarner',
    spellSlot = 'E',
    range = 1000,
    width = 60,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Skarner',
    spellSlot = 'R',
    range = 350,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Sona = {
	Q = {
    charName = 'Sona',
    spellSlot = 'Q',
    range = 700,
    width = 700,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Sona',
    spellSlot = 'W',
    range = 1000,
    width = 1000,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _W
	},
	E = {
    charName = 'Sona',
    spellSlot = 'E',
    range = 1000,
    width = 1000,
    speed = 1500,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Sona',
    spellSlot = 'R',
    range = 900,
    width = 125,
    speed = 2400,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true,
    timer = 0
	}
  },
  Soraka = {
	Q = {
    charName = 'Soraka',
    spellSlot = 'Q',
    range = 675,
    width = 675,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Soraka',
    spellSlot = 'W',
    range = 750,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _W
	},
	E = {
    charName = 'Soraka',
    spellSlot = 'E',
    range = 725,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'everyCast',
    riskLevel = 'dangerous',
    cc = false,
    hitLineCheck = false,
    claritySlot = _E
	},
	R = {
    charName = 'Soraka',
    spellSlot = 'R',
    range = 25000,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Swain = {
	Q = {
    charName = 'Swain',
    spellSlot = 'Q',
    range = 625,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Swain',
    spellSlot = 'W',
    range = 1040,
    width = 275,
    speed = 1250,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Swain',
    spellSlot = 'E',
    range = 625,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Swain',
    spellSlot = 'R',
    range = 700,
    width = 700,
    speed = 950,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Syndra = {
	Q = {
    charName = 'Syndra',
    spellSlot = 'Q',
    range = 800,
    width = 200,
    speed = 1750,
    delay = 0.25,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Syndra',
    spellSlot = 'W',
    range = 925,
    width = 200,
    speed = 1450,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Syndra',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Syndra',
    spellSlot = 'R',
    range = 675,
    width = 0,
    speed = 1100,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Talon = {
	Q = {
    charName = 'Talon',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Talon',
    spellSlot = 'W',
    range = 750,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	E = {
    charName = 'Talon',
    spellSlot = 'E',
    range = 750,
    width = 0,
    speed = 1200,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Talon',
    spellSlot = 'R',
    range = 750,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Taric = {
	Q = {
    charName = 'Taric',
    spellSlot = 'Q',
    range = 750,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    healSlot = _Q
	},
	W = {
    charName = 'Taric',
    spellSlot = 'W',
    range = 400,
    width = 200,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Taric',
    spellSlot = 'E',
    range = 625,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Taric',
    spellSlot = 'R',
    range = 400,
    width = 200,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Teemo = {
	Q = {
    charName = 'Teemo',
    spellSlot = 'Q',
    range = 580,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Teemo',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 943,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Teemo',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {            --Might have to add something for shrooms.. so it doesnt walk over and try to put it on someone.  
    charName = 'Teemo',
    spellSlot = 'R',
    range = 230,
    width = 0,
    speed = 1500,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	}
  },
  Thresh = { 
	Q = {
    charName = 'Thresh',
    spellSlot = 'Q',
    range = 1175,
    width = 60,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Thresh',
    spellSlot = 'W',
    range = 950,
    width = 315,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Thresh',
    spellSlot = 'E',
    range = 515,
    width = 160,
    speed = math.huge,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Thresh',
    spellSlot = 'R',
    range = 420,
    width = 420,
    speed = math.huge,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Tristana = {
	Q = {
    charName = 'Tristana',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Tristana',
    spellSlot = 'W',
    range = 900,
    width = 270,
    speed = 1150,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Tristana',
    spellSlot = 'E',
    range = 625,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Tristana',
    spellSlot = 'R',
    range = 700,
    width = 0,
    speed = 1600,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Trundle = {
	Q = {
    charName = 'Trundle',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	W = {
    charName = 'Trundle',
    spellSlot = 'W',
    range = 0,
    width = 900,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Trundle',
    spellSlot = 'E',
    range = 1100,
    width = 188,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Trundle',
    spellSlot = 'R',
    range = 700,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
	Tryndamere = {
	Q = {
    charName = 'Tryndamere',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Tryndamere',
    spellSlot = 'W',
    range = 400,
    width = 400,
    speed = 500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Tryndamere',
    spellSlot = 'E',
    range = 660,
    width = 225,
    speed = 700,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Tryndamere',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  TwistedFate = {
	Q = {
    charName = 'TwistedFate',
    spellSlot = 'Q',
    range = 1450,
    width = 80,
    speed = 1450,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'TwistedFate',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'TwistedFate',
    spellSlot = 'W',
    range = 600,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'TwistedFate',
    spellSlot = 'E',
    range = 525,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'TwistedFate',
    spellSlot = 'R',
    range = 5500,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Twitch = {
	Q = {
    charName = 'Twich',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Twich',
    spellSlot = 'W',
    range = 800,
    width = 275,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Twich',
    spellSlot = 'E',
    range = 1200,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Twich',
    spellSlot = 'R',
    range = 850,
    width = 0,
    speed = 500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Udyr = {
	Q = {
    charName = 'Udyr',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Udyr',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Udyr',
    spellSlot = 'E',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Udyr',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Urgot = {                   -- Might need to customiz for Q if E is on them... becase it adds 200 more range
	Q = {
    charName = 'Urgot',
    spellSlot = 'Q',
    range = 1000,
    width = 80,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Urgot',
    spellSlot = 'W',
    range = 0,
    width = 300,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    shieldSlot = _W
	},
	E = {
    charName = 'Urgot',
    spellSlot = 'E',
    range = 950,
    width = 150,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Urgot',
    spellSlot = 'R',
    range = 850,
    width = 0,
    speed = 1800,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	}
  },
  Varus = { 
	Q = {
    charName = 'Varus',
    spellSlot = 'Q',
    range = 1500,
    width = 100,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Varus',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Varus',
    spellSlot = 'E',
    range = 925,
    width = 55,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Varus',
    spellSlot = 'R',
    range = 1300,
    width = 80,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Vayne = {
	Q = {
    charName = 'Vayne',
    spellSlot = 'Q',
    range = 250,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Vayne',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Vayne',
    spellSlot = 'E',
    range = 450,
    width = 0,
    speed = 1200,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Vayne',
    spellSlot = 'R',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Veigar = {
	Q = {
    charName = 'Veigar',
    spellSlot = 'Q',
    range = 650,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Veigar',
    spellSlot = 'W',
    range = 900,
    width = 240,
    speed = 1500,
    delay = 1.2,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Veigar',
    spellSlot = 'E',
    range = 650,
    width = 350,
    speed = 1500,
    delay = math.huge,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Veigar',
    spellSlot = 'R',
    range = 650,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 230 - GetLatency()
	}
  },
  Velkoz = { 
	Q = {
    charName = 'Velkoz',
    spellSlot = 'Q',
    range = 1050,
    width = 60,
    speed = 1200,
    delay = 0.3,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Velkoz',
    spellSlot = 'W',
    range = 1050,
    width = 90,
    speed = 1200,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	E = {
    charName = 'Velkoz',
    spellSlot = 'E',
    range = 850,
    width = 0,
    speed = 500,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Velkoz',
    spellSlot = 'R',
    range = 1575,
    width = 0,
    speed = 1500,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	}
  },
  Vi = { 
	Q = {
    charName = 'Vi',
    spellSlot = 'Q',
    range = 800,
    width = 55,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Vi',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Vi',
    spellSlot = 'E',
    range = 600,
    width = 0,
    speed = 0,
    delay = 0,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Vi',
    spellSlot = 'R',
    range = 800,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false,
    timer = 230 - GetLatency()
	}
  },
  Viktor = {
	Q = {
    charName = 'Viktor',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Viktor',
    spellSlot = 'W',
    range = 815,
    width = 300,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	E = {                       -- figure out best method to do this skillshot
    charName = 'Viktor',
    spellSlot = 'E',
    range = 700,
    width = 90,
    speed = 1210,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	R = {
    charName = 'Viktor',
    spellSlot = 'R',
    range = 700,
    width = 250,
    speed = 1210,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Vladimir = {
	Q = {
    charName = 'Vladimir',
    spellSlot = 'Q',
    range = 600,
    width = 0,
    speed = 1400,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Vladimir',
    spellSlot = 'W',
    range = 350,
    width = 350,
    speed = 1600,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Vladimir',
    spellSlot = 'E',
    range = 610,
    width = 610,
    speed = 1100,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Vladimir',
    spellSlot = 'R',
    range = 875,
    width = 375,
    speed = 1200,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Volibear = { 
	Q = {
    charName = 'Volibear',
    spellSlot = 'Q',
    range = 300,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Volibear',
    spellSlot = 'W',
    range = 400,
    width = 0,
    speed = 1450,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Volibear',
    spellSlot = 'E',
    range = 425,
    width = 425,
    speed = 825,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Volibear',
    spellSlot = 'R',
    range = 425,
    width = 425,
    speed = 825,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	}
  },
  Warwick = {
	Q = {
    charName = 'Warwick',
    spellSlot = 'Q',
    range = 400,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Warwick',
    spellSlot = 'W',
    range = 1000,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Warwick',
    spellSlot = 'E',
    range = 1500,
    width = 0,
    speed = math.huge,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Warwick',
    spellSlot = 'R',
    range = 700,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  MonkeyKing = {
	Q = {
    charName = 'MonkeyKing',
    spellSlot = 'Q',
    range = 300,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'MonkeyKing',
    spellSlot = 'W',
    range = 0,
    width = 175,
    speed = 0,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'MonkeyKing',
    spellSlot = 'E',
    range = 625,
    width = 0,
    speed = 2200,
    delay = 0,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'MonkeyKing',
    spellSlot = 'R',
    range = 315,
    width = 315,
    speed = 700,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Xerath = {                      --Only selects champ in 750 range... maybe try something to fix.. 
	Q = {
    charName = 'Xerath',
    spellSlot = 'Q',
    range = 750,
    width = 100,
    speed = 500,
    delay = 0.75,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Xerath',
    spellSlot = 'W',
    range = 1100,
    width = 200,
    speed = 20,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Xerath',
    spellSlot = 'E',
    range = 1050,
    width = 70,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Xerath',
    spellSlot = 'R',
    range = 5600,
    width = 200,
    speed = 500,
    delay = 0.75,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Xinzhao = {
	Q = {
    charName = 'XinZhao',
    spellSlot = 'Q',
    range = 200,
    width = 0,
    speed = 2000,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'XinZhao',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = 2000,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'XinZhao',
    spellSlot = 'E',
    range = 600,
    width = 120,
    speed = 1750,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'XinZhao',
    spellSlot = 'R',
    range = 375,
    width = 375,
    speed = 1750,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Yasuo = {    
	Q1 = {			-- might require differ for normal q vs q with knockup
    charName = 'Yasuo',
    spellSlot = 'Q',
    range = 475,
    width = 55,
    speed = 1500,
    delay = 0.75,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	Q2 = {
    charName = 'Yasuo',
    spellSlot = 'Q',
    range = 1000,
    width = 90,
    speed = 1500,
    delay = 0.75,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	W1 = {
    charName = 'Yasuo',
    spellSlot = 'W',
    range = 400,
    width = 0,
    speed = 500,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Yasuo',
    spellSlot = 'E',
    range = 475,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	R = {
    charName = 'Yasuo',
    spellSlot = 'R',
    range = 1200,
    width = 0,
    speed = 20,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	}
  },
  Yorick = {
	Q = {
    charName = 'Yorick',
    spellSlot = 'Q',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Yorick',
    spellSlot = 'W',
    range = 600,
    width = 200,
    speed = math.huge,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Yorick',
    spellSlot = 'E',
    range = 550,
    width = 200,
    speed = math.huge,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Yorick',
    spellSlot = 'R',
    range = 900,
    width = 0,
    speed = 1500,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Zac = {
	Q = {
    charName = 'Zac',
    spellSlot = 'Q',
    range = 550,
    width = 120,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = true
	},
	W = {
    charName = 'Zac',
    spellSlot = 'W',
    range = 350,
    width = 350,
    speed = 1600,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Zac',
    spellSlot = 'E',
    range = 1550,
    width = 250,
    speed = 1500,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Zac',
    spellSlot = 'R',
    range = 850,
    width = 300,
    speed = 1800,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  },
  Zed = {
	Q = {
    charName = 'Zed',
    spellSlot = 'Q',
    range = 900,
    width = 45,
    speed = 902,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Zed',
    spellSlot = 'W',
    range = 550,
    width = 40,
    speed = 1600,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Zed',
    spellSlot = 'E',
    range = 300,
    width = 300,
    speed = 0,
    delay = 0,
    spellType = 'selfCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Zed',
    spellSlot = 'R',
    range = 850,
    width = 0,
    speed = 0,
    delay = 0.5,
    spellType = 'enemyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 2600
	}
  },
  Ziggs = { 
	Q = {
    charName = 'Ziggs',
    spellSlot = 'Q',
    range = 850,
    width = 75,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = true
	},
	W = {
    charName = 'Ziggs',
    spellSlot = 'W',
    range = 850,
    width = 300,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = true,
    hitLineCheck = false
	},
	E = {
    charName = 'Ziggs',
    spellSlot = 'E',
    range = 850,
    width = 350,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	},
	R = {
    charName = 'Ziggs',
    spellSlot = 'R',
    range = 850,
    width = 600,
    speed = 1750,
    delay = 0.5,
    spellType = 'skillShot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 950 - GetLatency()
	}
  },
  Zilean = {
	Q = {
    charName = 'Zilean',
    spellSlot = 'Q',
    range = 700,
    width = 0,
    speed = 1100,
    delay = 0,
    spellType = 'everyCast',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false,
    timer = 3000
	},
	W = {
    charName = 'Zilean',
    spellSlot = 'W',
    range = 0,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'selfCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Zilean',
    spellSlot = 'E',
    range = 700,
    width = 0,
    speed = 1100,
    delay = 0.5,
    spellType = 'everyCast',
    riskLevel = 'dangerous',
    cc = true,
    hitLineCheck = false,
    exhaustSlot = _E
	},
	R = {
    charName = 'Zilean',
    spellSlot = 'R',
    range = 780,
    width = 0,
    speed = math.huge,
    delay = 0.5,
    spellType = 'allyCast',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false,
    ultSlot = _R
	}
  },
  Zyra = {
	Q = {
    charName = 'Zyra',
    spellSlot = 'Q',
    range = 800,
    width = 240,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'kill',
    cc = false,
    hitLineCheck = false
	},
	W = {
    charName = 'Zyra',
    spellSlot = 'W',
    range = 800,
    width = 0,
    speed = 2200,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'noDmg',
    cc = false,
    hitLineCheck = false
	},
	E = {
    charName = 'Zyra',
    spellSlot = 'E',
    range = 1100,
    width = 70,
    speed = 1400,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = true
	},
	R = {
    charName = 'Zyra',
    spellSlot = 'R',
    range = 700,
    width = 550,
    speed = 20,
    delay = 0.5,
    spellType = 'skillshot',
    riskLevel = 'extreme',
    cc = true,
    hitLineCheck = false
	}
  }
}
------------------------------------------------------------
-------------End of Champion Information Table--------------
------------------------------------------------------------


------------------------------------------------------------  
---------------------------Menu-----------------------------
------------------------------------------------------------
Cfg, menu = uiconfig.add_menu('2. Kool Skills', 150)
--Skill Options Menu
local submenu = menu.submenu('1. Skill Options', 150)
						--Q Option
submenu.label('lbQ', '------------Q------------')
if ChampInfo[champName].Q.spellType == 'selfCast' then 
	submenu.label('lbQ1', 'SelfCast not supported yet')
elseif	ChampInfo[champName].Q.spellType == 'skillShot' then 
	submenu.label('lbQ2', 'Skillshots not supported yet')
elseif ChampInfo[champName].Q.spellType == 'allyCast' then 
	submenu.label('lbQ3', 'AllyCast are not supported yet')
elseif ChampInfo[champName].Q.spellType == 'everyCast' then 
	submenu.label('lbQ4', 'Every Cast not supported yet')
elseif ChampInfo[champName].Q.spellType == 'enemyCast' then 
	submenu.checkbutton('autoQ', 'Auto Target Q', true)
	submenu.keydown('Q', 'Q Hotkey', Keys.Q)
	qSupported = true
end
						--W Option
submenu.label('lbW', '------------W------------')
if ChampInfo[champName].W.spellType == 'selfCast' then 
	submenu.label('lbW1', 'SelfCast not supported yet')
elseif	ChampInfo[champName].W.spellType == 'skillShot' then 
	submenu.label('lbW2', 'Skillshots not supported yet')
elseif ChampInfo[champName].W.spellType == 'allyCast' then 
	submenu.label('lbW3', 'AllyCast are not supported yet')
elseif ChampInfo[champName].W.spellType == 'everyCast' then 
	submenu.label('lbW4', 'Every Cast not supported yet')
elseif ChampInfo[champName].W.spellType == 'enemyCast' then 
	submenu.checkbutton('autoW', 'Auto Target W', true)
	submenu.keydown('W', 'W Hotkey', Keys.W)
	wSupported = true
end
						--E Option
submenu.label('lbE', '-------------E-------------')
if ChampInfo[champName].E.spellType == 'selfCast' then 
	submenu.label('lbE1', 'SelfCast not supported yet')
elseif	ChampInfo[champName].E.spellType == 'skillShot' then 
	submenu.label('lbE2', 'Skillshots not supported yet')
elseif ChampInfo[champName].E.spellType == 'allyCast' then 
	submenu.label('lbE3', 'AllyCast are not supported yet')
elseif ChampInfo[champName].E.spellType == 'everyCast' then 
	submenu.label('lbE4', 'Every Cast not supported yet')
elseif ChampInfo[champName].E.spellType == 'enemyCast' then 
	submenu.checkbutton('autoE', 'Auto Target E', true)
	submenu.keydown('E', 'E Hotkey', Keys.E)
	eSupported = true
end
						--R Option
submenu.label('lbR', '-------------R------------')
if ChampInfo[champName].R.spellType == 'selfCast' then 
	submenu.label('lbR1', 'SelfCast not supported yet')
elseif	ChampInfo[champName].R.spellType == 'skillShot' then 
	submenu.label('lbR2', 'Skillshots not supported yet')
elseif ChampInfo[champName].R.spellType == 'allyCast' then 
	submenu.label('lbR3', 'AllyCast are not supported yet')
elseif ChampInfo[champName].R.spellType == 'everyCast' then 
	submenu.label('lbR4', 'Every Cast not supported yet')
elseif ChampInfo[champName].R.spellType == 'enemyCast' then 
	submenu.checkbutton('autoR', 'Auto Target R', true)
	submenu.keydown('R', 'R Hotkey', Keys.R)
	rSupported = true
end

--Target Selector Menu
local submenu = menu.submenu('2. Target Selector', 250)
submenu.keytoggle('TS_ON', 'Use Target Selector', Keys.Z ,true)
submenu.keydown('TS', 'Target Selector', 0x01)
submenu.slider('dmgType', 'Damage Type', 1, 2, 1, {'Physical', 'Magic'})
submenu.permashow('TS_ON')
------------------------------------------------------------  
------------------------End Of Menu-------------------------
------------------------------------------------------------


------------------------------------------------------------  
-----------------------Main Function-------------------------
------------------------------------------------------------
function Main()
   TargetSelector()
 --  print(champName)
	if target ~= nil then
		 if qSupported and Cfg['1. Skill Options'].autoQ and Cfg['1. Skill Options'].Q and GetDistance(target, myHero) <= QInfo.range then
			CastSpellTarget('Q', target)
		 end
		 if wSupported and Cfg['1. Skill Options'].autoW and Cfg['1. Skill Options'].W and GetDistance(target, myHero) <= WInfo.range then
			CastSpellTarget('W', target)
		 end
		 if eSupported and Cfg['1. Skill Options'].autoE and Cfg['1. Skill Options'].E and GetDistance(target, myHero) <= EInfo.range then
			CastSpellTarget('E', target)
		 end
		 if rSupported and Cfg['1. Skill Options'].autoR and Cfg['1. Skill Options'].R and GetDistance(target, myHero) <= RInfo.range then
			CastSpellTarget('R', target)
		 end
	 end
end 
------------------------------------------------------------  
--------------------End Of Main Function--------------------
------------------------------------------------------------


------------------------------------------------------------  
--------------------Get Skill Information-------------------
------------------------------------------------------------
function GetSkillInfo()
QInfo.range = ChampInfo[champName].Q.range
QInfo.width = ChampInfo[champName].Q.width
QInfo.speed = ChampInfo[champName].Q.speed
QInfo.delay = ChampInfo[champName].Q.delay
--QInfo.dmgType = ChampInfo[champName].Q.dmgType   Not yet implemented
WInfo.range = ChampInfo[champName].W.range
WInfo.width = ChampInfo[champName].W.width
WInfo.speed = ChampInfo[champName].W.speed
WInfo.delay = ChampInfo[champName].W.delay
--WInfo.dmgType = ChampInfo[champName].W.range   Not yet implemented
EInfo.range = ChampInfo[champName].E.range
EInfo.width = ChampInfo[champName].E.width
EInfo.speed = ChampInfo[champName].E.speed
EInfo.delay = ChampInfo[champName].E.delay
--EInfo.dmgType = ChampInfo[champName].E.range   Not yet implemented
RInfo.range = ChampInfo[champName].R.range
RInfo.width = ChampInfo[champName].R.width
RInfo.speed = ChampInfo[champName].R.speed
RInfo.delay = ChampInfo[champName].R.delay
--RInfo.dmgType = ChampInfo[champName].R.range   Not yet implemented
end
------------------------------------------------------------  
----------------End Of Get Skill Information----------------
------------------------------------------------------------


------------------------------------------------------------
------------------------Target Selector---------------------
------------------------------------------------------------
function TargetSelector()
	if Cfg['2. Target Selector'].TS_ON == false then
			target = nil
	else
		if target == nil then
			if Cfg['2. Target Selector'].dmgType == 1 then
				target = GetWeakEnemy('PHYS', 1200)
			elseif Cfg['2. Target Selector'].dmgType == 2 then
				target = GetWeakEnemy('MAGIC', 1200)
			end
		end
		if Cfg['2. Target Selector'].TS_ON and Cfg['2. Target Selector'].TS then
			for i = 1, objManager:GetMaxHeroes() do
				local enemy = objManager:GetHero(i)
				if enemy~=nil and enemy.team~=myHero.team and enemy.visible==1 and GetDistance(enemy,mousePos)<150 then
					target = enemy
	--				printtext('\n'..target.name.. ' - '..GetTickCount())           
				end
			end
		end
		if target~=nil then
			if target.dead==1 or myHero.dead==1 then 
				target = nil 
			else
				CustomCircle(100,10,Color.Yellow,target)
			end 
		end 
	end
end
------------------------------------------------------------
--------------------End Of Target Selector------------------
------------------------------------------------------------


GetSkillInfo()
SetTimerCallback('Main')
