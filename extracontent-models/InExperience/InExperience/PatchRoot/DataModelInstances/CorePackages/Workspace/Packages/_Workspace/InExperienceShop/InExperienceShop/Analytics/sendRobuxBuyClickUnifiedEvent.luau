local parent = script:FindFirstAncestor("InExperienceShop").Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums

local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance
local FFlagAllowCustomUnifiedEventFilter = AvatarExperienceAnalytics.Flags.FFlagAllowCustomUnifiedEventFilter
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local sendPassthroughUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLogForInstance
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads

local InExperienceShopUnifiedEventFilter = require(script.Parent.InExperienceShopUnifiedEventFilter)
local getShopUnifiedLoggingSurface = require(script.Parent.getShopUnifiedLoggingSurface)

local function sendRobuxBuyClickUnifiedEvent(object, p: string?)
	local shopUnifiedLoggingSurface = getShopUnifiedLoggingSurface(p)
	local filter

	if FFlagAllowCustomUnifiedEventFilter then
		filter = InExperienceShopUnifiedEventFilter.filter
	end

	if not FFlagAXUnifiedEventStrictPayloads then
		sendUnifiedEventLogForInstance(
			object,
			{
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				surface = shopUnifiedLoggingSurface
			},
			{ includeScreenSize = true, includeElementSizeAndPosition = true, filter = filter }
		)

		return
	end

	local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
	local attributes = object:GetAttributes()

	sendPassthroughUnifiedEventLogForInstance(object, {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
		surface = shopUnifiedLoggingSurface,
		itemId = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_ID],
		itemType = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_TYPE]
	}, { includeScreenSize = true, includeElementSizeAndPosition = true, filter = filter })
end

return sendRobuxBuyClickUnifiedEvent
