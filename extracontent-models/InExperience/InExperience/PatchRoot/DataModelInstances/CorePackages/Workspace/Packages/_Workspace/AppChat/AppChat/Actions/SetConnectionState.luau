local parent = script:FindFirstAncestor("AppChat").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(connectionState)
	return { connectionState = connectionState }
end)
