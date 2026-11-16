local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(retainTryOnColor: boolean?)
	return { retainTryOnColor = retainTryOnColor }
end)
