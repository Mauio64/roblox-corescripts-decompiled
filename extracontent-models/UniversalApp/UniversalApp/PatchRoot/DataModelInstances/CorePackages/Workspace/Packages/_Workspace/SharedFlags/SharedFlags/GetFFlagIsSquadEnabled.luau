local v1 = game:DefineFastFlag("LuaAppEnableSquadPage4", false)
local v2 = game:DefineFastFlag("ForceEnableSquad", false)
local v3 = game:DefineFastFlag("SquadEnabled", false)

return function() -- line: 5
	-- upvalues: v3 (copy), v1 (copy), v2 (copy)
	return v3 or v1 and v2
end
