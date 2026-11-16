local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(specialFeaturesFilter)
	return { specialFeaturesFilter = specialFeaturesFilter }
end)
