local parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent

local Rodux = require(parent.Rodux)
local ArgCheck = require(parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(p)
	ArgCheck.isType(p, "table", "SetUniverseId action expects gameIds to be a table")
	return { universeId = p.universeId, placeId = p.placeId }
end)
