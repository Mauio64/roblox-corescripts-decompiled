local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dKT")

local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dVl")

require("@luauforge/bundled/dKU")

require("@luauforge/bundled/dPq")
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dQB")
require("@luauforge/bundled/dQN")

require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Reducers/CollectibleResellableInstances")

local defineFastFlag = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)

local fIntBlackbirdUpsellMinPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntBlackbirdUpsellMinPriceForDiscountInclusive

local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local v5 = {}

function v5.getItemInfo(p2, p3, p4, p5)
	if not (p4 and p5) then
		return nil
	end

	local v6 = p4[p5]

	if not v6 then
		return nil
	end

	if p3 == module.ItemType.Asset then
		return v6.lookAssetInfos[p2]
	end

	if p3 ~= module.ItemType.Bundle then
		return nil
	end

	local lookBundleInfos = v6.lookBundleInfos

	if lookBundleInfos then
		return lookBundleInfos[p2]
	end

	return nil
end

function v5.getOwnedTryOnItems(items, p2, p3)
	local result = {}

	for k, item in items do
		if not item.selectedInTryOnManager then
			continue
		end

		local itemInfo = v5.getItemInfo(item.itemId, item.itemType, p2, p3)

		if itemInfo and itemInfo.quantityOwned > 0 then
			result[k] = item
		end
	end

	return result
end

function v5.getPriceForItem(data, p2, p3, p4, p5)
	local v6 = data.priceInRobux

	if p5 and data.timedOptions then
		local timedOption = data.timedOptions[p5]

		if timedOption then
			v6 = timedOption.price
		end
	end

	if data.collectibleItemId then
		local cheapestCollectiblePurchaseInfoV2 = module2.findCheapestCollectiblePurchaseInfoV2(
			data.collectibleItemId,
			module2.IsResellable(data),
			p2,
			p3,
			p4
		)

		if cheapestCollectiblePurchaseInfoV2.price then
			v6 = cheapestCollectiblePurchaseInfoV2.price
		end
	end

	return v6
end

function v5.getBottomBarInfoMIS(items, p2, p3, p4, p5, p6, items2)
	local count = 0
	local count2 = 0
	local total = 0
	local total2 = 0
	local v6 = false
	local result = {}
	local v7 = false
	local v8 = false

	if p6 then
		for k, item in items do
			count += 1

			local itemInfo = v5.getItemInfo(item.id, item.itemType, p5, p6)

			if itemInfo then
				if not (itemInfo and itemInfo.quantityOwned and itemInfo.quantityOwned > 0) then
					local selectedTimedOptionIndex = nil
					local v9 = nil

					if items2 then
						for k2, item2 in items2 do
							if item2.itemId == item.id and item2.itemType == item.itemType then
								selectedTimedOptionIndex = item2.selectedTimedOptionIndex
								v9 = item2
								break
							end
						end
					end

					local priceForItem = v5.getPriceForItem(itemInfo, p2, p3, p4, selectedTimedOptionIndex)

					if priceForItem ~= nil then
						total += priceForItem
						count2 += 1
						local v10

						if itemInfo and itemInfo.discountInformation then
							v10 = itemInfo.discountInformation.originalPrice
						else
							v10 = priceForItem
						end

						local v11 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive
						local v12 = v10 <= fIntBlackbirdUpsellMinPriceForDiscountInclusive
							or not (v11 == 0) and v11 <= v10

						if itemInfo and itemInfo.discountInformation and not v12 then
							v7 = true
						else
							v8 = true
						end

						if itemInfo and itemInfo.discountInformation then
							total2 += itemInfo.discountInformation.originalPrice
						else
							total2 += priceForItem
						end

						if v9 then
							result[item.id] = Cryo.Dictionary.join(v9, {
								expectedPrice = priceForItem
							})
						end
					end
				end
			elseif not v6 then
				v6 = true
			end
		end

		if defineFastFlag then
			return total, count, count2, v6, result, total2, v7 and v8
		end

		return total, count, count2, v6, result, total2, nil
	else
		local v9 = nil

		if defineFastFlag then
			return total, count, count2, false, v9, total2, false
		end

		return total, count, count2, v6, v9, total2, nil
	end
end

function v5.getOwnedItemsInLook(items, p2, p3)
	local result = {}

	for k, item in items do
		local v6 = if item.itemType then v5.getItemInfo(item.id, item.itemType, p2, p3) else nil

		if v6 and v6.quantityOwned > 0 then
			result[k] = item
		end
	end

	return result
end

return v5
