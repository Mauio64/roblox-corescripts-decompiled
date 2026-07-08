local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectRobuxSpent(p1) -- line: 7
	local n1 = 0

	if p1.itemData and p1.itemStatuses then
		for _, v6 in p1.itemData do
			if p1.itemStatuses[v6.id] == Enum.MarketplaceItemPurchaseStatus.Success then
				n1 += v6.priceRobux
			end
		end
	end

	return n1
end

return selectRobuxSpent
