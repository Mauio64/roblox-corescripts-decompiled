local parent = script:FindFirstAncestor("GameInvite").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function()
	return {}
end)
