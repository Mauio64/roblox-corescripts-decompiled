local parent = script:FindFirstAncestor("RoduxUsers").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(id)
	return {
		payload = { id = id }
	}
end)
