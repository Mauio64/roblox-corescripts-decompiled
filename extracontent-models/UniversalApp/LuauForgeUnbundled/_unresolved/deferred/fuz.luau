local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module = require("@luauforge/bundled/dTM")

return function(p2, p3)
	return function(object)
		object:dispatch(navigateWithLock(function()
			module.closeFiltersAndItemDetails(p2)

			module.closeTryOnManager(p2)

			p2.navigate(avatarScreen.ItemDetails, p3)
		end))
	end
end
