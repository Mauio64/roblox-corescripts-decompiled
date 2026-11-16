local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(placeIds)
	return { placeIds = placeIds }
end)
