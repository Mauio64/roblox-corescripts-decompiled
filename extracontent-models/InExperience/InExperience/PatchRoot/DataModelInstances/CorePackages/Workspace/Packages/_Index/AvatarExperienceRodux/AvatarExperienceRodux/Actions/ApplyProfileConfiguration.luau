local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(profileConfiguration)
	return { profileConfiguration = profileConfiguration }
end)
