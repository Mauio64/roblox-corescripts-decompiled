local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local tutils = require(CorePackages.Packages.tutils)
local GenerateStringId = require(CorePackages.Workspace.Packages.AppCommonLib).GenerateStringId
local ItemTileEnums = require(CorePackages.Packages.UIBlox).Tile.ItemTileEnums
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local ModelsUtils = require(script.Parent.ModelsUtils)
local v9 = game:DefineFastFlag("FixEmptyLimitedBadgesForBundles", false)
local v10 = game:DefineFastFlag("AXFixBundleVerifiedBadgeInWidgets", false)
local v11 = game:DefineFastFlag("AXFixFreeBundlePriceText", false)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local t1 = {
	mock = function() -- line: 27
		-- upvalues: GenerateStringId (copy)
		return {
			receivedCatalogData = false,
			receivedRecommendedData = false,
			receivedFromRecommendedData = false,
			name = "",
			description = "",
			bundleType = "",
			id = "",
			items = {},
			creator = {
				name = "",
				type = "",
				hasVerifiedBadge = false,
				id = GenerateStringId()
			},
			priceInRobux = 1,
			isPublicDomain = true,
			product = {
				type = "",
				isForSale = true,
				id = GenerateStringId()
			},
			recommendedItemSummaries = {},
			favoriteCount = 0,
			priceStatus = "",
			itemRestrictions = {},
			itemStatus = {},
			lowestPrice = nil,
			numberRobloxHasAvailable = nil,
			isForRent = false,
			isOwned = false,
			isPurchasable = false,
			expectedSellerId = GenerateStringId(),
			collectibleItemId = "0",
			totalQuantity = nil,
			soldCount = 0,
			averagePrice = 0,
			originalPrice = 0,
			premiumPricing = nil
		}
	end
}

local function getBundleType(p1) -- line: 89
	-- upvalues: Constants (copy)
	if p1 == Enum.BundleType.BodyParts.Name then
		return Constants.BundleTypeIdStrings.BodyParts
	end

	if p1 == "AvatarAnimaions" then
		return Constants.BundleTypeIdStrings.Animations
	end

	if p1 == Enum.BundleType.Animations.Name then
		return Constants.BundleTypeIdStrings.Animations
	end

	if p1 == Enum.BundleType.DynamicHead.Name then
		return Constants.BundleTypeIdStrings.DynamicHead
	end

	if p1 == Enum.BundleType.Shoes.Name then
		return Constants.BundleTypeIdStrings.Shoes
	end

	return (tostring(p1))
end

function t1.fromGetRecommendedItemsDataV2(p2, p3) -- line: 110
	-- upvalues: getBundleType (copy), ModelsUtils (copy)
	local v17 = getBundleType(p2.bundleType)
	local v18 = ModelsUtils.itemDataFromBundleInfo(p2, v17, p3)

	v18.receivedFromRecommendedData = true

	return v18
end
function t1.fromHydrateWidgetInfo(p4, p5) -- line: 121
	-- upvalues: tutils (copy), v10 (copy), getBundleType (copy), v9 (copy), ItemTileEnums (copy), v11 (copy)
	local v21 = tutils.deepCopy(p5 or {})

	v21.id = tostring(p4.id)

	if p4.failedToHydrate then
		v21.failedToHydrate = true

		return v21
	end

	v21.name = p4.name

	if p4.creatorName then
		v21.creator = {
			name = p4.creatorName,
			hasVerifiedBadge = if not v10 or not p4.creator then nil else p4.creator.hasVerifiedBadge
		}
	end

	v21.bundleType = getBundleType(p4.bundleType)
	v21.priceInRobux = p4.price
	v21.receivedWidgetHydration = true

	local v22 = if not v9 then {} else nil

	if p4.isLimited or p4.isLimitedUnique or p4.isCollectible then
		v22 = {
			[ItemTileEnums.Restriction.Limited] = not not p4.isLimited,
			[ItemTileEnums.Restriction.LimitedUnique] = not not p4.isLimitedUnique,
			[ItemTileEnums.Restriction.Collectible] = not not p4.isCollectible
		}
	end

	v21.tileRestrictionsMap = v22

	if v11 then
		v21.priceStatus = p4.priceStatus
	end

	return v21
end
function t1.fromGetCatalogItemData(p6, p7) -- line: 163
	-- upvalues: ModelsUtils (copy), getBundleType (copy)
	local v25 = ModelsUtils.itemDataFromBundleInfo(p6, getBundleType(p6.bundleType), p7)

	v25.receivedCatalogData = true

	return v25
end
function t1.fromRecommendedItemSummaries(t2: {[any]: any}?, p8) -- line: 170
	-- upvalues: tutils (copy)
	local v28 = tutils.deepCopy(p8 or {})

	v28.receivedRecommendedData = true
	v28.recommendedItemSummaries = t2

	return v28
end
function t1.fromSortResults(p9, p10) -- line: 182
	-- upvalues: ModelsUtils (copy), getBundleType (copy)
	local v31 = ModelsUtils.itemDataFromBundleInfo(p9, getBundleType(p9.bundleType), p10)

	v31.receivedFromSortResults = true

	return v31
end
function t1.fromIsOwned(b1: boolean, p11) -- line: 189
	-- upvalues: tutils (copy)
	local v34 = tutils.deepCopy(p11 or {})

	v34.isOwned = b1

	return v34
end

return t1
