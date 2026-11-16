local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator("AppChat." .. script.Name, function(p)
	return p
end)
