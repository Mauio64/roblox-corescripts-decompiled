local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
require(parent.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(avatarScreen, fullViewStatus)
	return { avatarScreen = avatarScreen, fullViewStatus = fullViewStatus }
end)
