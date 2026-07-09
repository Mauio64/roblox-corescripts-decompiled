local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Signals = require(AvatarExperienceCatalogParent.Signals)
local tutils = require(AvatarExperienceCatalogParent.tutils)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local PurchaseItemsErrorStatusMap = require(AvatarExperienceCatalog.Enums.PurchaseItemsErrorStatusMap)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local SharedFlags = require(AvatarExperienceCatalogParent.SharedFlags)
local ItemTileEnums = require(AvatarExperienceCatalogParent.UIBlox).Tile.ItemTileEnums

require(AvatarExperienceCatalog.Requests.PurchaseItems.PurchaseItemsTypes)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local Constants = AvatarExperienceCommon.Constants
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local getItemPurchaseActionType = AvatarExperienceCommon.Utils.getItemPurchaseActionType
local ItemPurchaseActionTypeEnum = AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum

local function getItemRestrictionFromItemData(p1) -- line: 28
	-- upvalues: ItemTileEnums (copy)
	local v27 = if not p1 then nil else p1.tileRestrictionsMap

	if v27 then
		if v27[ItemTileEnums.Restriction.Limited] then
			return "Limited"
		end

		if v27[ItemTileEnums.Restriction.LimitedUnique] or v27[ItemTileEnums.Restriction.Collectible] then
			return "Collectible"
		end
	end

	return nil
end

local _ = {
	UNKNOWN = "UNKNOWN",
	PENDING = "PENDING",
	RESERVED = "RESERVED",
	SUCCEEDED = "SUCCEEDED",
	FAILED = "FAILED"
}

local function getItemCartData(t1: {[any]: any}, b1: boolean?) -- line: 118
	-- upvalues: Constants (copy), FFlagAXMISWithOffers (copy), FFlagAXMISSmallUIChanges (copy), PurchaseItemsErrorStatusMap (copy), tutils (copy), getItemPurchaseActionType (copy), ItemPurchaseActionTypeEnum (copy), FFlagAXDurablesForMIS (copy), ItemTileEnums (copy)
	if t1.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
		return {
			itemSubType = "1",
			priceInRobux = 0,
			name = "Default Body",
			isOwned = true,
			itemId = t1.itemId,
			collectibleItemId = if not FFlagAXMISWithOffers then nil else "n/a",
			itemType = t1.itemType,
			ordering = t1.ordering,
			creatorName = not FFlagAXMISSmallUIChanges and "Roblox" or nil,
			creatorVerified = not FFlagAXMISSmallUIChanges or nil,
			collectibleProductId = t1.itemId,
			status = PurchaseItemsErrorStatusMap.ALREADY_OWNED
		}
	end

	local itemData = t1.itemData
	local collectibleItemId = t1.collectibleItemId
	local collectibleItemInfo = t1.collectibleItemInfo
	local resellableInstances = t1.resellableInstances
	local v34 = not resellableInstances and 0 or tutils.fieldCount(resellableInstances)
	local v35 = b1 and collectibleItemId
	local v36 = getItemPurchaseActionType(itemData, collectibleItemInfo, v34, not v35)
	local v37 = v36 == ItemPurchaseActionTypeEnum.PurchaseFromResale
	local v38 = if not v37 then itemData.priceInRobux else itemData.lowestResalePrice
	local v39 = if not collectibleItemInfo then nil else if not v37 then collectibleItemInfo.collectibleProductId else collectibleItemInfo.lowestAvailableResaleProductId
	local v40 = if t1.itemType ~= Enum.AvatarItemType.Asset.Name then itemData.bundleType else itemData.assetType
	local v41 = itemData.creator or {}
	local name = v41.name
	local hasVerifiedBadge = v41.hasVerifiedBadge
	local name2 = itemData.name
	local SOLD_OUT = nil

	if v36 == ItemPurchaseActionTypeEnum.SoldOut then
		SOLD_OUT = PurchaseItemsErrorStatusMap.SOLD_OUT
	elseif v36 == ItemPurchaseActionTypeEnum.CustomizeLink then
		SOLD_OUT = PurchaseItemsErrorStatusMap.ALREADY_OWNED
	elseif v36 == ItemPurchaseActionTypeEnum.ExperienceLink then
		SOLD_OUT = PurchaseItemsErrorStatusMap.EXPERIENCE_LINK
	elseif v36 == ItemPurchaseActionTypeEnum.Disabled then
		SOLD_OUT = PurchaseItemsErrorStatusMap.NOT_FOR_SALE
	end

	local days = nil

	if FFlagAXDurablesForMIS and itemData.timedOptions then
		if t1.selectedTimedOptionIndex ~= nil then
			local v47 = itemData.timedOptions[t1.selectedTimedOptionIndex]

			if v47 then
				days = v47.days
				v38 = v47.price
			end
		else
			for _, v49 in itemData.timedOptions do
				if v49.selected then
					days = v49.days
					v38 = v49.price

					break
				end
			end
		end
	end

	local t2 = {
		itemId = t1.itemId,
		itemType = t1.itemType,
		expirationTime = itemData.expirationTime,
		isOwned = itemData.isOwned,
		discountInformation = itemData.discountInformation,
		itemSubType = v40
	}
	local v51 = if not itemData then nil else itemData.tileRestrictionsMap

	t2.itemRestriction = if not v51 then nil else if not v51[ItemTileEnums.Restriction.Limited] then if not v51[ItemTileEnums.Restriction.LimitedUnique] and not v51[ItemTileEnums.Restriction.Collectible] then nil else "Collectible" else "Limited"
	t2.ordering = t1.ordering
	t2.creatorName = if not FFlagAXMISSmallUIChanges then name else nil
	t2.creatorVerified = if not FFlagAXMISSmallUIChanges then hasVerifiedBadge else nil
	t2.collectibleProductId = v39
	t2.collectibleItemId = if not FFlagAXMISWithOffers then nil else collectibleItemId
	t2.status = SOLD_OUT
	t2.priceInRobux = v38
	t2.name = name2
	t2.timedOptions = if not FFlagAXDurablesForMIS then nil else itemData.timedOptions
	t2.selectedTimedOptionDays = if not FFlagAXDurablesForMIS then nil else days
	t2.selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS then nil else t1.selectedTimedOptionIndex

	return t2
