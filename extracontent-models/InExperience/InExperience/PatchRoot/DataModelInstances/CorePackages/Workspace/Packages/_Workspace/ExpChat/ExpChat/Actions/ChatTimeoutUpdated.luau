local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(endTimestamp: number, isEnforced: boolean)
	return { endTimestamp = endTimestamp, isEnforced = isEnforced }
end)
