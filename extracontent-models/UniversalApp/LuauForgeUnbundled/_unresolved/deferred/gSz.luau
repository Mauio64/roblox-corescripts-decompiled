local module = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPq")
require("@luauforge/bundled/dPs")
require("@luauforge/deferred/fCO")

local fFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks

local function getSelectedTimedOptionDays(p2, p3)
	if p3.selectedTimedOptionIndex and p2.timedOptions then
		local timedOption = p2.timedOptions[p3.selectedTimedOptionIndex]

		if timedOption and timedOption.days then
			return timedOption.days
		end
	end

	return nil
end

local function isBlockyLookItem(p2): boolean
	return p2.itemId == tostring(module.BlockyBundleId)
end

local function shouldExcludeLookItem(p2, p3): boolean
	return not (p2.selectedInTryOnManager and p3.isPurchasable) or p3.quantityOwned > 0
end

local function getLookItemInfo(p2, p3)
	local lookAssetInfo = p2.lookAssetInfos[tostring(p3.itemId)]
	local v5 = (p2.lookBundleInfos or {})[tostring(p3.itemId)]
	return lookAssetInfo or v5
end

local function getCartPricingRequestedItemsForLookId(items, p2, p3)
	local cartPricingRequestedItemsForLookId = {}
	local set = {}
	local v5 = p2[p3]

	if items == nil or v5 == nil then
		return cartPricingRequestedItemsForLookId
	end

	for k, item in items do
		local lookAssetInfo = v5.lookAssetInfos[tostring(item.itemId)]
		local v6 = (v5.lookBundleInfos or {})[tostring(item.itemId)]
		local v7 = lookAssetInfo or v6

		if not (v7 ~= nil and item.itemId ~= tostring(module.BlockyBundleId) and item.selectedInTryOnManager and v7.isPurchasable) then
			continue
		end

		if v7.quantityOwned > 0 then
			continue
		end

		local collectibleItemId = v7.collectibleItemId

		if not (type(collectibleItemId) == "string" and collectibleItemId ~= "") then
			continue
		end

		local days

		if item.selectedTimedOptionIndex and v7.timedOptions then
			local timedOption = v7.timedOptions[item.selectedTimedOptionIndex]

			if timedOption and timedOption.days then
				days = timedOption.days
			end
		end

		local v8 = collectibleItemId .. "\0" .. ((type(days) ~= "number" or not (days > 0)) and "perm" or tostring(days))

		if set[v8] then
			continue
		end

		set[v8] = true
		table.insert(cartPricingRequestedItemsForLookId, {
			collectibleItemId = collectibleItemId,
			rentalDays = days
		})
	end

	return cartPricingRequestedItemsForLookId
end

local function getPurchaseLineItemsForLookId(items, p2, p3, p4)
	local purchaseLineItemsForLookId = {}
	local v5 = p2[p3]

	if items == nil or v5 == nil or p4 == nil then
		return purchaseLineItemsForLookId
	end

	for k, item in items do
		local lookAssetInfo = v5.lookAssetInfos[tostring(item.itemId)]
		local v6 = (v5.lookBundleInfos or {})[tostring(item.itemId)]
		local v7 = lookAssetInfo or v6

		if not (v7 ~= nil and item.itemId ~= tostring(module.BlockyBundleId) and item.selectedInTryOnManager and v7.isPurchasable) then
			continue
		end

		if v7.quantityOwned > 0 then
			continue
		end

		local collectibleItemId = v7.collectibleItemId
		local v8 = if collectibleItemId then p4[collectibleItemId] else nil
		local collectibleProductId = if v8 then v8.collectibleProductId else nil

		if not (collectibleItemId ~= nil and collectibleProductId ~= nil) then
			continue
		end

		local v9 = v7.priceInRobux or 0
		local days

		if item.selectedTimedOptionIndex and v7.timedOptions then
			local timedOption = v7.timedOptions[item.selectedTimedOptionIndex]

			if timedOption and timedOption.days then
				days = timedOption.days
			end
		end

		v9 = days and v7.timedOptions and v7.timedOptions[item.selectedTimedOptionIndex].price or v9

		table.insert(purchaseLineItemsForLookId, {
			itemType = item.itemType,
			itemId = tostring(item.itemId),
			collectibleItemId = collectibleItemId,
			collectibleProductId = collectibleProductId,
			agreedPriceRobux = v9,
			rentalDays = days
		})
	end

	return purchaseLineItemsForLookId
end

local v5 = {
	getPurchaseInfoForLookId = function(items, p2, p3)
		local itemIds = {}
		local itemIds2 = {}

		local itemIds3 = {}
		local result = {}
		local total = 0

		local v6 = p2[p3]

		if items == nil or v6 == nil then
			return total, itemIds, itemIds2, itemIds3
		end

		for k, item in items do
			local lookAssetInfo = v6.lookAssetInfos[tostring(item.itemId)]
			local v7 = (v6.lookBundleInfos or {})[tostring(item.itemId)]
			local v8 = lookAssetInfo or v7

			if not v8 then
				continue
			end

			if fFlagPurchasePromptFetchCartPricingForLooks then
				local lookAssetInfo2 = v6.lookAssetInfos[tostring(item.itemId)]
				local v9 = (v6.lookBundleInfos or {})[tostring(item.itemId)]
				v8 = lookAssetInfo2 or v9
			end

			if not ((not fFlagPurchasePromptFetchCartPricingForLooks or item.itemId ~= tostring(module.BlockyBundleId)) and (fFlagPurchasePromptFetchCartPricingForLooks or item.itemId ~= tostring(module.BlockyBundleId))) then
				continue
			end

			if
				fFlagPurchasePromptFetchCartPricingForLooks
				and (not item.selectedInTryOnManager or not v8.isPurchasable or v8.quantityOwned > 0)
				or not fFlagPurchasePromptFetchCartPricingForLooks
				and (not item.selectedInTryOnManager or not v8.isPurchasable or v8.quantityOwned > 0)
			then
				if item.itemType == module.ItemType.Bundle then
					table.insert(itemIds2, item.itemId)
				elseif item.itemType == module.ItemType.Asset then
					table.insert(itemIds, item.itemId)
				end
			else
				local v9 = v8.priceInRobux

				if item.selectedTimedOptionIndex and v8.timedOptions then
					local timedOption = v8.timedOptions[item.selectedTimedOptionIndex]

					if timedOption and timedOption.days then
						table.insert(result, {
							itemType = item.itemType,
							itemId = item.itemId,
							days = timedOption.days
						})

						v9 = timedOption.price
					end
				end

				total += v9
				table.insert(itemIds3, (tonumber(item.itemId)))
			end
		end

		if #result > 0 then
			return total, itemIds, itemIds2, itemIds3, result
		end

		return total, itemIds, itemIds2, itemIds3, nil
	end,
	getPurchaseLineItemsForLookId = 0,
	getCartPricingRequestedItemsForLookId = 0
}

if not fFlagPurchasePromptFetchCartPricingForLooks then
	getPurchaseLineItemsForLookId = nil
end

v5.getPurchaseLineItemsForLookId = getPurchaseLineItemsForLookId

if not fFlagPurchasePromptFetchCartPricingForLooks then
	getCartPricingRequestedItemsForLookId = nil
end

v5.getCartPricingRequestedItemsForLookId = getCartPricingRequestedItemsForLookId
return v5
