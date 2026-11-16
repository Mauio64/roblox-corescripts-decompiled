local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectRobuxSpent(p)
	local robuxSpent = 0

	if p.itemData and p.itemStatuses then
		for _, v in p.itemData do
			if p.itemStatuses[v.id] == Enum.MarketplaceItemPurchaseStatus.Success then
				robuxSpent += v.priceRobux
			end
		end
	end

	return robuxSpent
end

return selectRobuxSpent
