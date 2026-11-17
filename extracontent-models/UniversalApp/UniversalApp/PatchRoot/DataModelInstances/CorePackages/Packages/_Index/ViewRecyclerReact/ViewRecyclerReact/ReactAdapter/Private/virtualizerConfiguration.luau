local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local function toCorePinnedItem(data) -- 2 equivalent calls inferred from this helper
	if data == nil then
		return nil
	end

	local v = {
		key = data.key,
		value = data.value,
		itemViewType = data.itemType,
		estimatedLength = 0
	}
	local estimatedLength

	if FFlagViewRecyclerReact084 then
		estimatedLength = data.estimatedLength
	end

	v.estimatedLength = estimatedLength
	return v
end

local function virtualizerConfiguration(p, p2)
	local clone = table.clone(p)
	clone.scrollingFrame = p2.scrollingFrame
	clone.viewportOverlay = p2.viewportOverlay
	clone.pinnedStartItem = toCorePinnedItem(p.pinnedStartItem) -- inferred equivalent call
	clone.pinnedEndItem = toCorePinnedItem(p.pinnedEndItem) -- inferred equivalent call
	return clone
end

return virtualizerConfiguration
