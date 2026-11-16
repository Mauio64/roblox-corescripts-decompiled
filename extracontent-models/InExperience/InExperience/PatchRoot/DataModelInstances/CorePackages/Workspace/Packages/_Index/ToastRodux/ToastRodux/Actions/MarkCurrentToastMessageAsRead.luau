local parent = script:FindFirstAncestor("ToastRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function()
	return {}
end)
