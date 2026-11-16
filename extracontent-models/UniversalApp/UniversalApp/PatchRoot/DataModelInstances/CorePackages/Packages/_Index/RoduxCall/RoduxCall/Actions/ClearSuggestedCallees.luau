local parent = script:FindFirstAncestor("RoduxCall").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function()
	return { payload = {} }
end)
