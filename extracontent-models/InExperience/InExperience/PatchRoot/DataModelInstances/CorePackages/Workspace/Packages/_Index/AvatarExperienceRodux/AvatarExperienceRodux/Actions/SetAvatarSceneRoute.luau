local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
local ArgCheck = require(parent.ArgCheck)
require(parent.AvatarExperienceNavigation)

return Rodux.makeActionCreator(script.Name, function(avatarRoute)
	ArgCheck.isType(avatarRoute, "table", "avatarRoute")
	return { avatarRoute = avatarRoute }
end)
