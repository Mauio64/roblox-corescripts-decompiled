local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local PurchaseItemsErrorStatusMap = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Enums/PurchaseItemsErrorStatusMap")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local itemTileEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/UIBlox").Tile.ItemTileEnums

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local constants = AvatarExperienceCommon.Constants

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagAXMISSmallUIChanges = AvatarExperienceFlags.FFlagAXMISSmallUIChanges
local fFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local getItemPurchaseActionType = AvatarExperienceCommon.Utils.getItemPurchaseActionType
local itemPurchaseActionTypeEnum = AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum

local function getItemRestrictionFromItemData(p2): nil | string
	local tileRestrictionsMap = if p2 then p2.tileRestrictionsMap else nil

	if not tileRestrictionsMap then
		return nil
	end

	if tileRestrictionsMap[itemTileEnums.Restriction.Limited] then
		return "Limited"
	end

	if
		tileRestrictionsMap[itemTileEnums.Restriction.LimitedUnique]
		or tileRestrictionsMap[itemTileEnums.Restriction.Collectible]
	then
		return "Collectible"
	end

	return nil
end

local v5 = {
	UNKNOWN = "UNKNOWN",
	PENDING = "PENDING",
	RESERVED = "RESERVED",
	SUCCEEDED = "SUCCEEDED",
	FAILED = "FAILED"
}

