local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local navigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateDownToAvatarScreen

return function(p2, p3)
	return function(object)
		local v5 = p3 .. p2 .. "_contextMenu"
		object:dispatch(navigateDownToAvatarScreen(avatarScreen.AppCatalogContextMenuHost, v5, {
			itemId = p2,
			itemType = p3
		}))
	end
end
