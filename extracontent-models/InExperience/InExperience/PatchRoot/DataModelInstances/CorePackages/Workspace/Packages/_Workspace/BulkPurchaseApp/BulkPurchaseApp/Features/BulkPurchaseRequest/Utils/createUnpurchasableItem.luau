local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestUnpurchasableItem)
local PurchasableStateToItemPurchaseStatusMap = require(BulkPurchaseApp.Enums.PurchasableStateToItemPurchaseStatusMap)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)

local function createUnpurchasableItem(data)
	return {
		id = data.id,
		name = data.name,
		image = getThumbnailUrl(data.id, data.type),
		status = PurchasableStateToItemPurchaseStatusMap[data.purchasableState] or Enum.MarketplaceItemPurchaseStatus.SystemError
	}
end

return createUnpurchasableItem
