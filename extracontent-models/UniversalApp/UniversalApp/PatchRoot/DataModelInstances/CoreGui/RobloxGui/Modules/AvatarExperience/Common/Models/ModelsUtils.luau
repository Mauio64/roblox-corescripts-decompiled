local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Dash = require(CorePackages.Packages.Dash)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = CoreGui.RobloxGui.Modules
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ItemTileEnums = UIBlox.Tile.ItemTileEnums
local tutils = require(CorePackages.Packages.tutils)

require(Modules.AvatarExperience.Common.Types)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local v14 = game:DefineFastFlag("AXFixTimedOptionsDuplicateAppend", false)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local t2 = {
	CreateRestrictionInfo = function(p1) -- line: 38
		-- upvalues: Cryo (copy), CatalogConstants (copy), ItemTileEnums (copy)
		if not p1 then
			return nil, nil
		end

		local v17 = Cryo.List.toSet(p1)
		local v18 = v17[CatalogConstants.ItemRestrictions.Limited]
		local v19 = v17[CatalogConstants.ItemRestrictions.LimitedUnique]
		local v20 = v17[CatalogConstants.ItemRestrictions.Collectible]
		local t1 = nil

		if v18 or v19 or v20 then
			t1 = {
				[ItemTileEnums.Restriction.Limited] = v18,
				[ItemTileEnums.Restriction.LimitedUnique] = v19,
				[ItemTileEnums.Restriction.Collectible] = v20
			}
		end

		return v17, t1
	end
}

function t2.itemDataFromAssetInfo(p2, p3) -- line: 62
	-- upvalues: tutils (copy), t2 (copy), v14 (copy), FFlagAXShowFaeUpsell (copy), Cryo (copy), Dash (copy), FFlagAXAddHDRowInItemDetailsPage (copy)
	local v24 = tutils.deepCopy(p3 or {})
	local v25, v26 = t2.CreateRestrictionInfo(p2.itemRestrictions)
	local v27 = if not p2.productId then nil else {
		id = tostring(p2.productId)
	}
	local v28 = if not p2.creatorTargetId then nil else {
		id = tostring(p2.creatorTargetId),
		name = p2.creatorName,
		type = p2.creatorType,
		hasVerifiedBadge = p2.creatorHasVerifiedBadge
	}
	local timedOptions = nil

	if p2.timedOptions then
		timedOptions = p2.timedOptions

		local v30 = not v14 and nil
		local v31 = false

		for _, v33 in timedOptions do
			if v14 and v33.days == 0 then
				v30 = true
			end

			if v33.selected then
				v31 = true
			end
		end

		if v14 then
			if not v30 then
				table.insert(timedOptions, {
					days = 0,
					price = p2.price,
					selected = not v31 or nil
				})
			end
		else
			table.insert(timedOptions, {
				days = 0,
				price = p2.price,
				selected = not v31 or nil
			})
		end
	end

	local v34 = if not FFlagAXShowFaeUpsell then nil else {}

	if FFlagAXShowFaeUpsell and (v24.itemStatus or p2.itemStatus) then
		local t3 = {}

		for _, v37 in Cryo.List.join(v24.itemStatus or {}, p2.itemStatus or {}) do
			if not t3[v37] then
				t3[v37] = true
				table.insert(v34, v37)
			end
		end
	end

	return (Dash.join(v24, {
		id = if not p2.id then nil else tostring(p2.id),
		assetType = if not p2.assetType then nil else tostring(p2.assetType),
		name = p2.name,
		description = p2.description,
		product = v27,
		genres = p2.genres,
		creator = v28,
		priceInRobux = p2.price,
		lowestPrice = p2.lowestPrice,
		lowestResalePrice = p2.lowestResalePrice,
		favoriteCount = p2.favoriteCount,
		discountInformation = p2.discountInformation,
		itemStatus = if not FFlagAXShowFaeUpsell then p2.itemStatus else v34,
		itemRestrictions = v25,
		tileRestrictionsMap = v26,
		priceStatus = p2.priceStatus,
		numberRobloxHasAvailable = p2.unitsAvailableForConsumption or p2.numberRobloxHasAvailable,
		totalQuantity = p2.totalQuantity,
		isForRent = p2.isForRent,
		isOwned = p2.owned,
		isPurchasable = p2.isPurchasable,
		expectedSellerId = if not p2.expectedSellerId then nil else tostring(p2.expectedSellerId),
		premiumPricing = p2.premiumPricing,
		collectibleItemId = p2.collectibleItemId,
		saleLocationType = p2.saleLocationType,
		hasResellers = p2.hasResellers,
		isOffSale = p2.isOffSale,
		isHighDefinition = if not FFlagAXAddHDRowInItemDetailsPage then nil else p2.isHighDefinition,
		isPBR = p2.isPBR,
		variantAttributes = p2.variantAttributes,
		timedOptions = timedOptions,
		creatingUniverseId = if not p2.creatingUniverseId then nil else tostring(p2.creatingUniverseId),
		taxonomy = p2.taxonomy
	}))
