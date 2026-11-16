local CorePackages = game:GetService("CorePackages")
local tutils = require(CorePackages.Packages.tutils)

local generateStringId = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GenerateStringId
local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTileEnums = UIBlox.Tile.ItemTileEnums

local module = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dMc")

local module2 = require("@luauforge/bundled/dMD")

local defineFastFlag = game:DefineFastFlag("FixEmptyLimitedBadgesForBundles", false)
local defineFastFlag2 = game:DefineFastFlag("AXFixBundleVerifiedBadgeInWidgets", false)

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fFlagAXMarketplaceLicensing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMarketplaceLicensing
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo
local parseItemLicensing = AvatarExperienceCommon.Utils.parseItemLicensing

local v5 = {}

function v5.mock()
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
			id = generateStringId(),
			name = "",
			type = "",
			hasVerifiedBadge = false
		},
		priceInRobux = 1,
		isPublicDomain = true,
		product = { id = generateStringId(), type = "", isForSale = true },
		recommendedItemSummaries = {},
		favoriteCount = 0,
		priceStatus = "",
		itemRestrictions = {},
		itemStatus = {},
		["lowestPrice"] = nil,
		numberRobloxHasAvailable = nil,
		isForRent = false,
		isOwned = false,
		isPurchasable = false,
		expectedSellerId = generateStringId(),
		collectibleItemId = "0",
		totalQuantity = nil,
		soldCount = 0,
		averagePrice = 0,
		originalPrice = 0,
		premiumPricing = nil
	}
end

local function getBundleType(bundleType)
	if bundleType == Enum.BundleType.BodyParts.Name then
		return module.BundleTypeIdStrings.BodyParts
	end

	if not (bundleType ~= "AvatarAnimaions" and bundleType ~= Enum.BundleType.Animations.Name) then
		return module.BundleTypeIdStrings.Animations
	end

	if bundleType == Enum.BundleType.DynamicHead.Name then
		return module.BundleTypeIdStrings.DynamicHead
	end

	if bundleType == Enum.BundleType.Shoes.Name then
		return module.BundleTypeIdStrings.Shoes
	end

	return (tostring(bundleType))
end

local function itemDataFromBundleInfoWithLicensing(p2, p3, p4)
	local itemDataFromBundleInfo = module2.itemDataFromBundleInfo(p2, p3, p4)
	local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

	if rawItemLicensingInfo ~= nil then
		itemDataFromBundleInfo.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
	end

	return itemDataFromBundleInfo
end

function v5.fromGetRecommendedItemsDataV2(p2, p3)
	local bundleType = getBundleType(p2.bundleType)
	local v6

	if fFlagAXMarketplaceLicensing then
		v6 = module2.itemDataFromBundleInfo(p2, bundleType, p3)
		local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

		if rawItemLicensingInfo ~= nil then
			v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
		end
	else
		v6 = module2.itemDataFromBundleInfo(p2, bundleType, p3)
	end

	v6.receivedFromRecommendedData = true

	return v6
end

function v5.fromHydrateWidgetInfo(data, options)
	local copy = tutils.deepCopy(options or {})

	copy.id = tostring(data.id)

	if data.failedToHydrate then
		copy.failedToHydrate = true
		return copy
	end

	copy.name = data.name

	if data.creatorName then
		local v6 = { name = data.creatorName, hasVerifiedBadge = 0 }
		local v7 = if defineFastFlag2 and data.creator then data.creator.hasVerifiedBadge else nil
		v6.hasVerifiedBadge = v7
		copy.creator = v6
	end

	copy.bundleType = getBundleType(data.bundleType)
	copy.priceInRobux = data.price
	copy.receivedWidgetHydration = true
	local rawItemLicensingInfo = getRawItemLicensingInfo(data)

	if fFlagAXMarketplaceLicensing and rawItemLicensingInfo ~= nil then
		copy.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
	end

	local v6 = not defineFastFlag and {} or nil

	if data.isLimited or data.isLimitedUnique or data.isCollectible then
		v6 = {}
		v6[itemTileEnums.Restriction.Limited] = data.isLimited and true or false
		v6[itemTileEnums.Restriction.LimitedUnique] = data.isLimitedUnique and true or false
		v6[itemTileEnums.Restriction.Collectible] = data.isCollectible and true or false
	end

	copy.tileRestrictionsMap = v6

	copy.priceStatus = data.priceStatus

	return copy
end

function v5.fromGetCatalogItemData(p2, p3)
	local v6

	if fFlagAXMarketplaceLicensing then
		local bundleType = getBundleType(p2.bundleType)
		v6 = module2.itemDataFromBundleInfo(p2, bundleType, p3)
		local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

		if rawItemLicensingInfo ~= nil then
			v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
		end
	else
		v6 = module2.itemDataFromBundleInfo(p2, getBundleType(p2.bundleType), p3)
	end

	v6.receivedCatalogData = true
	return v6
end

function v5.fromRecommendedItemSummaries(recommendedItemSummaries, options)
	local copy = tutils.deepCopy(options or {})

	copy.receivedRecommendedData = true
	copy.recommendedItemSummaries = recommendedItemSummaries

	return copy
end

function v5.fromSortResults(p2, p3)
	local v6

	if fFlagAXMarketplaceLicensing then
		local bundleType = getBundleType(p2.bundleType)
		v6 = module2.itemDataFromBundleInfo(p2, bundleType, p3)
		local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

		if rawItemLicensingInfo ~= nil then
			v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
		end
	else
		v6 = module2.itemDataFromBundleInfo(p2, getBundleType(p2.bundleType), p3)
	end

	v6.receivedFromSortResults = true
	return v6
end

function v5.fromIsOwned(isOwned, options)
	local copy = tutils.deepCopy(options or {})

	copy.isOwned = isOwned
	return copy
end

return v5
