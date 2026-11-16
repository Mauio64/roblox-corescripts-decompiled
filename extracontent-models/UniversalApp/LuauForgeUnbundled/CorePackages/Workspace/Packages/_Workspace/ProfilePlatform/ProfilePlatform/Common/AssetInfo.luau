local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuy

local fFlagProfilePlatformEnableBundlesInAssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableBundlesInAssetsCarousel
local FFlagProfileStoreShowLimitedResalePrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileStoreShowLimitedResalePrice")

local count = 0

return {
	mock = function(p2, p3)
		local v6 = tostring(p2)

		if not v6 then
			count += 1
			v6 = tostring(count)
		end

		return {
			["id"] = v6,
			assetType = "0",
			itemType = p3 or Enums.ItemTypes.Asset,
			name = ""
		}
	end,
	fromAsset = function(data)
		local v5 = {}

		v5.id = tostring(data.id)

		local v6 = data.assetType

		if not v6 then
			v6 = if fFlagProfilePlatformEnableBundlesInAssetsCarousel then data.bundleType else nil
		end

		v5.assetType = tostring(v6)
		v5.itemType = data.itemType
		v5.name = data.name
		v5.price = data.price
		v5.lowestResalePrice = data.lowestResalePrice
		v5.isOffSale = data.isOffSale
		v5.favoriteCount = data.favoriteCount

		if fFlagSocialEnableProfileInspectAndBuy then
			v5.creatorName = data.creatorName
			v5.creatorHasVerifiedBadge = data.creatorHasVerifiedBadge
			v5.collectibleItemId = data.collectibleItemId
			v5.owned = data.owned
			v5.bundledItems = data.bundledItems
			local v7 = if data.taxonomy and #data.taxonomy > 0 then data.taxonomy[1].taxonomyName else nil
			v5.taxonomyName = v7
		end

		if FFlagProfileStoreShowLimitedResalePrice then
			v5.hasResellers = data.hasResellers
			v5.unitsAvailableForConsumption = data.unitsAvailableForConsumption
			v5.itemRestrictions = data.itemRestrictions
		end

		return v5
	end
}
