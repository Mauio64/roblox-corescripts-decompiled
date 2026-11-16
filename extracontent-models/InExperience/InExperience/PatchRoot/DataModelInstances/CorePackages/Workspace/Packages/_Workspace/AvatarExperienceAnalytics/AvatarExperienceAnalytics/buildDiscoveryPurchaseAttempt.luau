local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local sendAXCounterV2 = require(script.Parent.sendAXCounterV2)
require(script.Parent.Generated.UnifiedEventTypes)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function buildDiscoveryPurchaseAttempt(data)
	local surface = data.surface

	if
		surface ~= UnifiedLoggingSurface.DISCOVERY_HOMEPAGE
		and surface ~= UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
		or data.hasWidgetAttribution
	then
		return nil
	end

	if data.itemId == nil then
		local v = {
			reason = "missingItemId",
			surface = tostring(surface),
			itemType = tostring(data.itemType),
			assetType = tostring(data.assetType),
			bundleType = tostring(data.bundleType),
			hasItemPrice = tostring(data.itemPrice ~= nil)
		}

		mutedError("buildDiscoveryPurchaseAttempt: dropped discovery PURCHASE_ATTEMPT with no itemId", v)
		sendAXCounterV2("DiscoveryPurchaseAttemptDropped", v)
		return nil
	else
		local v = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
			itemId = 0,
			itemType = 0,
			surface = 0,
			organicItemPrice = 0,
			assetType = 0,
			bundleType = 0,
			cartId = 0
		}
		local itemId

		if FFlagAXUnifiedEventStrictPayloads then
			itemId = tostring(data.itemId)
		else
			itemId = data.itemId
		end

		v.itemId = itemId
		v.itemType = data.itemType

		if FFlagAXUnifiedEventStrictPayloads and not surface then
			surface = UnifiedLoggingSurface.UNDEFINED_SURFACE
		end

		v.surface = surface

		v.organicItemPrice = data.itemPrice
		v.assetType = data.assetType
		v.bundleType = data.bundleType
		v.cartId = data.cartId
		return v
	end
end

return buildDiscoveryPurchaseAttempt
