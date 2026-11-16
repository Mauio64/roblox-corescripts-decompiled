local parent = script:FindFirstAncestor("Http").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(p, status)
	return { key = p, status = status }
end)
