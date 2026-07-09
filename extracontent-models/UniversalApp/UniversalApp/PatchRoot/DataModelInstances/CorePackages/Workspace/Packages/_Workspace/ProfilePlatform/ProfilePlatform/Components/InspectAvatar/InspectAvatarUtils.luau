local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Common.AssetInfo)
require(ProfilePlatformParent.CatalogNetworking)

local AvatarExperienceInspectAndBuy = require(ProfilePlatformParent.AvatarExperienceInspectAndBuy)
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local PriceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus

require(ProfilePlatform.Common.Types)

local SalesLocationType = require(ProfilePlatformParent.AvatarExperienceCommon).Enums.SalesLocationType
local t1 = {
	[61] = true,
	[60] = true,
	[55] = true,
	[56] = true,
	[57] = true,
	[58] = true,
	[59] = true,
	[48] = true,
	[9] = true
}
local t2 = {}

for _, v10 in Enum.AvatarAssetType:GetEnumItems() do
	if not t1[v10.Value] then
		t2[v10.Value] = true
	end
end

local function getPriceStatusForProfile(p1) -- line: 45
	-- upvalues: getPriceStatusInShop (copy)
	return getPriceStatusInShop(p1)
end
local function normalizeSaleLocationType(p2) -- line: 113
	-- upvalues: SalesLocationType (copy)
	if p2.saleLocationType == SalesLocationType.ShopOnly then
		return SalesLocationType.ShopAndAllExperiences
	end

	return p2.saleLocationType
end
local function resolveIsOwned(p3, p4, b1: boolean?) -- line: 122
	if p4 and p4.quantityOwned ~= nil then
		return p4.quantityOwned > 0
	end

	if b1 ~= nil then
		return b1
	end

	return p3.owned == true
end
local function buildItemRestrictions(p5) -- line: 135
	local itemRestrictions = p5.itemRestrictions

	if not itemRestrictions or #itemRestrictions == 0 then
		return nil
	end

	local t3 = {}

	for _, v45 in itemRestrictions do
		t3[v45] = true
	end

	return t3
end
local function buildCollectibleItemDetails(p6, p7, s1: string?) -- line: 147
	local t4 = nil

	if p6.hasResellers or (p6.unitsAvailableForConsumption or (p6.totalQuantity or (p6.lowestResalePrice or p7 and p7.quantityOwned))) then
		t4 = {
			hasResellers = p6.hasResellers,
			unitsAvailableForConsumption = p6.unitsAvailableForConsumption,
			totalQuantity = p6.totalQuantity,
			lowestResalePrice = p6.lowestResalePrice,
			resellableCount = if not p7 then nil else p7.quantityOwned,
			collectibleLowestAvailableResaleProductId = s1
		}
	end

	return t4
end
local function buildAssetsInBundle(p8, p9) -- line: 173
	local v52 = nil

	if p9 and p9.assetsInBundle then
		local t5 = {}

		for _, v55 in p9.assetsInBundle do
			table.insert(t5, {
				id = tostring(v55.id),
				assetType = tostring(v55.assetType),
				isIncluded = v55.isIncluded
			})
		end

		return t5
	end

	if p8.bundledItems then
		local t6 = {}

		for _, v58 in p8.bundledItems do
			if v58.type == "Asset" and v58.assetType then
				table.insert(t6, {
					id = tostring(v58.id),
					assetType = tostring(v58.assetType)
				})
			end
		end

		if #t6 > 0 then
			v52 = t6
		end
	end

	return v52
end
local function computeBundleParts(p10, p11, t7: {[any]: any}) -- line: 204
	-- upvalues: t2 (copy)
	local n1 = 0
	local t8 = {}

	if p11 and p11.assetsInBundle then
		for _, v65 in p11.assetsInBundle do
			if t7[tostring(v65.id)] then
				n1 += 1

				if t2[v65.assetType] == true then
					table.insert(t8, v65.id)
				end
			end
		end

		return n1, t8
	end

	if p10.bundledItems then
		for _, v67 in p10.bundledItems do
			if v67.type == "Asset" then
				n1 += 1

				if v67.assetType and t2[v67.assetType] == true then
					table.insert(t8, v67.id)
				end
			end
		end
	end

	return n1, t8
end
local function extractTaxonomyName(p12) -- line: 233
	if p12.taxonomy and #p12.taxonomy > 0 then
		return p12.taxonomy[1].taxonomyName
	end

	return nil
end

