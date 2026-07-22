local FFlagEnableArgus = require(script.Parent.FFlagEnableArgus)
local FFlagArgoEnableMoments = require(script.Parent.FFlagArgoEnableMoments)
local v3 = game:DefineFastFlag("SubTabAddMomentsFlagGating", false)

return game:DefineFastFlag("LuaAppIaHomeSubTab", false) or v3 and (FFlagEnableArgus and FFlagArgoEnableMoments)
