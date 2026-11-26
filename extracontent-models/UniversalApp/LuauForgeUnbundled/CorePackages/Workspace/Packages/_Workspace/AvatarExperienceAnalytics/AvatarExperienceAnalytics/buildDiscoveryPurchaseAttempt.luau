local UnifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums")
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Loggers").mutedError
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local function buildDiscoveryPurchaseAttempt(data)
	local v5 = data.surface

	if
		v5 ~= unifiedLoggingSurface.DISCOVERY_HOMEPAGE
		and v5 ~= unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
		or data.hasWidgetAttribution
	then
		return nil
	end

	if data.itemId == nil then
		local v6 = {
			reason = "missingItemId",
			surface = tostring(v5),
			itemType = tostring(data.itemType),
			assetType = tostring(data.assetType),
			bundleType = tostring(data.bundleType),
			hasItemPrice = tostring(data.itemPrice ~= nil)
		}

		mutedError("buildDiscoveryPurchaseAttempt: dropped discovery PURCHASE_ATTEMPT with no itemId", v6)
		sendAXCounterV2("DiscoveryPurchaseAttemptDropped", v6)
		return nil
	else
		local v6 = {
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
			itemId = 0,
			itemType = 0,
			surface = 0,
			organicItemPrice = 0,
			assetType = 0,
			bundleType = 0,
			cartId = 0
		}
		local v7 = if fFlagAXUnifiedEventStrictPayloads then tostring(data.itemId) else data.itemId
		v6.itemId = v7
		v6.itemType = data.itemType

		if fFlagAXUnifiedEventStrictPayloads and not v5 then
			v5 = unifiedLoggingSurface.UNDEFINED_SURFACE
		end

		v6.surface = v5

		v6.organicItemPrice = data.itemPrice
		v6.assetType = data.assetType
		v6.bundleType = data.bundleType
		v6.cartId = data.cartId
		return v6
	end
end

return buildDiscoveryPurchaseAttempt
