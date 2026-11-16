local parent = script:FindFirstAncestor("RoduxUsers").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(payload)
	return { payload = payload }
end)
