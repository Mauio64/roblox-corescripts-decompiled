local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(script.Parent.Parent.BulkPurchaseRequestOwnedItem)

local getThumbnailUrl = require(BulkPurchaseApp.Utils.getThumbnailUrl)

local function createOwnedItem(p1) -- line: 10
	-- upvalues: getThumbnailUrl (copy)
	return {
		id = p1.id,
		name = p1.name,
		image = getThumbnailUrl(p1.id, p1.type),
		ownedCount = p1.ownedCount
	}
end

return createOwnedItem
