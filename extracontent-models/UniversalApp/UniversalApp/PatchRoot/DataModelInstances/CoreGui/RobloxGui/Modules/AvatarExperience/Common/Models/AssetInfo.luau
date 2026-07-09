local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local GenerateStringId = require(CorePackages.Workspace.Packages.AppCommonLib).GenerateStringId
local ItemTileEnums = require(CorePackages.Packages.UIBlox).Tile.ItemTileEnums
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local ModelsUtils = require(script.Parent.ModelsUtils)
local v11 = game:DefineFastFlag("FixEmptyLimitedBadges", false)
local FFlagAXDurablesSupportForRFYMigration = AvatarExperienceFlags.FFlagAXDurablesSupportForRFYMigration
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagAXFixRecommendedItemCreatorType = AvatarExperienceFlags.FFlagAXFixRecommendedItemCreatorType
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXFixWidgetHydrationPermanentPrice = AvatarExperienceFlags.FFlagAXFixWidgetHydrationPermanentPrice

return {
	mock = function() -- line: 38
		-- upvalues: Constants (copy), GenerateStringId (copy)
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
			assetType = Constants.AssetTypeIdStrings.Hat,
			id = GenerateStringId(),
			priceInRobux = 1,
			creator = {
				name = "",
				type = "",
				targetId = "",
				hasVerifiedBadge = false,
				id = GenerateStringId()
			},
			created = "",
			updated = "",
			genres = {},
			minimumMembershipLevel = 0,
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
			totalQuantity = nil,
			resellerUserAssetIds = {},
			soldCount = 0,
			averagePrice = 0,
			originalPrice = 0,
			isForRent = false,
			isOwned = false,
			supportsHeadShapes = false,
			isPurchasable = false,
			expectedSellerId = GenerateStringId(),
			creatingUniverseId = nil,
			collectibleItemId = "0",
			moderationStatus = nil
		}
	end,
	fromRecommendedItemSummaries = function(t1: {[any]: any}?, p1) -- line: 114
		-- upvalues: tutils (copy)
		local v22 = tutils.deepCopy(p1 or {})

		v22.receivedRecommendedData = true
		v22.recommendedItemSummaries = t1

		return v22
	end,
	fromGetRecommendedItemsDataV2 = function(p2, p3, p4) -- line: 126
		-- upvalues: ModelsUtils (copy)
		local v26 = ModelsUtils.itemDataFromAssetInfo(p2, p4)

		v26.receivedFromRecommendedData = true

		if p3 then
			v26.assetType = p3
		end

		return v26
	end,
	fromHydrateWidgetInfo = function(p5, p6) -- line: 140
		-- upvalues: tutils (copy), Constants (copy), FFlagAXShowFaeUpsell (copy), v11 (copy), ItemTileEnums (copy), FFlagAXDurablesSupportForRFYMigration (copy), FFlagAXFixWidgetHydrationPermanentPrice (copy)
		local v29 = tutils.deepCopy(p6 or {})

		v29.id = tostring(p5.id)

		if p5.failedToHydrate then
			v29.failedToHydrate = true

			return v29
		end

		v29.name = p5.name
		v29.creator = {
			name = if not p5.creator then p5.creatorName else p5.creator.name,
			hasVerifiedBadge = if not p5.creator then nil else p5.creator.hasVerifiedBadge
		}
		v29.assetType = Constants.AssetTypeIdStrings[tostring(p5.assetType)]
		v29.priceInRobux = p5.price
		v29.priceStatus = if not FFlagAXShowFaeUpsell then nil else p5.priceStatus
		v29.receivedWidgetHydration = true

		local v30 = if not v11 then {} else nil

		if p5.isLimited or p5.isLimitedUnique or p5.isCollectible then
			v30 = {
				[ItemTileEnums.Restriction.Limited] = not not p5.isLimited,
				[ItemTileEnums.Restriction.LimitedUnique] = not not p5.isLimitedUnique,
				[ItemTileEnums.Restriction.Collectible] = not not p5.isCollectible
			}
		end

		v29.tileRestrictionsMap = v30

		if FFlagAXShowFaeUpsell and p5.itemStatus then
			v29.itemStatus = p5.itemStatus
		end

		if FFlagAXDurablesSupportForRFYMigration and p5.timedOptions then
			local t2 = {}

			for _, v33 in p5.timedOptions do
				table.insert(t2, {
					days = v33.days,
					price = v33.price,
					selected = v33.selected
				})
			end

			if FFlagAXFixWidgetHydrationPermanentPrice then
				local v34 = false
				local v35 = false

				for _, v37 in t2 do
					if v37.selected then
						v34 = true
					end

					if v37.days == 0 then
						v35 = true
					end

					if v34 and v35 then
						break
					end
				end

				if not v35 then
					table.insert(t2, {
						days = 0,
						price = p5.price,
						selected = not v34 or nil
					})
				end
			end

			v29.timedOptions = t2
		end

		return v29
	end,
	fromGetRecommendedItemsData = function(p7, p8, p9) -- line: 225
		-- upvalues: tutils (copy), FFlagAXFixRecommendedItemCreatorType (copy)
		local v41 = tutils.deepCopy(p9 or {})

		v41.receivedFromRecommendedData = true

		if p7.item then
			v41.name = p7.item.name
			v41.id = tostring(p7.item.assetId)
			v41.priceInRobux = p7.item.price
		end

		if p7.product and p7.product.isFree then
			v41.priceInRobux = 0
		end

		if p7.product then
			v41.product = {
				id = tostring(p7.product.id)
			}
		end

		if p7.creator then
			v41.creator = {
				id = tostring(p7.creator.creatorId),
				name = p7.creator.name,
				type = if not FFlagAXFixRecommendedItemCreatorType then p7.creator.type else p7.creator.creatorType
			}
		end

		if p8 then
			v41.assetType = p8
		end

		return v41
	end,
	fromGetCatalogItemData = function(p10, p11) -- line: 266
		-- upvalues: ModelsUtils (copy), FFlagAXInventoryDurablesExpiredFilter (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXMISEnableMultiShopping (copy), Constants (copy)
		local v44 = ModelsUtils.itemDataFromAssetInfo(p10, p11)

		if not FFlagAXInventoryDurablesExpiredFilter or not p10.skipReceivedCatalogData then
			v44.receivedCatalogData = true
		end

		if p10.timedOptions then
			local t3 = {}

			for _, v47 in p10.timedOptions do
				table.insert(t3, {
					days = v47.days,
					price = v47.price,
					discountInformation = if v47.days == 0 then p10.discountInformation else v47.discountInformation,
					selected = v47.selected
				})
			end

			v44.timedOptions = t3
		end

		if FFlagAXInventoryDurablesSupport then
			v44.expirationTime = p10.expirationTime
		end

		if FFlagAXMISEnableMultiShopping then
			v44.assetType = if not tonumber(p10.assetType) then Constants.AssetTypeIdStrings[tostring(p10.assetType)] else tostring(p10.assetType)

			return v44
		end

		v44.assetType = Constants.AssetTypeIdStrings[tostring(p10.assetType)]

		if v44.assetType == nil and p10.assetType ~= nil then
			v44.assetType = tostring(p10.assetType)
		end

		return v44
	end,
	fromBundleItemData = function(p12, p13) -- line: 313
		-- upvalues: tutils (copy)
		local v50 = tutils.deepCopy(p13 or {})

		v50.receivedFromBundleItemData = true
		v50.id = tostring(p12.id)
		v50.name = p12.name
		v50.isOwned = p12.owned

		return v50
	end,
	fromSortResults = function(p14, p15) -- line: 324
		-- upvalues: ModelsUtils (copy)
		local v53 = ModelsUtils.itemDataFromAssetInfo(p14, p15)

		v53.receivedFromSortResults = true

		return v53
	end,
	fromBundledItems = function(p16, p17) -- line: 330
		-- upvalues: ModelsUtils (copy)
		return ModelsUtils.itemDataFromAssetInfo(p16, p17)
	end,
	fromInventoryFetch = function(p18, p19) -- line: 334
		-- upvalues: tutils (copy), Constants (copy), FFlagAXInventoryDurablesSupport (copy)
		local v58 = tutils.deepCopy(p19 or {})

		v58.receivedFromInventoryFetch = true
		v58.id = tostring(p18.assetId)
		v58.name = p18.name
		v58.assetType = Constants.AssetTypeIdStrings[p18.assetType]

		if p18.moderationStatus then
			v58.moderationStatus = p18.moderationStatus
		end

		if p18.creatingUniverseId then
			v58.creatingUniverseId = p18.creatingUniverseId
		end

		if FFlagAXInventoryDurablesSupport and p18.expirationTime then
			v58.expirationTime = p18.expirationTime
		end

		return v58
	end,
	fromAssetGrant = function(p20, p21, p22) -- line: 359
		-- upvalues: tutils (copy), ArgCheck (copy)
		local v62 = tutils.deepCopy(p22 or {})

		ArgCheck.isType(p20, "string", "AssetInfo.fromAssetGrant expects assetId to be a string")
		ArgCheck.isType(p21, "string", "AssetInfo.fromAssetGrant expects assetType to be a string")
		v62.id = p20
		v62.assetType = p21
		v62.moderationStatus = Enum.ModerationStatus.NotReviewed

		return v62
	end,
	fromModerationStatusUpdate = function(p23, p24, p25, p26, p27, p28) -- line: 376
		-- upvalues: tutils (copy)
		local v69 = tutils.deepCopy(p28 or {})

		v69.moderationStatus = p23
		v69.updateCounter = p24
		v69.id = p25
		v69.name = p26
		v69.creatingUniverseId = p27

		return v69
	end,
	fromOutfitDetails = function(p29, p30, p31) -- line: 394
		-- upvalues: tutils (copy), FFlagDynamicHeadsMigration (copy)
		local v73 = tutils.deepCopy(p30 or {})

		v73.receivedFromOutfitDetails = true
		v73.id = tostring(p29.id)
		v73.name = p29.name
		v73.assetType = tostring(p29.assetType.id)
		v73.outfitModerationStatus = p31

		if FFlagDynamicHeadsMigration and p29.supportsHeadShapes ~= nil then
			v73.supportsHeadShapes = p29.supportsHeadShapes
		end

		return v73
	end,
	fromGetResellers = function(p32, p33) -- line: 418
		-- upvalues: tutils (copy)
		local v76 = tutils.deepCopy(p33 or {})

		v76.resellerUserAssetIds = p32

		return v76
	end,
	fromLowestPrice = function(n1: number, p34) -- line: 426
		-- upvalues: tutils (copy)
		local v79 = tutils.deepCopy(p34 or {})

		v79.lowestPrice = n1

		return v79
	end,
	fromResaleData = function(p35, p36) -- line: 434
		-- upvalues: tutils (copy)
		local v82 = tutils.deepCopy(p36 or {})

		v82.receivedFromResaleData = true
		v82.soldCount = p35.sales
		v82.averagePrice = p35.recentAveragePrice
		v82.originalPrice = p35.originalPrice

		return v82
	end,
	fromIsOwned = function(b1: boolean, p37) -- line: 445
		-- upvalues: tutils (copy)
		local v85 = tutils.deepCopy(p37 or {})

		v85.isOwned = b1

		return v85
	end,
	fromReceivedAvatarData = function(p38) -- line: 452
		return {
			id = tostring(p38.id),
			name = p38.name,
			assetType = tostring(p38.assetType.id)
		}
	end,
	fromVersionData = function(p39, p40) -- line: 472
		-- upvalues: tutils (copy)
		local v89 = tutils.deepCopy(p40 or {})
		local v90 = p39.data[1]

		v89.receivedFromVersionData = true
		v89.creatingUniverseId = if not v90.creatingUniverseId then nil else tostring(v90.creatingUniverseId)

		return v89
	end
}
