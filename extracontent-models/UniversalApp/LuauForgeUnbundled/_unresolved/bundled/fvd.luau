local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/fve")

return function(p2)
	return module(p2, { avatarScreen.ItemDetails })
end
