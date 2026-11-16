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

local function InExperienceShopUnifiedImpressionsReporter(p: string)
	return function(p2)
		local visibleInstance = p2.visibleInstance

		local shopUnifiedLoggingSurface = getShopUnifiedLoggingSurface(p)
		local filter

		if FFlagAllowCustomUnifiedEventFilter then
			filter = InExperienceShopUnifiedEventFilter.filter
		end

		if not FFlagAXUnifiedEventStrictPayloads then
			sendUnifiedEventLogForInstance(
				visibleInstance,
				{
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
					surface = shopUnifiedLoggingSurface
				},
				{ includeScreenSize = true, includeElementSizeAndPosition = true, filter = filter }
			)

			return
		end

		local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
		local attributes = visibleInstance:GetAttributes()

		sendPassthroughUnifiedEventLogForInstance(visibleInstance, {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = shopUnifiedLoggingSurface,
			itemId = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_ID],
			itemType = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_TYPE],
			gridPositionRow = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_GRID_POSITION_ROW],
			gridPositionColumn = attributes[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_GRID_POSITION_COLUMN]
		}, { includeScreenSize = true, includeElementSizeAndPosition = true, filter = filter })
	end
end

return InExperienceShopUnifiedImpressionsReporter