local function getItemCartData(item, p2)
	if item.itemId == constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
		return {
			itemId = item.itemId,
			collectibleItemId = fFlagAXMISWithOffers and "n/a" or nil,
			itemType = item.itemType,
			itemSubType = "1",
			ordering = item.ordering,
			creatorName = not fFlagAXMISSmallUIChanges and "Roblox" or nil,
			creatorVerified = not fFlagAXMISSmallUIChanges or nil,
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
		not (p2 and collectibleItemId)
	)

	local v7 = itemPurchaseActionType == itemPurchaseActionTypeEnum.PurchaseFromResale
	local v8 = if v7 then itemData.lowestResalePrice else itemData.priceInRobux
	local v9

	if collectibleItemInfo then
		if v7 then
			v9 = collectibleItemInfo.lowestAvailableResaleProductId
		else
			v9 = collectibleItemInfo.collectibleProductId
		end
	end

	local v10

	if item.itemType == Enum.AvatarItemType.Asset.Name then
		v10 = itemData.assetType
	else
		v10 = itemData.bundleType
	end

	local creator = itemData.creator or {}
	local name = creator.name
	local hasVerifiedBadge = creator.hasVerifiedBadge
	local name2 = itemData.name

	local v11 = nil

	if itemPurchaseActionType == itemPurchaseActionTypeEnum.SoldOut then
		v11 = PurchaseItemsErrorStatusMap.SOLD_OUT
	elseif itemPurchaseActionType == itemPurchaseActionTypeEnum.CustomizeLink then
		v11 = PurchaseItemsErrorStatusMap.ALREADY_OWNED
	elseif itemPurchaseActionType == itemPurchaseActionTypeEnum.ExperienceLink then
		v11 = PurchaseItemsErrorStatusMap.EXPERIENCE_LINK
	elseif itemPurchaseActionType == itemPurchaseActionTypeEnum.Disabled then
		v11 = PurchaseItemsErrorStatusMap.NOT_FOR_SALE
	elseif itemPurchaseActionType == itemPurchaseActionTypeEnum.QuantityLimitExceeded then
		v11 = PurchaseItemsErrorStatusMap.QUANTITY_LIMIT_EXCEEDED
	end

	local days = nil

	if fFlagAXDurablesForMIS and itemData.timedOptions then
		if item.selectedTimedOptionIndex == nil then
			for k, timedOption in itemData.timedOptions do
				if timedOption.selected then
					days = timedOption.days
					v8 = timedOption.price
					break
				end
			end
		else
			local timedOption = itemData.timedOptions[item.selectedTimedOptionIndex]

			if timedOption then
				days = timedOption.days
				v8 = timedOption.price
			end
		end
	end

	local v12 = {
		itemId = item.itemId,
		itemType = item.itemType,
		expirationTime = itemData.expirationTime,
		isOwned = itemData.isOwned,
		discountInformation = itemData.discountInformation,
		itemSubType = v10,
		itemRestriction = 0,
		ordering = 0,
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
	local tileRestrictionsMap = if itemData then itemData.tileRestrictionsMap else nil

	local v13 = if tileRestrictionsMap then tileRestrictionsMap[itemTileEnums.Restriction.Limited] and "Limited" or (tileRestrictionsMap[itemTileEnums.Restriction.LimitedUnique] or tileRestrictionsMap[itemTileEnums.Restriction.Collectible]) and "Collectible" or nil else nil

	v12.itemRestriction = v13
	v12.ordering = item.ordering

	if fFlagAXMISSmallUIChanges then
		name = nil
	end

	v12.creatorName = name

	if fFlagAXMISSmallUIChanges then
		hasVerifiedBadge = nil
	end

	v12.creatorVerified = hasVerifiedBadge
	v12.collectibleProductId = v9

	if not (fFlagAXMISWithOffers or fFlagAXGifting) then
		collectibleItemId = nil
	end

	v12.collectibleItemId = collectibleItemId
	v12.status = v11
	v12.priceInRobux = v8
	v12.name = name2
	local v14 = if fFlagAXDurablesForMIS then itemData.timedOptions else nil
	v12.timedOptions = v14

	if not fFlagAXDurablesForMIS then
		days = nil
	end

	v12.selectedTimedOptionDays = days
	local v15 = if fFlagAXDurablesForMIS then item.selectedTimedOptionIndex else nil
	v12.selectedTimedOptionIndexInReducer = v15
	return v12
end

local function areCartItemsDifferent(p2, items): boolean
	if tutils.fieldCount(p2) ~= tutils.fieldCount(items) then
		return true
	end

	for k, item in items do
		if p2[k] == nil then
			return true
		end
	end

	return false
end

local function createAXShoppingCartStore()
	local signal, v6 = createSignal({})
	local signal2, v7 = createSignal(0)
	local v8, v9

	if fFlagAXMISWithBlackbird then
		v8, v9 = createSignal({})
	else
		v8 = nil
		v9 = nil
	end

	local computed = createComputed(function(p2)
		return signal2(p2)
	end)
	local v10

	if fFlagAXMISWithBlackbird then
		v10 = createComputed(function(p2)
			return v8(p2)
		end)
	end

	local computed2 = createComputed(function(p2)
		local v11 = signal(p2)
		local result = {}

		for k, v12 in v11 do
			table.insert(result, v12)
		end

		table.sort(result, function(a, b): boolean
			if a.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED and b.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				return false
			end

			if b.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED and a.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				return true
			end

			return a.ordering > b.ordering
		end)

		return result
	end, tutils.deepEqual)

	local computed3 = createComputed(function(p2): boolean
		local v11 = signal(p2)
		local count = 0

		for k, v12 in v11 do
			if v12.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				count += 1
			end

			if
				v12.status ~= nil
				and v12.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED
				and v12.status ~= PurchaseItemsErrorStatusMap.PRICE_MISMATCH
			then
				return false
			end
		end

		return count ~= tutils.fieldCount(v11)
	end)

	local computed4 = createComputed(function(p2)
		local v11 = signal(p2)
		local total = 0

		for k, v12 in v11 do
			if v12.status ~= PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				total += v12.priceInRobux
			end
		end

		return total
	end)

	local computed5 = createComputed(function(p2)
		local v11 = signal(p2)
		local total = 0

		for k, v12 in v11 do
			if v12.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED then
				continue
			end

			if v12.discountInformation then
				if v12.selectedTimedOptionDays == nil or not v12.timedOptions then
					total += v12.discountInformation.originalPrice
				else
					local v13 = nil

					for k2, timedOption in v12.timedOptions do
						if timedOption.days == v12.selectedTimedOptionDays then
							v13 = timedOption
							break
						end
					end

					if v13 and v13.discountInformation then
						total += v13.discountInformation.originalPrice
					elseif v13 and not v13.discountInformation and v13.days ~= 0 then
						total += v13.price
					else
						total += v12.discountInformation.originalPrice
					end
				end
			else
				total += v12.priceInRobux
			end
		end

		return total
	end)

	local function syncFromTryOns(items, p2)
		local v11 = signal(false)
		local itemCartDatasByTryOnItemReducerKey = {}
		local discounts = nil

		for k, item in items do
			local tryOnItemReducerKey = getTryOnItemReducerKey(item.itemId, item.itemType)
			local v12 = v11[tryOnItemReducerKey]
			local itemCartData = getItemCartData(item, p2)

			if v12 then
				itemCartData = Cryo.Dictionary.join(v12, itemCartData)
			end

			itemCartDatasByTryOnItemReducerKey[tryOnItemReducerKey] = itemCartData

			if
				not fFlagAXMISWithBlackbird
				or not item.itemData
				or not item.itemData.discountInformation
				or discounts
			then
				continue
			end

			discounts = item.itemData.discountInformation.discounts
		end

		if fFlagAXMISWithBlackbird and discounts then
			v9(discounts)
		end

		if not tutils.deepEqual(v11, itemCartDatasByTryOnItemReducerKey) then
			v6(itemCartDatasByTryOnItemReducerKey)
		end

		local flag

		if tutils.fieldCount(v11) == tutils.fieldCount(itemCartDatasByTryOnItemReducerKey) then
			local flag2 = true

			for k, v12 in itemCartDatasByTryOnItemReducerKey do
				if v11[k] == nil then
					flag = true
					flag2 = false
					break
				end
			end

			if flag2 then
				flag = false
			end
		else
			flag = true
		end

		if flag then
			v7(0)
		end
	end

	local function updateCartFromPurchaseResponse(p2)
		local v11 = signal(false)

		local lineItems = p2.lineItems
		local v12 = {}
		local v13 = {}

		local v14 = {}
		local values = {}
		local count = 0

		for k, v15 in v11 do
			local lineItem = lineItems[k]
			local v16 = v15.status == PurchaseItemsErrorStatusMap.ALREADY_OWNED

			if lineItem and lineItem.status ~= "SUCCEEDED" and not v16 then
				local v17 = PurchaseItemsErrorStatusMap[lineItem.errorReason] or PurchaseItemsErrorStatusMap.UNKNOWN
				local v18

				if v17 == PurchaseItemsErrorStatusMap.PRICE_MISMATCH then
					v18 = { oldPriceInRobux = v15.priceInRobux }

					table.insert(v14, v15)
				end

				values[k] = Cryo.Dictionary.join(v15, {
					status = v17,
					priceMismatchMetadata = v18
				})
				count += 1
			else
				table.insert(v12, v15)

				if not v16 then
					table.insert(v13, v15)
				end
			end
		end

		v6(values)
		v7(count)

		return { boughtItems = v13, equippableItems = v12, needDataRefeshItems = v14 }
	end

	local function updateItemPrice(p2, p3, p4, selectedTimedOptionDays)
		if not fFlagAXDurablesForMIS then
			return
		end

		local v11 = signal(false)
		local tryOnItemReducerKey = getTryOnItemReducerKey(p2, p3)
		local v12 = v11[tryOnItemReducerKey]

		if v12 and (v12.priceInRobux ~= p4 or v12.selectedTimedOptionDays ~= selectedTimedOptionDays) then
			local join = Cryo.Dictionary.join
			local join2 = Cryo.Dictionary.join

			if selectedTimedOptionDays == nil then
				selectedTimedOptionDays = Cryo.None
			end

			v6(join(v11, {
				[tryOnItemReducerKey] = join2(v12, {
					priceInRobux = p4,
					selectedTimedOptionDays = selectedTimedOptionDays
				})
			}))
		end
	end

	if not fFlagAXMISWithBlackbird then
		v10 = nil
	end

	if not fFlagAXDurablesForMIS then
		updateItemPrice = nil
	end

	return {
		getCanPurchase = computed3,
		getErroredItemCount = computed,
		getItems = computed2,
		getDiscounts = v10,
		getPurchasableItemsTotalPriceInRobux = computed4,
		getPurchasableItemsTotalOriginalPriceInRobux = computed5,
		syncFromTryOns = syncFromTryOns,
		updateCartFromPurchaseResponse = updateCartFromPurchaseResponse,
		updateItemPrice = updateItemPrice
	}
end

return createAXShoppingCartStore
