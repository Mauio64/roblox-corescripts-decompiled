local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(p, presence, lastLocation)
	return { userId = tostring(p), presence = presence, lastLocation = lastLocation }
end)
