local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = SharedFlags2.FFlagProfilePlatformEnableBundlesInAssetsCarousel
local FFlagProfileStoreShowLimitedResalePrice = require(ProfilePlatform.Flags.FFlagProfileStoreShowLimitedResalePrice)

local count = 0

local function fn() -- 1 equivalent call inferred from this helper
	count += 1
	return (tostring(count))
end

local AssetInfo = {}

function AssetInfo.mock(p, p2: string?)
	return {
		["id"] = tostring(p) or fn(), -- inferred equivalent call
		assetType = "0",
		itemType = p2 or Enums.ItemTypes.Asset,
		name = ""
	}
end

function AssetInfo.fromAsset(data)
	local v = {}

	v.id = tostring(data.id)

	local v2 = data.assetType

	if not v2 then
		if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
			v2 = data.bundleType
		else
			v2 = nil
		end
	end

	v.assetType = tostring(v2)
	v.itemType = data.itemType
	v.name = data.name
	v.price = data.price
	v.lowestResalePrice = data.lowestResalePrice
	v.isOffSale = data.isOffSale
	v.favoriteCount = data.favoriteCount

	if FFlagSocialEnableProfileInspectAndBuy then
		v.creatorName = data.creatorName
		v.creatorHasVerifiedBadge = data.creatorHasVerifiedBadge
		v.collectibleItemId = data.collectibleItemId
		v.owned = data.owned
		v.bundledItems = data.bundledItems
		local taxonomyName

		if data.taxonomy and #data.taxonomy > 0 then
			taxonomyName = data.taxonomy[1].taxonomyName
		end

		v.taxonomyName = taxonomyName
	end

	if FFlagProfileStoreShowLimitedResalePrice then
		v.hasResellers = data.hasResellers
		v.unitsAvailableForConsumption = data.unitsAvailableForConsumption
		v.itemRestrictions = data.itemRestrictions
	end

	return v
end

return AssetInfo
