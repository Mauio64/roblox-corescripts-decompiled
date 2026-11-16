local parent = script:FindFirstAncestor("PlayabilityRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(playabilityStatus)
	assert(type(playabilityStatus) == "table", "SetPlayabilityStatus action expects playabilityStatus to be a table")

	return { playabilityStatus = playabilityStatus }
end)
