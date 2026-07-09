local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local SharedFlags = require(Parent.SharedFlags)

require(Parent.AvatarExperienceNavigation)
require(Parent.AvatarExperienceCommon)

local sendUnifiedEventForDeferredAction = require(script.Parent.sendUnifiedEventForDeferredAction)
local getMarketplaceUnifiedItemType = require(script.Parent.Utils.getMarketplaceUnifiedItemType)
local getUnifiedLoggingSurface = require(script.Parent.Utils.getUnifiedLoggingSurface)
local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local FFlagAXFixClickItemDetailsSurfaceLogging = SharedFlags.FFlagAXFixClickItemDetailsSurfaceLogging

local function sendUnifiedClickItemDetailsEvent(t1: {[any]: any}) -- line: 28
	-- upvalues: sendUnifiedEventForDeferredAction (copy), UnifiedEventLogEnums (copy), getMarketplaceUnifiedItemType (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), getUnifiedLoggingSurface (copy)
	sendUnifiedEventForDeferredAction({
		elementName = "CLICK_ITEM_DETAILS",
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
		itemId = t1.itemId,
		itemType = getMarketplaceUnifiedItemType(t1.itemType),
		surface = if not FFlagAXFixClickItemDetailsSurfaceLogging then nil else getUnifiedLoggingSurface(t1.avatarRoute)
	})
end

return sendUnifiedClickItemDetailsEvent
