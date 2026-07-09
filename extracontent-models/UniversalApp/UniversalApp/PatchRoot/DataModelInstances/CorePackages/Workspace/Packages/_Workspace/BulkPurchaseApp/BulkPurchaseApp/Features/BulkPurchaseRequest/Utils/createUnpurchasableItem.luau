local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestUnpurchasableItem)

local PurchasableStateToItemPurchaseStatusMap = require(BulkPurchaseApp.Enums.PurchasableStateToItemPurchaseStatusMap)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)

local function createUnpurchasableItem(p1) -- line: 11
	-- upvalues: getThumbnailUrl (copy), PurchasableStateToItemPurchaseStatusMap (copy)
	return {
		id = p1.id,
		name = p1.name,
		image = getThumbnailUrl(p1.id, p1.type),
		status = PurchasableStateToItemPurchaseStatusMap[p1.purchasableState] or Enum.MarketplaceItemPurchaseStatus.SystemError
	}
end

return createUnpurchasableItem
