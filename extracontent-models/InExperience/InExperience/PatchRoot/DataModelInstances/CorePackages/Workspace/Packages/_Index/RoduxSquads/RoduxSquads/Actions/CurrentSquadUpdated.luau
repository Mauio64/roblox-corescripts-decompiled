local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(squad)
	return {
		payload = { squad = squad }
	}
end)
