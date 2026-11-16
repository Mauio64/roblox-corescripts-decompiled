local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(placeInfos)
	return { placeInfos = placeInfos }
end)
