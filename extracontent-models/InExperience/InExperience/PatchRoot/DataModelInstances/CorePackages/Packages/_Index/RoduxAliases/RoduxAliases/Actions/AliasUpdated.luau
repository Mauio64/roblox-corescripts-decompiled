local parent = script:FindFirstAncestor("RoduxAliases").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(userId, newAlias)
	return {
		payload = { userId = userId, newAlias = newAlias }
	}
end)
