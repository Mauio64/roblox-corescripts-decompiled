local defineFastFlag = game:DefineFastFlag("LuaAppEnableSquadPage4", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableSquad", false)
local defineFastFlag3 = game:DefineFastFlag("SquadEnabled", false)

return function()
	return defineFastFlag3 or defineFastFlag and defineFastFlag2
end
