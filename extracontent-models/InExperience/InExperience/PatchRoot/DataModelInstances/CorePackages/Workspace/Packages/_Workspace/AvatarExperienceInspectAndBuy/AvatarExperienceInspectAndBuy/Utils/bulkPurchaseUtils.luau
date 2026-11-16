local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
require(AvatarExperienceInspectAndBuy.Types)
local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local function convertAvatarItemToItemData(item, p) -- 1 equivalent call inferred from this helper
	if item.itemType == ItemTypeEnum.Asset then
		local asset = p.assets[item.id]

		if asset then
			return convertAssetInfoToItemData(asset)
		end

		return nil
	else
		if item.itemType ~= ItemTypeEnum.Bundle then
			return nil
		end

		local bundle = p.bundles[item.id]

		if bundle then
			return convertBundleInfoToItemData(bundle)
		end

		return nil
	end
end

local function createBulkPurchaseRequestItem(p)
	local bulkPurchaseRequestItem = {
		id = p.id and tonumber(p.id) or 0,
		itemType = 0
	}
	local itemType

	if p.itemType == ItemTypeEnum.Asset then
		itemType = Enum.AvatarItemType.Asset.Value
	else
		itemType = Enum.AvatarItemType.Bundle.Value
	end

	bulkPurchaseRequestItem.itemType = itemType
	return bulkPurchaseRequestItem
end

local BulkPurchaseUtils = {}
BulkPurchaseUtils.convertAvatarItemToItemData = convertAvatarItemToItemData

function BulkPurchaseUtils.isPurchasableItem(p): boolean
	return p == PriceStatus.Free or p == PriceStatus.PurchaseFromRoblox or p == PriceStatus.PurchaseFromResale
end

BulkPurchaseUtils.createBulkPurchaseRequestItem = createBulkPurchaseRequestItem

function BulkPurchaseUtils.getBulkPurchaseEligibleItems(items, p, p2)
	if not items then
		return { requestedItems = {}, totalPrice = 0 }
	end

	local requestedItems = {}
	local total = 0

	for _, item in items do
		local v = convertAvatarItemToItemData(item, p) -- inferred equivalent call
		local priceStatus = getPriceStatus(v, true)

		if not (v and (priceStatus == PriceStatus.Free or priceStatus == PriceStatus.PurchaseFromRoblox or priceStatus == PriceStatus.PurchaseFromResale)) then
			continue
		end

		local v2 = nil

		if v.id then
			local v3 = p2[v.id]

			if v3 and v3.timedOptions then
				for _, timedOption in v3.timedOptions do
					if timedOption.selected then
						v2 = getPriceInRobux(v, priceStatus)
						local bulkPurchaseRequestItem = createBulkPurchaseRequestItem(v)

						if timedOption.days > 0 then
							v2 = timedOption.price
							bulkPurchaseRequestItem.PurchaseOptions = {
								{
									Type = Enum.PurchaseOption.TimedOption,
									Value = timedOption.days * 86400
								}
							}
						end

						table.insert(requestedItems, bulkPurchaseRequestItem)
						break
					end
				end
			else
				v2 = getPriceInRobux(v, priceStatus)
				table.insert(requestedItems, createBulkPurchaseRequestItem(v))
			end
		end

		if v2 ~= nil then
			total += v2
		end
	end

	return { requestedItems = requestedItems, totalPrice = total }
end

return BulkPurchaseUtils
