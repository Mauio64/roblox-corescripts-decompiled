require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel").Enums.ItemTypeEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Stores/createItemSelectionStore")
local convertAssetInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertAssetInfoToItemData")
local convertBundleInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertBundleInfoToItemData")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local getPriceInRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").getPriceInRobux

local function buildBulkPurchaseAnalyticsPayload(data)
	local itemId = data.itemId
	local collectibleResellableInstances = data.collectibleResellableInstances
	local storedData = data.storedData

	local days = nil
	local v5, v6

	if data.itemType == itemTypeEnum.Asset then
		local v7 = data.assetsMap and data.assetsMap[itemId]

		if not v7 then
			return nil
		end

		local v8

		if v7.collectibleItemId and collectibleResellableInstances then
			v8 = collectibleResellableInstances[v7.collectibleItemId]
		end

		local v9 = convertAssetInfoToItemData(v7, v8)
		v5 = getPriceInRobux(v9, (getPriceStatus(v9, true)))
		v6 = v7.assetTypeId

		if storedData and storedData.timedOptions then
			for k, timedOption in storedData.timedOptions do
				if timedOption.selected then
					days = timedOption.days
					v5 = timedOption.price
					break
				end
			end
		end

		return { itemSubType = v6, timedOptionDays = days, price = v5 }
	else
		local v7 = data.bundlesMap and data.bundlesMap[itemId]

		if not v7 then
			return nil
		end

		local v8

		if v7.collectibleItemId and collectibleResellableInstances then
			v8 = collectibleResellableInstances[v7.collectibleItemId]
		end

		local v9 = convertBundleInfoToItemData(v7, v8)
		v5 = getPriceInRobux(v9, (getPriceStatus(v9, true)))

		if v9 then
			v6 = v9.itemSubType
		end

		return { itemSubType = v6, timedOptionDays = days, price = v5 }
	end
end

return buildBulkPurchaseAnalyticsPayload
