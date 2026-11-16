local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)
local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local getPriceInRobux = itemDetailsUtils.getPriceInRobux

local function buildBulkPurchaseAnalyticsPayload(data)
	local itemId = data.itemId
	local collectibleResellableInstances = data.collectibleResellableInstances
	local storedData = data.storedData

	local days = nil
	local price, itemSubType

	if data.itemType == ItemTypeEnum.Asset then
		local v = data.assetsMap and data.assetsMap[itemId]

		if not v then
			return nil
		end

		local v2

		if v.collectibleItemId and collectibleResellableInstances then
			v2 = collectibleResellableInstances[v.collectibleItemId]
		end

		local v3 = convertAssetInfoToItemData(v, v2)
		price = getPriceInRobux(v3, (getPriceStatus(v3, true)))
		itemSubType = v.assetTypeId

		if storedData and storedData.timedOptions then
			for _, timedOption in storedData.timedOptions do
				if timedOption.selected then
					days = timedOption.days
					price = timedOption.price
					break
				end
			end
		end

		return { itemSubType = itemSubType, timedOptionDays = days, price = price }
	else
		local v = data.bundlesMap and data.bundlesMap[itemId]

		if not v then
			return nil
		end

		local v2

		if v.collectibleItemId and collectibleResellableInstances then
			v2 = collectibleResellableInstances[v.collectibleItemId]
		end

		local v3 = convertBundleInfoToItemData(v, v2)
		price = getPriceInRobux(v3, (getPriceStatus(v3, true)))

		if v3 then
			itemSubType = v3.itemSubType
		end

		return { itemSubType = itemSubType, timedOptionDays = days, price = price }
	end
end

return buildBulkPurchaseAnalyticsPayload