end
local function areCartItemsDifferent(t3: {[any]: any}, t4: {[any]: any}) -- line: 221
	-- upvalues: tutils (copy)
	if tutils.fieldCount(t3) ~= tutils.fieldCount(t4) then
		return true
	end

	for v54, _ in t4 do
		if t3[v54] == nil then
			return true
		end
	end

	return false
end
local function createAXShoppingCartStore() -- line: 236
	-- upvalues: createSignal (copy), FFlagAXMISWithBlackbird (copy), createComputed (copy), PurchaseItemsErrorStatusMap (copy), tutils (copy), getTryOnItemReducerKey (copy), getItemCartData (copy), Cryo (copy), FFlagAXDurablesForMIS (copy)
	local v56, v57 = createSignal({})
	local v58, v59 = createSignal(0)
	local u60 = nil
	local u61 = nil

	if FFlagAXMISWithBlackbird then
		local v62, v63 = createSignal({})

		u60 = v62
		u61 = v63
	end

	local v64 = createComputed(function(p2) -- line: 244
		-- upvalues: v58 (copy)
		return v58(p2)
	end)
	local v65 = if not FFlagAXMISWithBlackbird then nil else createComputed(function(p3) -- line: 249
		-- upvalues: u60 (ref)
		return u60(p3)
	end)
	local v66 = createComputed(function(p4) -- line: 254
		-- upvalues: v56 (copy), PurchaseItemsErrorStatusMap (copy)
		local t5 = {}

		for _, v76 in (v56(p4)) do
			table.insert(t5, v76)
		end

		table.sort(t5, function(p5, p6) -- line: 263
			-- upvalues: PurchaseItemsErrorStatusMap (copy)
			if p5.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED and p6.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				return false
			end

			if p6.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED and p5.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				return true
			end

			return p5.ordering > p6.ordering
		end)

		return t5
	end, tutils.deepEqual)
	local v67 = createComputed(function(p7) -- line: 281
		-- upvalues: v56 (copy), PurchaseItemsErrorStatusMap (copy), tutils (copy)
		local v78 = v56(p7)
		local n1 = 0

		for _, v81 in v78 do
			if v81.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				n1 += 1
			end

			if v81.status ~= nil and v81.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED and v81.status ~= PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
				return false
			end
		end

		if n1 == tutils.fieldCount(v78) then
			return false
		end

		return true
	end)
	local v68 = createComputed(function(p8) -- line: 315
		-- upvalues: v56 (copy), PurchaseItemsErrorStatusMap (copy)
		local n2 = 0

		for _, v85 in (v56(p8)) do
			if v85.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				n2 += v85.priceInRobux
			end
		end

		return n2
	end)
	local v69 = createComputed(function(p9) -- line: 327
		-- upvalues: v56 (copy), PurchaseItemsErrorStatusMap (copy)
		local n3 = 0

		for _, v89 in (v56(p9)) do
			if v89.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				if v89.discountInformation then
					if v89.selectedTimedOptionDays ~= nil and v89.timedOptions then
						local v90 = nil

						for _, v92 in v89.timedOptions do
							if v92.days == v89.selectedTimedOptionDays then
								v90 = v92

								break
							end
						end

						n3 = if not v90 or not v90.discountInformation then if not v90 or (v90.discountInformation or v90.days == 0) then n3 + v89.discountInformation.originalPrice else n3 + v90.price else n3 + v90.discountInformation.originalPrice
					else
						n3 += v89.discountInformation.originalPrice
					end
				else
					n3 += v89.priceInRobux
				end
			end
		end

		return n3
	end)

	local function updateItemPrice(s1: string, s2: string, n4: number, n5: number?) -- line: 452
		-- upvalues: FFlagAXDurablesForMIS (copy), v56 (copy), getTryOnItemReducerKey (copy), v57 (copy), Cryo (copy)
		if not FFlagAXDurablesForMIS then
			return
		end

		local v125 = v56(false)
		local v126 = getTryOnItemReducerKey(s1, s2)
		local v127 = v125[v126]

		if v127 and (n4 ~= v127.priceInRobux or n5 ~= v127.selectedTimedOptionDays) then
			v57(Cryo.Dictionary.join(v125, {
				[v126] = Cryo.Dictionary.join(v127, {
					priceInRobux = n4,
					selectedTimedOptionDays = if n5 ~= nil then n5 else Cryo.None
				})
			}))
		end
	end

	return {
		getCanPurchase = v67,
		getErroredItemCount = v64,
		getItems = v66,
		getDiscounts = if not FFlagAXMISWithBlackbird then nil else v65,
		getPurchasableItemsTotalPriceInRobux = v68,
		getPurchasableItemsTotalOriginalPriceInRobux = v69,
		syncFromTryOns = function(t6: {[any]: any}, b2: boolean?) -- line: 368
			-- upvalues: v56 (copy), getTryOnItemReducerKey (copy), getItemCartData (copy), Cryo (copy), FFlagAXMISWithBlackbird (copy), u61 (ref), tutils (copy), v57 (copy), v59 (copy)
			local v95 = v56(false)
			local t7 = {}
			local discounts = nil
			local g106 = nil
			local v103 = nil

			for _, v99 in t6 do
				local v100 = getTryOnItemReducerKey(v99.itemId, v99.itemType)
				local v101 = v95[v100]
				local v102 = getItemCartData(v99, b2)

				t7[v100] = if not v101 then v102 else Cryo.Dictionary.join(v101, v102)

				if FFlagAXMISWithBlackbird and v99.itemData and v99.itemData.discountInformation and not discounts then
					discounts = v99.itemData.discountInformation.discounts
				end
			end

			if FFlagAXMISWithBlackbird and discounts then
				u61(discounts)
			end

			if not tutils.deepEqual(v95, t7) then
				v57(t7)
			end

			if tutils.fieldCount(v95) ~= tutils.fieldCount(t7) then
				v103 = true
			else
				for v104, _ in t7 do
					if v95[v104] == nil then
						v103 = true
						g106 = true
					end

					if g106 then
						break
					end
				end

				if not g106 then
					v103 = false
				end
			end

			g106 = false

			if v103 then
				v59(0)
			end
		end,
		updateCartFromPurchaseResponse = function(p10) -- line: 402
			-- upvalues: v56 (copy), PurchaseItemsErrorStatusMap (copy), Cryo (copy), v57 (copy), v59 (copy)
			local v108 = v56(false)
			local t8 = {}
			local t9 = {}
			local t10 = {}
			local t11 = {}
			local n6 = 0
			local lineItems = p10.lineItems

			for v115, v116 in v108 do
				local v117 = lineItems[v115]
				local v118 = v116.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED

				if v117 and v117.status ~= "SUCCEEDED" and not v118 then
					local v119 = PurchaseItemsErrorStatusMap[v117.errorReason] or PurchaseItemsErrorStatusMap.UNKNOWN
					local t12 = nil

					if v119 == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
						t12 = {
							oldPriceInRobux = v116.priceInRobux
						}
						table.insert(t11, v116)
					end

					t8[v115] = Cryo.Dictionary.join(v116, {
						status = v119,
						priceMismatchMetadata = t12
					})
					n6 += 1
				else
					table.insert(t10, v116)

					if not v118 then
						table.insert(t9, v116)
					end
				end
			end

			v57(t8)
			v59(n6)

			return {
				boughtItems = t9,
				equippableItems = t10,
				needDataRefeshItems = t11
			}
		end,
		updateItemPrice = if not FFlagAXDurablesForMIS then nil else updateItemPrice
	}
end

return createAXShoppingCartStore
