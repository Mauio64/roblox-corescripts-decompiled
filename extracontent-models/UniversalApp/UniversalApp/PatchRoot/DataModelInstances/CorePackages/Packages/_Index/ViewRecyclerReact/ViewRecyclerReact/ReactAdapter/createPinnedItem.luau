local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)

local function createPinnedItem(data)
	assert(data.key ~= "", "createPinnedItem: `key` must not be empty")
	assert(
		RecyclableViewRegistry.isRegistered(data.itemType),
		"createPinnedItem: `itemType` must be a Recyclable view type"
	)

	return table.freeze({ key = data.key, value = data.value, itemType = data.itemType })
end

return createPinnedItem
