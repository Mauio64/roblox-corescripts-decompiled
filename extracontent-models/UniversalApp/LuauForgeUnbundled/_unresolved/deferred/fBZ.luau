local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local navigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateDownToAvatarScreen
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagAXOpenAppItemDetailsMountAnimation = SharedFlags.FFlagAXOpenAppItemDetailsMountAnimation

return function(p2, p3, p4, p5, p6, p7)
	return function(object)
		local v5 = p3 .. p2
		local v6 = {
			itemId = p2,
			itemType = p3,
			mountAsFullView = true,
			mountAnimation = nil,
			fromProfile = nil,
			fromSurface = nil,
			itemDetailsPeekViewRefs = 0
		}
		local v7 = if fFlagAXOpenAppItemDetailsMountAnimation and p7 ~= nil then p7 else false
		v6.mountAnimation = v7

		v6.fromProfile = not fFlagAXFixPurchaseSurfaceLogging or p5
		v6.fromSurface = if fFlagAXFixPurchaseSurfaceLogging then p6 else nil
		v6.itemDetailsPeekViewRefs = {}

		object:dispatch(navigateDownToAvatarScreen(avatarScreen.ItemDetails, v5, v6))
	end
end
