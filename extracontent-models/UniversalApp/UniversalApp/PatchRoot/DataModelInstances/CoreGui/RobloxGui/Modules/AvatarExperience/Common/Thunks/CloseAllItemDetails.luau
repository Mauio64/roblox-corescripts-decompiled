local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CloseMatchingScreens = require(Modules.AvatarExperience.Common.Thunks.CloseMatchingScreens)

return function(p1) -- line: 11
	-- upvalues: CloseMatchingScreens (copy), AvatarScreen (copy)
	return CloseMatchingScreens(p1, { AvatarScreen.ItemDetails })
end
