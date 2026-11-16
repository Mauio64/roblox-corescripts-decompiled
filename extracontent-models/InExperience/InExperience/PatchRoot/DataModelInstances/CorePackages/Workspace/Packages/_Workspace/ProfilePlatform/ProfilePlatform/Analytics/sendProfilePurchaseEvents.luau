local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
require(parent.AvatarExperienceModel)

local Enums = require(ProfilePlatform.Common.Enums)

local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local function sendProfilePurchaseEvents(action, items, p)
	local surface

	if p == Enums.ProfileTypes.Community then
		surface = UnifiedLoggingSurface.COMMUNITY_PROFILE
	else
		surface = UnifiedLoggingSurface.USER_PROFILE
	end

	for _, item in items do
		local v = item.itemType == Enums.ItemTypes.Bundle

		if FFlagAXUnifiedEventStrictPayloads then
			local v2 = {
				action = action,
				surface = surface,
				itemId = item.itemId,
				itemType = 0,
				assetType = 0,
				bundleType = 0,
				organicItemPrice = 0
			}
			local itemType

			if v then
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
			else
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			end

			v2.itemType = itemType
			local assetType

			if not v then
				assetType = item.itemSubType
			end

			v2.assetType = assetType
			local bundleType

			if v then
				bundleType = item.itemSubType
			end

			v2.bundleType = bundleType

			v2.organicItemPrice = item.priceInRobux
			sendPassthroughUnifiedEventLog(v2)
		else
			local v2 = {
				action = action,
				surface = surface,
				itemId = item.itemId,
				itemType = 0,
				assetType = 0,
				bundleType = 0,
				organicItemPrice = 0
			}
			local itemType

			if v then
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
			else
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			end

			v2.itemType = itemType
			local assetType

			if not v then
				assetType = item.itemSubType
			end

			v2.assetType = assetType
			local bundleType

			if v then
				bundleType = item.itemSubType
			end

			v2.bundleType = bundleType

			v2.organicItemPrice = item.priceInRobux
			sendUnifiedEventLog(v2)
		end
	end
end

return sendProfilePurchaseEvents
