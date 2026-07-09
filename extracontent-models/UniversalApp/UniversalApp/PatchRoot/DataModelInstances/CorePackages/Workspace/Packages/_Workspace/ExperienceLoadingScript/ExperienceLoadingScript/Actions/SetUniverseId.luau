local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local Rodux = require(Parent.Rodux)
local ArgCheck = require(Parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 7
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(p1, "table", "SetUniverseId action expects gameIds to be a table")

	return {
		universeId = p1.universeId,
		placeId = p1.placeId
	}
end)
