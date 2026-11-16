local FFlagEnableArgus = require(script.Parent.FFlagEnableArgus)
local FFlagArgoEnableMoments = require(script.Parent.FFlagArgoEnableMoments)
local defineFastFlag = game:DefineFastFlag("SubTabAddMomentsFlagGating", false)

return game:DefineFastFlag("LuaAppIaHomeSubTab", false)
	or defineFastFlag and FFlagEnableArgus and FFlagArgoEnableMoments
