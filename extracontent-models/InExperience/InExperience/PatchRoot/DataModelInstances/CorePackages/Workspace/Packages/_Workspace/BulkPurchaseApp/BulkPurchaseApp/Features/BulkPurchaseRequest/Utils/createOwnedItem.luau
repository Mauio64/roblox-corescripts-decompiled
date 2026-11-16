local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestOwnedItem)
local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)

local function createOwnedItem(data)
	return {
		id = data.id,
		name = data.name,
		image = getThumbnailUrl(data.id, data.type),
		ownedCount = data.ownedCount
	}
end

return createOwnedItem
