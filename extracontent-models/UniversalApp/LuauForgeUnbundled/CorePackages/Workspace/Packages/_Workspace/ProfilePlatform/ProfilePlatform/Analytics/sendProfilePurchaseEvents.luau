local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceAnalytics")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceNavigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceModel")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local marketplaceUnifiedAction = unifiedEventLogEnums.MarketplaceUnifiedAction
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local function sendProfilePurchaseEvents(p2, items, p3)
	local v5

	if p3 == Enums.ProfileTypes.Community then
		v5 = unifiedLoggingSurface.COMMUNITY_PROFILE
	else
		v5 = unifiedLoggingSurface.USER_PROFILE
	end

	for k, item in items do
		local v6 = item.itemType == Enums.ItemTypes.Bundle

		if fFlagAXUnifiedEventStrictPayloads then
			local v8 = {
				action = p2,
				surface = v5,
				itemId = item.itemId,
				itemType = 0,
				assetType = 0,
				bundleType = 0,
				organicItemPrice = 0
			}

			local v9 = if v6 then unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			v8.itemType = v9

			local v10 = if not v6 then item.itemSubType else nil
			v8.assetType = v10
			local v11 = if v6 then item.itemSubType else nil
			v8.bundleType = v11

			v8.organicItemPrice = item.priceInRobux
			sendPassthroughUnifiedEventLog(v8)
		else
			local v8 = {
				action = p2,
				surface = v5,
				itemId = item.itemId,
				itemType = 0,
				assetType = 0,
				bundleType = 0,
				organicItemPrice = 0
			}

			local v9 = if v6 then unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			v8.itemType = v9

			local v10 = if not v6 then item.itemSubType else nil
			v8.assetType = v10
			local v11 = if v6 then item.itemSubType else nil
			v8.bundleType = v11

			v8.organicItemPrice = item.priceInRobux
			sendUnifiedEventLog(v8)
		end
	end
end

return sendProfilePurchaseEvents
