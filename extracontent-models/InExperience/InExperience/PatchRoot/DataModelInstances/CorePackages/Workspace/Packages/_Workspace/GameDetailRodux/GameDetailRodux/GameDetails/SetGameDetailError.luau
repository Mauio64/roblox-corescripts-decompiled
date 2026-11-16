local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(universeId, errorType, _)
	return { universeId = universeId, errorType = errorType }
end)
