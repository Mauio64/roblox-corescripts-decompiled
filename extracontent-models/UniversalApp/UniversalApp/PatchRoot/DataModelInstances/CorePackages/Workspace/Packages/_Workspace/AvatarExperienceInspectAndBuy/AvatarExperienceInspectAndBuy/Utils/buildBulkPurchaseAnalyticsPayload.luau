local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)

local ItemTypeEnum = require(AvatarExperienceInspectAndBuyParent.AXCommon).Enums.ItemTypeEnum

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)

require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)

local getPriceInRobux = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils).getPriceInRobux

local function buildBulkPurchaseAnalyticsPayload(t1: {[any]: any}) -- line: 47
	-- upvalues: ItemTypeEnum (copy), convertAssetInfoToItemData (copy), getPriceStatus (copy), getPriceInRobux (copy), convertBundleInfoToItemData (copy)
	local itemId = t1.itemId
	local collectibleResellableInstances = t1.collectibleResellableInstances
	local storedData = t1.storedData
	local days = nil
	local v18, assetTypeId

	if t1.itemType == ItemTypeEnum.Asset then
		local v14 = t1.assetsMap and t1.assetsMap[itemId]

		if not v14 then
			return nil
		end

		local v15 = if not v14.collectibleItemId or not collectibleResellableInstances then nil else collectibleResellableInstances[v14.collectibleItemId]
		local v16 = convertAssetInfoToItemData(v14, v15)
		local v17 = getPriceStatus(v16, true)

		v18 = getPriceInRobux(v16, v17)
		assetTypeId = v14.assetTypeId

		if storedData and storedData.timedOptions then
			for _, v21 in storedData.timedOptions do
				if v21.selected then
					days = v21.days
					v18 = v21.price

					return {
						itemSubType = assetTypeId,
						timedOptionDays = days,
						price = v18
					}
				end
			end
		end
	else
		local v22 = t1.bundlesMap and t1.bundlesMap[itemId]

		if not v22 then
			return nil
		end

		local v23 = if not v22.collectibleItemId or not collectibleResellableInstances then nil else collectibleResellableInstances[v22.collectibleItemId]
		local v24 = convertBundleInfoToItemData(v22, v23)
		local v25 = getPriceStatus(v24, true)

		v18 = getPriceInRobux(v24, v25)
		assetTypeId = if not v24 then nil else v24.itemSubType
	end

	return {
		itemSubType = assetTypeId,
		timedOptionDays = days,
		price = v18
	}
end

return buildBulkPurchaseAnalyticsPayload
