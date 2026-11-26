local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local generateStringId = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GenerateStringId
local UIBlox = require(CorePackages.Packages.UIBlox)
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@luauforge/bundled/dKU")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getRawItemLicensingInfo = AvatarExperienceCommon.Utils.getRawItemLicensingInfo
local parseItemLicensing = AvatarExperienceCommon.Utils.parseItemLicensing

require("@luauforge/bundled/dPs")

local module4 = require("@luauforge/bundled/dPN")

local module5 = require("@luauforge/bundled/dPT")

local defineFastFlag = game:DefineFastFlag("FixEmptyLimitedBadges", false)
local fFlagAXDurablesSupportForRFYMigration = AvatarExperienceFlags.FFlagAXDurablesSupportForRFYMigration
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXFixRecommendedItemCreatorType = AvatarExperienceFlags.FFlagAXFixRecommendedItemCreatorType
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell

local fFlagAXFetchItemDetailsFromAvatarEditorService = AvatarExperienceFlags.FFlagAXFetchItemDetailsFromAvatarEditorService
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing

local fFlagAXPopulateSupportsHeadShapesFromAvatarData = AvatarExperienceFlags.FFlagAXPopulateSupportsHeadShapesFromAvatarData

local function itemDataFromAssetInfoWithLicensing(p2, p3)
	local itemDataFromAssetInfo = module5.itemDataFromAssetInfo(p2, p3)
	local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

	if rawItemLicensingInfo ~= nil then
		itemDataFromAssetInfo.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
	end

	return itemDataFromAssetInfo
end

