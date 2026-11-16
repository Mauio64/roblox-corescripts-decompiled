local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent
local Signals = require(parent.Signals)
local tutils = require(parent.tutils)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local PurchaseItemsErrorStatusMap = require(AvatarExperienceCatalog.Enums.PurchaseItemsErrorStatusMap)
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local UIBlox = require(parent.UIBlox)
local ItemTileEnums = UIBlox.Tile.ItemTileEnums

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local Constants = AvatarExperienceCommon.Constants

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local getItemPurchaseActionType = AvatarExperienceCommon.Utils.getItemPurchaseActionType
local ItemPurchaseActionTypeEnum = AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum

local function getItemRestrictionFromItemData(itemData): nil | string -- 1 equivalent call inferred from this helper
	local tileRestrictionsMap

	if itemData then
		tileRestrictionsMap = itemData.tileRestrictionsMap
	end

	if not tileRestrictionsMap then
		return nil
	end

	if tileRestrictionsMap[ItemTileEnums.Restriction.Limited] then
		return "Limited"
	end

	if
		tileRestrictionsMap[ItemTileEnums.Restriction.LimitedUnique]
		or tileRestrictionsMap[ItemTileEnums.Restriction.Collectible]
	then
		return "Collectible"
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

local function getItemCartData(item, flag: boolean?)
	if item.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
		return {
			itemId = item.itemId,
			collectibleItemId = FFlagAXMISWithOffers and "n/a" or nil,
			itemType = item.itemType,
			itemSubType = "1",
			ordering = item.ordering,
			creatorName = not FFlagAXMISSmallUIChanges and "Roblox" or nil,
			creatorVerified = not FFlagAXMISSmallUIChanges or nil,
			collectibleProductId = item.itemId,
			status = PurchaseItemsErrorStatusMap.ALREADY_OWNED,
			priceInRobux = 0,
			name = "Default Body",
			isOwned = true
		}
	end

	local itemData = item.itemData
	local collectibleItemId = item.collectibleItemId
	local collectibleItemInfo = item.collectibleItemInfo
	local resellableInstances = item.resellableInstances

	local itemPurchaseActionType = getItemPurchaseActionType(
		itemData,
		collectibleItemInfo,
		not resellableInstances and 0 or tutils.fieldCount(resellableInstances),
		not (flag and collectibleItemId)
	)

	local v = itemPurchaseActionType == ItemPurchaseActionTypeEnum.PurchaseFromResale
	local priceInRobux

	if v then
		priceInRobux = itemData.lowestResalePrice
	else
		priceInRobux = itemData.priceInRobux
	end

	local collectibleProductId

	if collectibleItemInfo then
		if v then
			collectibleProductId = collectibleItemInfo.lowestAvailableResaleProductId
		else
			collectibleProductId = collectibleItemInfo.collectibleProductId
		end
	end

	local itemSubType

	if item.itemType == Enum.AvatarItemType.Asset.Name then
		itemSubType = itemData.assetType
	else
		itemSubType = itemData.bundleType
	end

	local creator = itemData.creator or {}
	local name = creator.name
	local hasVerifiedBadge = creator.hasVerifiedBadge
	local name2 = itemData.name

	local status = nil

	if itemPurchaseActionType == ItemPurchaseActionTypeEnum.SoldOut then
		status = PurchaseItemsErrorStatusMap.SOLD_OUT
	elseif itemPurchaseActionType == ItemPurchaseActionTypeEnum.CustomizeLink then
		status = PurchaseItemsErrorStatusMap.ALREADY_OWNED
	elseif itemPurchaseActionType == ItemPurchaseActionTypeEnum.ExperienceLink then
		status = PurchaseItemsErrorStatusMap.EXPERIENCE_LINK
	elseif itemPurchaseActionType == ItemPurchaseActionTypeEnum.Disabled then
		status = PurchaseItemsErrorStatusMap.NOT_FOR_SALE
	elseif itemPurchaseActionType == ItemPurchaseActionTypeEnum.QuantityLimitExceeded then
		status = PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED
	end

	local days = nil

	if FFlagAXDurablesForMIS and itemData.timedOptions then
		if item.selectedTimedOptionIndex == nil then
			for _, timedOption in itemData.timedOptions do
				if timedOption.selected then
					days = timedOption.days
					priceInRobux = timedOption.price
					break
				end
			end
		else
			local timedOption = itemData.timedOptions[item.selectedTimedOptionIndex]

			if timedOption then
				days = timedOption.days
				priceInRobux = timedOption.price
			end
		end
	end

	local v2 = {
		itemId = item.itemId,
		itemType = item.itemType,
		expirationTime = itemData.expirationTime,
		isOwned = itemData.isOwned,
		discountInformation = itemData.discountInformation,
		itemSubType = itemSubType,
		itemRestriction = getItemRestrictionFromItemData(itemData), -- inferred equivalent call
		ordering = item.ordering,
		creatorName = 0,
		creatorVerified = 0,
		collectibleProductId = 0,
		collectibleItemId = 0,
		status = 0,
		priceInRobux = 0,
		name = 0,
		timedOptions = 0,
		selectedTimedOptionDays = 0,
		selectedTimedOptionIndexInReducer = 0
	}

	if FFlagAXMISSmallUIChanges then
		name = nil
	end

	v2.creatorName = name

	if FFlagAXMISSmallUIChanges then
		hasVerifiedBadge = nil
	end

	v2.creatorVerified = hasVerifiedBadge
	v2.collectibleProductId = collectibleProductId

	if not (FFlagAXMISWithOffers or FFlagAXGifting) then
		collectibleItemId = nil
	end

	v2.collectibleItemId = collectibleItemId
	v2.status = status
	v2.priceInRobux = priceInRobux
	v2.name = name2
	local timedOptions

	if FFlagAXDurablesForMIS then
		timedOptions = itemData.timedOptions
	end

	v2.timedOptions = timedOptions

	if not FFlagAXDurablesForMIS then
		days = nil
	end

	v2.selectedTimedOptionDays = days
	local selectedTimedOptionIndexInReducer

	if FFlagAXDurablesForMIS then
		selectedTimedOptionIndexInReducer = item.selectedTimedOptionIndex
	end

	v2.selectedTimedOptionIndexInReducer = selectedTimedOptionIndexInReducer
	return v2
