local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceModel")

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventForDeferredAction")
local getMarketplaceUnifiedItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedItemType")
local getUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getUnifiedLoggingSurface")
local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")

local fFlagAXFixClickItemDetailsSurfaceLogging = SharedFlags.FFlagAXFixClickItemDetailsSurfaceLogging

local function sendUnifiedClickItemDetailsEvent(data)
	local v6 = {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "CLICK_ITEM_DETAILS",
		itemId = data.itemId,
		itemType = getMarketplaceUnifiedItemType(data.itemType),
		surface = 0
	}
	local v7 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(data.avatarRoute) else nil
	v6.surface = v7
	sendUnifiedEventForDeferredAction(v6)
end

return sendUnifiedClickItemDetailsEvent
