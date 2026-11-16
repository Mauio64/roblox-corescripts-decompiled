local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(experienceInvite)
	return {
		payload = { experienceInvite = experienceInvite }
	}
end)
