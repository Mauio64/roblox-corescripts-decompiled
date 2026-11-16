local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(selfPermissions)
	return {
		payload = { selfPermissions = selfPermissions }
	}
end)