return {
	mock = function()
		return {
			receivedCatalogData = false,
			receivedRecommendedData = false,
			receivedFromRecommendedData = false,
			receivedFromBundleItemData = false,
			receivedFromInventoryFetch = false,
			receivedFromOutfitDetails = false,
			receivedFromResaleData = false,
			receivedFromVersionData = false,
			name = "",
			description = "",
			creatorName = "",
			assetType = module4.AssetTypeIdStrings.Hat,
			id = generateStringId(),
			priceInRobux = 1,
			creator = {
				id = generateStringId(),
				name = "",
				type = "",
				targetId = "",
				hasVerifiedBadge = false
			},
			created = "",
			updated = "",
			genres = {},
			minimumMembershipLevel = 0,
			product = { id = generateStringId(), type = "", isForSale = true },
			recommendedItemSummaries = {},
			favoriteCount = 0,
			priceStatus = "",
			itemRestrictions = {},
			itemStatus = {},
			lowestPrice = nil,
			numberRobloxHasAvailable = nil,
			totalQuantity = nil,
			resellerUserAssetIds = {},
			soldCount = 0,
			averagePrice = 0,
			originalPrice = 0,
			isForRent = false,
			isOwned = false,
			supportsHeadShapes = false,
			isPurchasable = false,
			expectedSellerId = generateStringId(),
			creatingUniverseId = nil,
			collectibleItemId = "0",
			moderationStatus = nil
		}
	end,
	fromRecommendedItemSummaries = function(recommendedItemSummaries, options)
		local copy = tutils.deepCopy(options or {})
		copy.receivedRecommendedData = true
		copy.recommendedItemSummaries = recommendedItemSummaries

		return copy
	end,
	fromGetRecommendedItemsDataV2 = function(p2, assetType, p3)
		local v6

		if fFlagAXMarketplaceLicensing then
			v6 = module5.itemDataFromAssetInfo(p2, p3)
			local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

			if rawItemLicensingInfo ~= nil then
				v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
			end
		else
			v6 = module5.itemDataFromAssetInfo(p2, p3)
		end

		v6.receivedFromRecommendedData = true

		if assetType then
			v6.assetType = assetType
		end

		return v6
	end,
	fromHydrateWidgetInfo = function(data, options)
		local copy = tutils.deepCopy(options or {})
		copy.id = tostring(data.id)

		if data.failedToHydrate then
			copy.failedToHydrate = true
			return copy
		end

		copy.name = data.name

		local v7 = if data.creator then data.creator.name else data.creatorName
		local v8 = if data.creator then data.creator.hasVerifiedBadge else nil
		copy.creator = { name = v7, hasVerifiedBadge = v8 }

		copy.assetType = module4.AssetTypeIdStrings[tostring(data.assetType)]
		copy.priceInRobux = data.price
		local v9 = if fFlagAXShowFaeUpsell then data.priceStatus else nil
		copy.priceStatus = v9
		copy.receivedWidgetHydration = true
		local rawItemLicensingInfo = getRawItemLicensingInfo(data)

		if fFlagAXMarketplaceLicensing and rawItemLicensingInfo ~= nil then
			copy.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
		end

		if fFlagAXBackgroundGeneration and data.isPlusExclusive ~= nil then
			copy.isPlusExclusive = data.isPlusExclusive
		end

		local v10 = not defineFastFlag and {} or nil

		if data.isLimited or data.isLimitedUnique or data.isCollectible then
			v10 = {}
			v10[itemTileEnums.Restriction.Limited] = data.isLimited and true or false
			v10[itemTileEnums.Restriction.LimitedUnique] = data.isLimitedUnique and true or false
			v10[itemTileEnums.Restriction.Collectible] = data.isCollectible and true or false
		end

		copy.tileRestrictionsMap = v10

		if fFlagAXShowFaeUpsell and data.itemStatus then
			copy.itemStatus = data.itemStatus
		end

		if not (fFlagAXDurablesSupportForRFYMigration and data.timedOptions) then
			return copy
		end

		local v11 = {}

		for k, timedOption in data.timedOptions do
			table.insert(v11, {
				days = timedOption.days,
				price = timedOption.price,
				selected = timedOption.selected
			})
		end

		local v12 = false
		local v13 = false

		for k, v15 in v11 do
			v12 = v15.selected and true or v12

			v13 = v15.days == 0 or v13

			if v12 and v13 then
				break
			end
		end

		if not v13 then
			table.insert(v11, {
				days = 0,
				price = data.price,
				selected = not v12 or nil
			})
		end

		copy.timedOptions = v11

		return copy
	end,
	fromGetRecommendedItemsData = function(data, assetType, options)
		local copy = tutils.deepCopy(options or {})

		copy.receivedFromRecommendedData = true

		if data.item then
			copy.name = data.item.name
			copy.id = tostring(data.item.assetId)
			copy.priceInRobux = data.item.price
		end

		if data.product and data.product.isFree then
			copy.priceInRobux = 0
		end

		if data.product then
			copy.product = { id = tostring(data.product.id) }
		end

		if data.creator then
			local v6 = {
				id = tostring(data.creator.creatorId),
				name = data.creator.name,
				type = 0
			}

			local v7 = if fFlagAXFixRecommendedItemCreatorType then data.creator.creatorType else data.creator.type
			v6.type = v7
			copy.creator = v6
		end

		if assetType then
			copy.assetType = assetType
		end

		return copy
	end,
	fromGetCatalogItemData = function(data, p2)
		if fFlagAXFetchItemDetailsFromAvatarEditorService and data.timedOptions then
			for k, timedOption in data.timedOptions do
				if timedOption.days == nil and timedOption.duration ~= nil then
					timedOption.days = math.floor(timedOption.duration / 86400)
				end
			end
		end

		local v6

		if fFlagAXMarketplaceLicensing then
			v6 = module5.itemDataFromAssetInfo(data, p2)
			local rawItemLicensingInfo = getRawItemLicensingInfo(data)

			if rawItemLicensingInfo ~= nil then
				v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
			end
		else
			v6 = module5.itemDataFromAssetInfo(data, p2)
		end

		if not (fFlagAXInventoryDurablesExpiredFilter and data.skipReceivedCatalogData) then
			v6.receivedCatalogData = true
		end

		if data.timedOptions then
			local v7 = {}

			for k, timedOption in data.timedOptions do
				local v8 = {
					days = timedOption.days,
					price = timedOption.price,
					discountInformation = 0,
					selected = 0
				}
				local v9 = if timedOption.days == 0 then data.discountInformation else timedOption.discountInformation
				v8.discountInformation = v9

				v8.selected = timedOption.selected
				table.insert(v7, v8)
			end

			v6.timedOptions = v7
		end

		if fFlagAXInventoryDurablesSupport then
			if
				fFlagAXFetchItemDetailsFromAvatarEditorService
				and typeof(data.expirationTime) == "DateTime"
			then
				v6.expirationTime = data.expirationTime:ToIsoDate()
			else
				v6.expirationTime = data.expirationTime
			end
		end

		local v7 = if tonumber(data.assetType) then tostring(data.assetType) else module4.AssetTypeIdStrings[tostring(data.assetType)]
		v6.assetType = v7

		return v6
	end,
	fromBundleItemData = function(data, options)
		local copy = tutils.deepCopy(options or {})

		copy.receivedFromBundleItemData = true
		copy.id = tostring(data.id)
		copy.name = data.name
		copy.isOwned = data.owned

		return copy
	end,
	fromSortResults = function(p2, p3)
		local v6

		if fFlagAXMarketplaceLicensing then
			v6 = module5.itemDataFromAssetInfo(p2, p3)
			local rawItemLicensingInfo = getRawItemLicensingInfo(p2)

			if rawItemLicensingInfo ~= nil then
				v6.itemLicensingInfo = parseItemLicensing(rawItemLicensingInfo)
			end
		else
			v6 = module5.itemDataFromAssetInfo(p2, p3)
		end

		v6.receivedFromSortResults = true
		return v6
	end,
	fromBundledItems = function(p2, p3)
		return module5.itemDataFromAssetInfo(p2, p3)
	end,
	fromInventoryFetch = function(data, options)
		local copy = tutils.deepCopy(options or {})

		copy.receivedFromInventoryFetch = true
		copy.id = tostring(data.assetId)
		copy.name = data.name
		copy.assetType = module4.AssetTypeIdStrings[data.assetType]

		if fFlagAXMarketplaceLicensing and data.license ~= nil then
			copy.itemLicensingInfo = parseItemLicensing(data.license)
		end

		if data.moderationStatus then
			copy.moderationStatus = data.moderationStatus
		end

		if data.creatingUniverseId then
			copy.creatingUniverseId = data.creatingUniverseId
		end

		if fFlagAXInventoryDurablesSupport and data.expirationTime then
			copy.expirationTime = data.expirationTime
		end

		if not fFlagAXBackgroundGeneration then
			return copy
		end

		if data.isPlusExclusive then
			copy.isOwned = true
		end

		if data.isPlusExclusive ~= nil then
			copy.isPlusExclusive = data.isPlusExclusive
		end

		return copy
	end,
	fromAssetGrant = function(id, assetType, options)
		local copy = tutils.deepCopy(options or {})

		module.isType(id, "string", "AssetInfo.fromAssetGrant expects assetId to be a string")
		module.isType(assetType, "string", "AssetInfo.fromAssetGrant expects assetType to be a string")

		copy.id = id
		copy.assetType = assetType
		copy.moderationStatus = Enum.ModerationStatus.NotReviewed

		return copy
	end,
	fromModerationStatusUpdate = function(moderationStatus, updateCounter, id, name, creatingUniverseId, options)
		local copy = tutils.deepCopy(options or {})

		copy.moderationStatus = moderationStatus
		copy.updateCounter = updateCounter
		copy.id = id
		copy.name = name
		copy.creatingUniverseId = creatingUniverseId
		return copy
	end,
	fromOutfitDetails = function(data, options, outfitModerationStatus)
		local copy = tutils.deepCopy(options or {})

		copy.receivedFromOutfitDetails = true
		copy.id = tostring(data.id)
		copy.name = data.name
		copy.assetType = tostring(data.assetType.id)
		copy.outfitModerationStatus = outfitModerationStatus

		if data.supportsHeadShapes ~= nil then
			copy.supportsHeadShapes = data.supportsHeadShapes
		end

		return copy
	end,
	fromInventoryOutfitDetails = function(data, options)
		local copy = tutils.deepCopy(options or {})

		copy.id = tostring(data.id)
		copy.assetType = tostring(data.assetType.id)

		if data.supportsHeadShapes ~= nil then
			copy.supportsHeadShapes = data.supportsHeadShapes
		end

		return copy
	end,
	fromGetResellers = function(resellerUserAssetIds, options)
		local copy = tutils.deepCopy(options or {})

		copy.resellerUserAssetIds = resellerUserAssetIds

		return copy
	end,
	fromLowestPrice = function(lowestPrice, options)
		local copy = tutils.deepCopy(options or {})

		copy.lowestPrice = lowestPrice

		return copy
	end,
	fromResaleData = function(data, options)
		local copy = tutils.deepCopy(options or {})

		copy.receivedFromResaleData = true
		copy.soldCount = data.sales
		copy.averagePrice = data.recentAveragePrice
		copy.originalPrice = data.originalPrice

		return copy
	end,
	fromIsOwned = function(isOwned, options)
		local copy = tutils.deepCopy(options or {})

		copy.isOwned = isOwned
		return copy
	end,
	fromIsPlusExclusive = function(isPlusExclusive, options)
		local copy = tutils.deepCopy(options or {})

		copy.isPlusExclusive = isPlusExclusive
		return copy
	end,
	fromReceivedAvatarData = function(data)
		local v6 = {
			["id"] = tostring(data.id),
			name = data.name,
			assetType = tostring(data.assetType.id)
		}

		if fFlagAXPopulateSupportsHeadShapesFromAvatarData and data.supportsHeadShapes ~= nil then
			v6.supportsHeadShapes = data.supportsHeadShapes
		end

		return v6
	end,
	fromVersionData = function(p2, options)
		local copy = tutils.deepCopy(options or {})

		local v6 = p2.data[1]

		copy.receivedFromVersionData = true
		local v7 = if v6.creatingUniverseId then tostring(v6.creatingUniverseId) else nil
		copy.creatingUniverseId = v7

		return copy
	end
}
