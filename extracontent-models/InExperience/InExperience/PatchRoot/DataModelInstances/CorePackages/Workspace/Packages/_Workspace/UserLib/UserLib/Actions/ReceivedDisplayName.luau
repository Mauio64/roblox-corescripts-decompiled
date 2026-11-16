local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(p, displayName)
	return { userId = tostring(p), displayName = displayName }
end)