end

local function areCartItemsDifferent(p, itemCartDatasByTryOnItemReducerKey): boolean -- 1 equivalent call inferred from this helper
	if tutils.fieldCount(p) ~= tutils.fieldCount(itemCartDatasByTryOnItemReducerKey) then
		return true
	end

	for k, _ in itemCartDatasByTryOnItemReducerKey do
		if p[k] == nil then
			return true
		end
	end

	return false
end

local function createAXShoppingCartStore()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal(0)
	local v3, v4

	if FFlagAXMISWithBlackbird then
		v3, v4 = createSignal({})
	else
		v3 = nil
		v4 = nil
	end

	local getErroredItemCount = createComputed(function(p)
		return signal2(p)
	end)
	local getDiscounts

	if FFlagAXMISWithBlackbird then
		getDiscounts = createComputed(function(p)
			return v3(p)
		end)
	end

	local getItems = createComputed(function(p)
		local v5 = signal(p)
		local result = {}

		for _, v6 in v5 do
			table.insert(result, v6)
		end

		table.sort(result, function(a, b): boolean
			if
				a.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED
				and b.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED
			then
				return false
			end

			if
				b.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED
				and a.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED
			then
				return true
			end

			return a.ordering > b.ordering
		end)

		return result
	end, tutils.deepEqual)

	local getCanPurchase = createComputed(function(p): boolean
		local v5 = signal(p)
		local count = 0

		for _, v6 in v5 do
			if v6.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				count += 1
			end

			if
				v6.status ~= nil
				and v6.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED
				and v6.status ~= PurchaseItemsErrorStatusMap.PRICE_MISMATCH
			then
				return false
			end
		end

		return count ~= tutils.fieldCount(v5)
	end)

	local getPurchasableItemsTotalPriceInRobux = createComputed(function(p)
		local v5 = signal(p)
		local total = 0

		for _, v6 in v5 do
			if v6.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				total += v6.priceInRobux
			end
		end

		return total
	end)

	local getPurchasableItemsTotalOriginalPriceInRobux = createComputed(function(p)
		local v5 = signal(p)
		local total = 0

		for _, v6 in v5 do
			if v6.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				continue
			end

			if v6.discountInformation then
				if v6.selectedTimedOptionDays == nil or not v6.timedOptions then
					total += v6.discountInformation.originalPrice
				else
					local v7 = nil

					for _, timedOption in v6.timedOptions do
						if timedOption.days == v6.selectedTimedOptionDays then
							v7 = timedOption
							break
						end
					end

					if v7 and v7.discountInformation then
						total += v7.discountInformation.originalPrice
					elseif v7 and not v7.discountInformation and v7.days ~= 0 then
						total += v7.price
					else
						total += v6.discountInformation.originalPrice
					end
				end
			else
				total += v6.priceInRobux
			end
		end

		return total
	end)

	local function syncFromTryOns(items, flag: boolean?)
		local v5 = signal(false)
		local itemCartDatasByTryOnItemReducerKey = {}
		local discounts = nil

		for _, item in items do
			local tryOnItemReducerKey = getTryOnItemReducerKey(item.itemId, item.itemType)
			local v6 = v5[tryOnItemReducerKey]
			local itemCartData = getItemCartData(item, flag)

			if v6 then
				itemCartData = Cryo.Dictionary.join(v6, itemCartData)
			end

			itemCartDatasByTryOnItemReducerKey[tryOnItemReducerKey] = itemCartData

			if
				not FFlagAXMISWithBlackbird
				or not item.itemData
				or not item.itemData.discountInformation
				or discounts
			then
				continue
			end

			discounts = item.itemData.discountInformation.discounts
		end

		if FFlagAXMISWithBlackbird and discounts then
			v4(discounts)
		end

		if not tutils.deepEqual(v5, itemCartDatasByTryOnItemReducerKey) then
			v(itemCartDatasByTryOnItemReducerKey)
		end

		if areCartItemsDifferent(v5, itemCartDatasByTryOnItemReducerKey) then -- inferred equivalent call
			v2(0)
		end
	end

	local function updateCartFromPurchaseResponse(p)
		local v5 = signal(false)

		local lineItems = p.lineItems
		local equippableItems = {}
		local boughtItems = {}

		local needDataRefeshItems = {}
		local values = {}
		local count = 0

		for k, v6 in v5 do
			local lineItem = lineItems[k]
			local v7 = v6.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED

			if lineItem and lineItem.status ~= "SUCCEEDED" and not v7 then
				local status = PurchaseItemsErrorStatusMap[lineItem.errorReason] or PurchaseItemsErrorStatusMap.UNKNOWN
				local priceMismatchMetadata

				if status == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
					priceMismatchMetadata = { oldPriceInRobux = v6.priceInRobux }

					table.insert(needDataRefeshItems, v6)
				end

				values[k] = Cryo.Dictionary.join(v6, {
					status = status,
					priceMismatchMetadata = priceMismatchMetadata
				})
				count += 1
			else
				table.insert(equippableItems, v6)

				if not v7 then
					table.insert(boughtItems, v6)
				end
			end
		end

		v(values)
		v2(count)

		return {
			boughtItems = boughtItems,
			equippableItems = equippableItems,
			needDataRefeshItems = needDataRefeshItems
		}
	end

	local function updateItemPrice(p: string, p2: string, priceInRobux: number, selectedTimedOptionDays: number?)
		if not FFlagAXDurablesForMIS then
			return
		end

		local v5 = signal(false)
		local tryOnItemReducerKey = getTryOnItemReducerKey(p, p2)
		local v6 = v5[tryOnItemReducerKey]

		if v6 and (v6.priceInRobux ~= priceInRobux or v6.selectedTimedOptionDays ~= selectedTimedOptionDays) then
			local join = Cryo.Dictionary.join
			local join2 = Cryo.Dictionary.join

			if selectedTimedOptionDays == nil then
				selectedTimedOptionDays = Cryo.None
			end

			v(join(v5, {
				[tryOnItemReducerKey] = join2(v6, {
					priceInRobux = priceInRobux,
					selectedTimedOptionDays = selectedTimedOptionDays
				})
			}))
		end
	end

	if not FFlagAXMISWithBlackbird then
		getDiscounts = nil
	end

	if not FFlagAXDurablesForMIS then
		updateItemPrice = nil
	end

	return {
		getCanPurchase = getCanPurchase,
		getErroredItemCount = getErroredItemCount,
		getItems = getItems,
		getDiscounts = getDiscounts,
		getPurchasableItemsTotalPriceInRobux = getPurchasableItemsTotalPriceInRobux,
		getPurchasableItemsTotalOriginalPriceInRobux = getPurchasableItemsTotalOriginalPriceInRobux,
		syncFromTryOns = syncFromTryOns,
		updateCartFromPurchaseResponse = updateCartFromPurchaseResponse,
		updateItemPrice = updateItemPrice
	}
end

return createAXShoppingCartStore
