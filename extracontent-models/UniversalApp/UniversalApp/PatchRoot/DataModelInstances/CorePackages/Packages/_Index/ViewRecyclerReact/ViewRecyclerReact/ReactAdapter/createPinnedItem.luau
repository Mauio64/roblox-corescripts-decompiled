local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

local RecyclableViewRegistry = require(ViewRecyclerReact.ReactAdapter.Private.RecyclableViewRegistry)

local function createPinnedItem(data)
	assert(data.key ~= "", "createPinnedItem: `key` must not be empty")
	assert(
		RecyclableViewRegistry.isRegistered(data.itemType),
		"createPinnedItem: `itemType` must be a Recyclable view type"
	)

	local v = { key = data.key, value = data.value, itemType = data.itemType, estimatedLength = 0 }
	local estimatedLength

	if FFlagViewRecyclerReact084 then
		estimatedLength = data.estimatedLength
	end

	v.estimatedLength = estimatedLength
	return table.freeze(v)
end

return createPinnedItem
