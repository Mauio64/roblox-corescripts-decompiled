local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local ItemTypeEnum = require(AvatarExperienceInspectAndBuyParent.AXCommon).Enums.ItemTypeEnum

require(AvatarExperienceInspectAndBuy.Types)

local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local getPriceInRobux = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils).getPriceInRobux

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase

local function createBulkPurchaseRequestItem(p1) -- line: 64
	-- upvalues: ItemTypeEnum (copy)
	return {
		id = p1.id and tonumber(p1.id) or 0,
		itemType = if p1.itemType ~= ItemTypeEnum.Asset then Enum.AvatarItemType.Bundle.Value else Enum.AvatarItemType.Asset.Value
	}
end

return {
	convertAvatarItemToItemData = function(p2, p3) -- line: 33
		-- upvalues: ItemTypeEnum (copy), convertAssetInfoToItemData (copy), convertBundleInfoToItemData (copy)
		if p2.itemType == ItemTypeEnum.Asset then
			local v13 = p3.assets[p2.id]

			if not v13 then
				return nil
			end

			return convertAssetInfoToItemData(v13)
		end

		if p2.itemType == ItemTypeEnum.Bundle then
			local v14 = p3.bundles[p2.id]

			if not v14 then
				return nil
			end

			return convertBundleInfoToItemData(v14)
		end

		return nil
	end,
	isPurchasableItem = function(p4) -- line: 54
		-- upvalues: PriceStatus (copy)
		return p4 == PriceStatus.Free or (p4 == PriceStatus.PurchaseFromRoblox or p4 == PriceStatus.PurchaseFromResale)
	end,
	createBulkPurchaseRequestItem = createBulkPurchaseRequestItem,
	getBulkPurchaseEligibleItems = function(t1: {[any]: any}?, p5, p6) -- line: 78
		-- upvalues: ItemTypeEnum (copy), convertAssetInfoToItemData (copy), convertBundleInfoToItemData (copy), getPriceStatus (copy), PriceStatus (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), getPriceInRobux (copy), createBulkPurchaseRequestItem (copy)
		if not t1 then
			return {
				totalPrice = 0,
				requestedItems = {}
			}
		end

		local t2 = {}
		local n1 = 0

		for _, v23 in t1 do
			local v25

			if v23.itemType == ItemTypeEnum.Asset then
				local v24 = p5.assets[v23.id]

				v25 = if v24 then convertAssetInfoToItemData(v24) else nil
			elseif v23.itemType == ItemTypeEnum.Bundle then
				local v26 = p5.bundles[v23.id]

				v25 = if v26 then convertBundleInfoToItemData(v26) else nil
			else
				v25 = nil
			end

			local v27 = getPriceStatus(v25, true)

			if v25 and (v27 == PriceStatus.Free or (v27 == PriceStatus.PurchaseFromRoblox or v27 == PriceStatus.PurchaseFromResale)) then
				local v28 = nil

				if FFlagAXEnableIaBTimedOptionsBulkPurchase then
					if p6 and v25.id then
						local v29 = p6[v25.id]

						if v29 and v29.timedOptions then
							for _, v31 in v29.timedOptions do
								if v31.selected then
									v28 = getPriceInRobux(v25, v27)

									local v32 = createBulkPurchaseRequestItem(v25)

									if v31.days > 0 then
										v28 = v31.price
										v32.PurchaseOptions = {{
											Type = Enum.PurchaseOption.TimedOption,
											Value = v31.days * 86400
										}}
									end

									table.insert(t2, v32)

									break
								end
							end
						else
							v28 = getPriceInRobux(v25, v27)
							table.insert(t2, (createBulkPurchaseRequestItem(v25)))
						end
					end
				else
					table.insert(t2, (createBulkPurchaseRequestItem(v25)))
					v28 = getPriceInRobux(v25, v27)
				end

				if v28 ~= nil then
					n1 += v28
				end
			end
		end

		return {
			requestedItems = t2,
			totalPrice = n1
		}
	end
}
