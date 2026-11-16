local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/dME")
local itemTileEnums = UIBlox.Tile.ItemTileEnums

local tutils = require(CorePackages.Packages.tutils)
require("@luauforge/bundled/dMc")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local v5 = {}

function v5.CreateRestrictionInfo(p2)
	if not p2 then
		return nil, nil
	end

	local set = Cryo.List.toSet(p2)

	local v6 = set[module.ItemRestrictions.Limited]
	local v7 = set[module.ItemRestrictions.LimitedUnique]

	local v8 = set[module.ItemRestrictions.Collectible]
	local v9

	if v6 or v7 or v8 then
		v9 = {}
		v9[itemTileEnums.Restriction.Limited] = v6
		v9[itemTileEnums.Restriction.LimitedUnique] = v7
		v9[itemTileEnums.Restriction.Collectible] = v8
	end

	return set, v9
end

function v5.itemDataFromAssetInfo(data, options)
	local copy = tutils.deepCopy(options or {})
	local restrictionInfo, v6 = v5.CreateRestrictionInfo(data.itemRestrictions)
	local v7 = data.productId and { id = tostring(data.productId) } or nil

	local v8 = data.creatorTargetId
		and {
			id = tostring(data.creatorTargetId),
			name = data.creatorName,
			type = data.creatorType,
			hasVerifiedBadge = data.creatorHasVerifiedBadge
		}
		or nil
	local timedOptions

	if data.timedOptions then
		timedOptions = data.timedOptions
		local v9 = false
		local v10 = false

		for k, timedOption in timedOptions do
			v9 = timedOption.days == 0 or v9

			if timedOption.selected then
				v10 = true
			end
		end

		if not v9 then
			table.insert(timedOptions, {
				days = 0,
				price = data.price,
				selected = not v10 or nil
			})
		end
	end

	local v9 = fFlagAXShowFaeUpsell and {} or nil

	if fFlagAXShowFaeUpsell and (copy.itemStatus or data.itemStatus) then
		local set = {}

		for k, v10 in Cryo.List.join(copy.itemStatus or {}, data.itemStatus or {}) do
			if set[v10] then
				continue
			end

			set[v10] = true
			table.insert(v9, v10)
		end
	end

	local join = Dash.join
	local v11 = if data.id then tostring(data.id) else nil
	local v12 = if data.assetType then tostring(data.assetType) else nil
	local v10 = {}
	v10.id = v11
	v10.assetType = v12
	v10.name = data.name
	v10.description = data.description
	v10.product = v7
	v10.genres = data.genres
	v10.creator = v8
	v10.priceInRobux = data.price
	v10.lowestPrice = data.lowestPrice
	v10.lowestResalePrice = data.lowestResalePrice
	v10.favoriteCount = data.favoriteCount
	v10.discountInformation = data.discountInformation

	if not fFlagAXShowFaeUpsell then
		v9 = data.itemStatus
	end

	v10.itemStatus = v9
	v10.itemRestrictions = restrictionInfo
	v10.tileRestrictionsMap = v6

	v10.priceStatus = data.priceStatus
	v10.numberRobloxHasAvailable = data.unitsAvailableForConsumption or data.numberRobloxHasAvailable
	v10.totalQuantity = data.totalQuantity
	local v13 = if fFlagAXBackgroundGeneration then data.isPlusExclusive else nil
	v10.isPlusExclusive = v13

	v10.isForRent = data.isForRent
	v10.isOwned = data.owned
	v10.isPurchasable = data.isPurchasable
	local v14 = if data.expectedSellerId then tostring(data.expectedSellerId) else nil
	v10.expectedSellerId = v14

	v10.premiumPricing = data.premiumPricing
	v10.collectibleItemId = data.collectibleItemId
	v10.saleLocationType = data.saleLocationType
	v10.hasResellers = data.hasResellers
	v10.isOffSale = data.isOffSale
	local v15 = if fFlagAXAddHDRowInItemDetailsPage then data.isHighDefinition else nil
	v10.isHighDefinition = v15
	v10.isPBR = data.isPBR
	v10.renderProperties = data.renderProperties
	v10.variantAttributes = data.variantAttributes
	v10.timedOptions = timedOptions

	local v16 = if data.creatingUniverseId then tostring(data.creatingUniverseId) else nil
	v10.creatingUniverseId = v16
	v10.taxonomy = data.taxonomy
	return (join(copy, v10))
end

function v5.itemDataFromBundleInfo(data, bundleType, options)
	local copy = tutils.deepCopy(options or {})

	local v6 = {}

	if copy.items then
		for k, item in copy.items do
			v6[item.id] = item
		end
	end

	local restrictionInfo, v7 = v5.CreateRestrictionInfo(data.itemRestrictions)
	local v8 = data.productId and { id = tostring(data.productId) } or nil

	local v9 = data.creatorTargetId
		and {
			id = tostring(data.creatorTargetId),
			name = data.creatorName,
			type = data.creatorType,
			hasVerifiedBadge = data.creatorHasVerifiedBadge
		}
		or nil
	local values

	if data.bundledItems then
		values = {}

		for k, bundledItem in data.bundledItems do
			local joined = { id = tostring(bundledItem.id), assetType = 0, type = 0 }
			local v10 = if bundledItem.assetType then tostring(bundledItem.assetType) else nil
			joined.assetType = v10
			joined.type = bundledItem.type

			local v11 = v6[tostring(bundledItem.id)]

			if v11 then
				joined = Cryo.Dictionary.join(v11, joined)
			end

			table.insert(values, joined)
		end
	end

	local join = Dash.join
	local v11 = if data.id then tostring(data.id) else nil
	local v10 = {}
	v10.id = v11
	v10.itemType = data.itemType
	v10.bundleType = bundleType
	v10.name = data.name
	v10.description = data.description
	v10.product = v8
	v10.genres = data.genres
	v10.creator = v9
	v10.priceInRobux = data.price
	v10.favoriteCount = data.favoriteCount
	v10.discountInformation = data.discountInformation

	v10.itemStatus = data.itemStatus
	v10.itemRestrictions = restrictionInfo
	v10.tileRestrictionsMap = v7
	v10.lowestPrice = data.lowestPrice
	v10.lowestResalePrice = data.lowestResalePrice
	v10.priceStatus = data.priceStatus
	v10.numberRobloxHasAvailable = data.unitsAvailableForConsumption or data.numberRobloxHasAvailable

	v10.isForRent = data.isForRent
	v10.isOwned = data.owned
	v10.isPurchasable = data.isPurchasable
	local v12 = if data.expectedSellerId then tostring(data.expectedSellerId) else nil
	v10.expectedSellerId = v12

	v10.items = values
	v10.totalQuantity = data.totalQuantity
	v10.premiumPricing = data.premiumPricing
	v10.collectibleItemId = data.collectibleItemId
	v10.saleLocationType = data.saleLocationType
	v10.hasResellers = data.hasResellers
	v10.isOffSale = data.isOffSale
	v10.isRecolorable = data.isRecolorable
	local v13 = if fFlagAXAddHDRowInItemDetailsPage then data.isHighDefinition else nil
	v10.isHighDefinition = v13
	v10.isPBR = data.isPBR
	v10.renderProperties = data.renderProperties
	v10.taxonomy = data.taxonomy
	return (join(copy, v10))
end

return v5