end
function t2.itemDataFromBundleInfo(p4, p5, p6) -- line: 173
	-- upvalues: tutils (copy), FFlagAXMISEnableMultiShopping (copy), t2 (copy), Cryo (copy), Dash (copy), FFlagAXAddHDRowInItemDetailsPage (copy)
	local v41 = tutils.deepCopy(p6 or {})
	local t4 = {}

	if FFlagAXMISEnableMultiShopping and v41.items then
		for _, v44 in v41.items do
			t4[v44.id] = v44
		end
	end

	local v45, v46 = t2.CreateRestrictionInfo(p4.itemRestrictions)
	local v47 = if not p4.productId then nil else {
		id = tostring(p4.productId)
	}
	local v48 = if not p4.creatorTargetId then nil else {
		id = tostring(p4.creatorTargetId),
		name = p4.creatorName,
		type = p4.creatorType,
		hasVerifiedBadge = p4.creatorHasVerifiedBadge
	}
	local t5 = nil

	if p4.bundledItems then
		t5 = {}

		for _, v51 in p4.bundledItems do
			local t6 = {
				id = tostring(v51.id),
				assetType = if not v51.assetType then nil else tostring(v51.assetType),
				type = v51.type
			}

			if FFlagAXMISEnableMultiShopping then
				local v53 = t4[tostring(v51.id)]

				if v53 then
					t6 = Cryo.Dictionary.join(v53, t6)
				end
			end

			table.insert(t5, t6)
		end
	end

	return (Dash.join(v41, {
		id = if not p4.id then nil else tostring(p4.id),
		itemType = p4.itemType,
		bundleType = p5,
		name = p4.name,
		description = p4.description,
		product = v47,
		genres = p4.genres,
		creator = v48,
		priceInRobux = p4.price,
		favoriteCount = p4.favoriteCount,
		discountInformation = p4.discountInformation,
		itemStatus = p4.itemStatus,
		itemRestrictions = v45,
		tileRestrictionsMap = v46,
		lowestPrice = p4.lowestPrice,
		lowestResalePrice = p4.lowestResalePrice,
		priceStatus = p4.priceStatus,
		numberRobloxHasAvailable = p4.unitsAvailableForConsumption or p4.numberRobloxHasAvailable,
		isForRent = p4.isForRent,
		isOwned = p4.owned,
		isPurchasable = p4.isPurchasable,
		expectedSellerId = if not p4.expectedSellerId then nil else tostring(p4.expectedSellerId),
		items = t5,
		totalQuantity = p4.totalQuantity,
		premiumPricing = p4.premiumPricing,
		collectibleItemId = p4.collectibleItemId,
		saleLocationType = p4.saleLocationType,
		hasResellers = p4.hasResellers,
		isOffSale = p4.isOffSale,
		isRecolorable = p4.isRecolorable,
		isHighDefinition = if not FFlagAXAddHDRowInItemDetailsPage then nil else p4.isHighDefinition,
		isPBR = p4.isPBR,
		taxonomy = p4.taxonomy
	}))
end

return t2
