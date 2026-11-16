local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(state: boolean)
	return { state = state }
end)
