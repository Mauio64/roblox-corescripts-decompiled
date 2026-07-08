local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function getMarketPlaceProductTypeFromItemType(s1: string) -- line: 8
	if s1 == "AvatarBundle" then
		return Enum.MarketplaceProductType.AvatarBundle
	end

	return Enum.MarketplaceProductType.AvatarAsset
end
local function selectResultItems(p1) -- line: 16
	local t1 = {}

	if p1.itemData then
		for _, v8 in p1.itemData do
			table.insert(t1, {
				id = v8.id,
				type = if v8.type ~= "AvatarBundle" then Enum.MarketplaceProductType.AvatarAsset else Enum.MarketplaceProductType.AvatarBundle,
				status = if not p1.itemStatuses then Enum.MarketplaceItemPurchaseStatus.SystemError else p1.itemStatuses[v8.id] or Enum.MarketplaceItemPurchaseStatus.SystemError
			})
		end
	end

	return t1
end

return selectResultItems
