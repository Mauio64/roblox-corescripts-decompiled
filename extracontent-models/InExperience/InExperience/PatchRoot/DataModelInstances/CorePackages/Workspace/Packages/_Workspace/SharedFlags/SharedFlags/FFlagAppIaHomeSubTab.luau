local FFlagEnableArgus = require(script.Parent.FFlagEnableArgus)
local FFlagArgoEnableMoments = require(script.Parent.FFlagArgoEnableMoments)
local FFlagEnableSubTabOverride = require(script.Parent.FFlagEnableSubTabOverride)
local FFlagLuaAppIaHomeSubTab = require(script.Parent.FFlagLuaAppIaHomeSubTab)
local defineFastFlag = game:DefineFastFlag("SubTabAddMomentsFlagGating", false)

return FFlagLuaAppIaHomeSubTab
	or FFlagEnableSubTabOverride
	or defineFastFlag and FFlagEnableArgus and FFlagArgoEnableMoments