return {
	isWearableAssetType = function(n2: number) -- line: 49
		-- upvalues: t2 (copy)
		return t2[n2] == true
	end,
	expandBundleToAssetIds = function(p13) -- line: 53
		local t9 = {}

		if p13.bundledItems then
			for _, v24 in p13.bundledItems do
				if v24.type == "Asset" then
					table.insert(t9, v24.id)
				end
			end
		end

		return t9
	end,
	collectBundleComponentIds = function(t10: {[any]: any}, t11: {[any]: any}) -- line: 69
		local t12 = {}

		for _, v29 in t10 do
			local v30 = t11[v29]

			if v30 and v30.assetsInBundle then
				for _, v32 in v30.assetsInBundle do
					t12[tostring(v32.id)] = true
				end
			end
		end

		return t12
	end,
	buildItemData = function(p14, p15, t13: {[any]: any}, s2: string?, b2: boolean?, s3: string?) -- line: 240
		-- upvalues: computeBundleParts (copy), SalesLocationType (copy), buildCollectibleItemDetails (copy), buildAssetsInBundle (copy)
		local v75 = p14.assetType or p14.bundleType
		local v76, v77 = computeBundleParts(p14, p15, t13)
		local v78 = p14.itemType or "Asset"
		local t14 = {
			id = tostring(p14.id),
			name = p14.name,
			itemType = v78,
			itemSubType = if not v75 then nil else tostring(v75),
			priceInRobux = p14.price,
			creator = {
				creatorId = tostring(p14.creatorTargetId or ""),
				creatorName = p14.creatorName,
				creatorHasVerifiedBadge = p14.creatorHasVerifiedBadge
			},
			saleLocationType = if p14.saleLocationType ~= SalesLocationType.ShopOnly then p14.saleLocationType else SalesLocationType.ShopAndAllExperiences,
			isOffSale = p14.isOffSale,
			isOwned = if not p15 or p15.quantityOwned == nil then if b2 == nil then p14.owned == true else b2 else p15.quantityOwned > 0,
			noPriceStatus = if not p15 then nil else p15.noPriceStatus,
			catalogPriceStatus = p14.priceStatus,
			collectibleItemId = p14.collectibleItemId
		}
		local itemRestrictions = p14.itemRestrictions
		local v81

		if not itemRestrictions or #itemRestrictions == 0 then
			v81 = nil
		else
			v81 = {}

			for _, v83 in itemRestrictions do
				v81[v83] = true
			end
		end

		t14.itemRestrictions = v81
		t14.collectibleItemDetails = buildCollectibleItemDetails(p14, p15, s3)
		t14.assetsInBundle = buildAssetsInBundle(p14, p15)
		t14.collectibleProductId = if not p15 then s2 else p15.collectibleProductId
		t14.bundlePartsCount = v76
		t14.bundleAssetIds = v77
		t14.taxonomyName = if not p14.taxonomy or not (#p14.taxonomy > 0) then nil else p14.taxonomy[1].taxonomyName

		return t14
	end,
	isPurchasableStatus = function(s4: string) -- line: 85
		-- upvalues: PriceStatus (copy)
		return s4 == PriceStatus.Free or (s4 == PriceStatus.PurchaseFromRoblox or s4 == PriceStatus.PurchaseFromResale)
	end,
	isItemPurchasable = function(p16) -- line: 91
		-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
		if p16.isOwned then
			return false
		end

		local v35 = getPriceStatusInShop(p16)

		return (v35 == PriceStatus.Free or (v35 == PriceStatus.PurchaseFromRoblox or v35 == PriceStatus.PurchaseFromResale)) and p16.collectibleProductId ~= nil
	end,
	getEffectivePrice = function(p17) -- line: 98
		-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
		if getPriceStatusInShop(p17) == PriceStatus.PurchaseFromResale then
			if p17.collectibleItemDetails then
				return p17.collectibleItemDetails.lowestResalePrice or 0
			end

			return 0
		end

		return p17.priceInRobux or 0
	end,
	sortDisplayItems = function(t15: {[any]: any}) -- line: 279
		-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
		table.sort(t15, function(p18, p19) -- line: 280
			-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
			local function sortKey(p20) -- line: 281
				-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
				local v92 = getPriceStatusInShop(p20)

				if v92 == PriceStatus.Free or (v92 == PriceStatus.PurchaseFromRoblox or v92 == PriceStatus.PurchaseFromResale) then
					return 0
				end

				if v92 == PriceStatus.Owned or v92 == PriceStatus.QuantityLimitReached then
					return 1
				end

				return 2
			end

			local v88 = getPriceStatusInShop(p18)
			local v89 = if not (v88 == PriceStatus.Free or (v88 == PriceStatus.PurchaseFromRoblox or v88 == PriceStatus.PurchaseFromResale)) then v88 ~= PriceStatus.Owned and v88 ~= PriceStatus.QuantityLimitReached and 2 or 1 else 0
			local v90 = getPriceStatusInShop(p19)

			return v89 < if not (v90 == PriceStatus.Free or (v90 == PriceStatus.PurchaseFromRoblox or v90 == PriceStatus.PurchaseFromResale)) then v90 ~= PriceStatus.Owned and v90 ~= PriceStatus.QuantityLimitReached and 2 or 1 else 0
		end)

		return t15
	end,
	getPriceStatus = getPriceStatusForProfile,
	PriceStatusEnum = PriceStatus
}
