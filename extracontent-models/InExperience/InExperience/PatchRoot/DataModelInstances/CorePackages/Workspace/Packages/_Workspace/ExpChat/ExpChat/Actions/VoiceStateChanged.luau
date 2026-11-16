local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(p, newState: string)
	return { userId = tostring(p), newState = newState }
end)
