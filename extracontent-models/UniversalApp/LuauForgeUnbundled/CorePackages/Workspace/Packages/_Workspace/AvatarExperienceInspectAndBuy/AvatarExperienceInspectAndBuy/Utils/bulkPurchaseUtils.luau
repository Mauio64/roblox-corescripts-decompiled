local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel").Enums.ItemTypeEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local convertAssetInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertAssetInfoToItemData")
local convertBundleInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertBundleInfoToItemData")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local getPriceInRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").getPriceInRobux
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Stores/createItemSelectionStore")

local function createBulkPurchaseRequestItem(p2)
	local bulkPurchaseRequestItem = {
		id = p2.id and tonumber(p2.id) or 0,
		itemType = 0
	}

	local v5 = if p2.itemType == itemTypeEnum.Asset then Enum.AvatarItemType.Asset.Value else Enum.AvatarItemType.Bundle.Value
	bulkPurchaseRequestItem.itemType = v5
	return bulkPurchaseRequestItem
end

return {
	convertAvatarItemToItemData = function(p2, p3)
		if p2.itemType == itemTypeEnum.Asset then
			local asset = p3.assets[p2.id]

			if asset then
				return convertAssetInfoToItemData(asset)
			end

			return nil
		else
			if p2.itemType ~= itemTypeEnum.Bundle then
				return nil
			end

			local bundle = p3.bundles[p2.id]

			if bundle then
				return convertBundleInfoToItemData(bundle)
			end

			return nil
		end
	end,
	isPurchasableItem = function(p2): boolean
		return p2 == PriceStatus.Free or p2 == PriceStatus.PurchaseFromRoblox or p2 == PriceStatus.PurchaseFromResale
	end,
	createBulkPurchaseRequestItem = createBulkPurchaseRequestItem,
	getBulkPurchaseEligibleItems = function(items, p2, p3)
		if not items then
			return { requestedItems = {}, totalPrice = 0 }
		end

		local v5 = {}
		local total = 0

		for k, item in items do
			local v6

			if item.itemType == itemTypeEnum.Asset then
				local asset = p2.assets[item.id]

				if asset then
					v6 = convertAssetInfoToItemData(asset)
				end
			elseif item.itemType == itemTypeEnum.Bundle then
				local bundle = p2.bundles[item.id]

				if bundle then
					v6 = convertBundleInfoToItemData(bundle)
				end
			end

			local v7 = getPriceStatus(v6, true)

			if not (v6 and (v7 == PriceStatus.Free or v7 == PriceStatus.PurchaseFromRoblox or v7 == PriceStatus.PurchaseFromResale)) then
				continue
			end

			local v8 = nil

			if v6.id then
				local v9 = p3[v6.id]

				if v9 and v9.timedOptions then
					for k2, timedOption in v9.timedOptions do
						if timedOption.selected then
							v8 = getPriceInRobux(v6, v7)
							local bulkPurchaseRequestItem = createBulkPurchaseRequestItem(v6)

							if timedOption.days > 0 then
								v8 = timedOption.price
								bulkPurchaseRequestItem.PurchaseOptions = {
									{
										Type = Enum.PurchaseOption.TimedOption,
										Value = timedOption.days * 86400
									}
								}
							end

							table.insert(v5, bulkPurchaseRequestItem)
							break
						end
					end
				else
					v8 = getPriceInRobux(v6, v7)
					table.insert(v5, createBulkPurchaseRequestItem(v6))
				end
			end

			if v8 ~= nil then
				total += v8
			end
		end

		return { requestedItems = v5, totalPrice = total }
	end
}
