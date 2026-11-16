local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function getMarketPlaceProductTypeFromItemType(kind: string) -- 1 equivalent call inferred from this helper
	if kind == "AvatarBundle" then
		return Enum.MarketplaceProductType.AvatarBundle
	end

	return Enum.MarketplaceProductType.AvatarAsset
end

local function selectResultItems(p)
	local resultItems = {}

	if not p.itemData then
		return resultItems
	end

	for _, v in p.itemData do
		local v2 = {
			id = v.id,
			type = getMarketPlaceProductTypeFromItemType(v.type), -- inferred equivalent call
			status = 0
		}
		local status

		if p.itemStatuses then
			status = p.itemStatuses[v.id] or Enum.MarketplaceItemPurchaseStatus.SystemError
		else
			status = Enum.MarketplaceItemPurchaseStatus.SystemError
		end

		v2.status = status
		table.insert(resultItems, v2)
	end

	return resultItems
end

return selectResultItems
