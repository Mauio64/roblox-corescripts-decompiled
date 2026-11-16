local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local SharedFlags = require(parent.SharedFlags)
require(parent.AvatarExperienceNavigation)
require(parent.AvatarExperienceModel)

local sendUnifiedEventForDeferredAction = require(script.Parent.sendUnifiedEventForDeferredAction)
local getMarketplaceUnifiedItemType = require(script.Parent.Utils.getMarketplaceUnifiedItemType)
local getUnifiedLoggingSurface = require(script.Parent.Utils.getUnifiedLoggingSurface)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)

local FFlagAXFixClickItemDetailsSurfaceLogging = SharedFlags.FFlagAXFixClickItemDetailsSurfaceLogging

local function sendUnifiedClickItemDetailsEvent(data)
	local v = {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		elementName = "CLICK_ITEM_DETAILS",
		itemId = data.itemId,
		itemType = getMarketplaceUnifiedItemType(data.itemType),
		surface = 0
	}
	local surface

	if FFlagAXFixClickItemDetailsSurfaceLogging then
		surface = getUnifiedLoggingSurface(data.avatarRoute)
	end

	v.surface = surface
	sendUnifiedEventForDeferredAction(v)
end

return sendUnifiedClickItemDetailsEvent
