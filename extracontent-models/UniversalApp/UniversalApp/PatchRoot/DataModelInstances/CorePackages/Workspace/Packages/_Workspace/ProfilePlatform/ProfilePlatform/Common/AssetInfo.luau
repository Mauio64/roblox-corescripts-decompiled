local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagSocialEnableProfileInspectAndBuy = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableBundlesInAssetsCarousel
local n1 = 0

return {
	mock = function(p1, s1: string?) -- line: 50
		-- upvalues: n1 (ref), Enums (copy)
		local t1 = {}
		local str = tostring(p1)

		if not str then
			n1 += 1
			str = tostring(n1)
		end

		t1.id = str
		t1.assetType = "0"
		t1.itemType = s1 or Enums.ItemTypes.Asset
		t1.name = ""

		return t1
	end,
	fromAsset = function(p2) -- line: 65
		-- upvalues: FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), FFlagSocialEnableProfileInspectAndBuy (copy)
		local t2 = {
			id = tostring(p2.id),
			assetType = tostring(p2.assetType or if not FFlagProfilePlatformEnableBundlesInAssetsCarousel then nil else p2.bundleType),
			itemType = p2.itemType,
			name = p2.name,
			price = p2.price,
			lowestResalePrice = p2.lowestResalePrice,
			isOffSale = p2.isOffSale,
			favoriteCount = p2.favoriteCount
		}

		if FFlagSocialEnableProfileInspectAndBuy then
			t2.creatorName = p2.creatorName
			t2.creatorHasVerifiedBadge = p2.creatorHasVerifiedBadge
			t2.collectibleItemId = p2.collectibleItemId
			t2.owned = p2.owned
			t2.bundledItems = p2.bundledItems
			t2.taxonomyName = if not p2.taxonomy or not (#p2.taxonomy > 0) then nil else p2.taxonomy[1].taxonomyName
		end

		return t2
	end
}
