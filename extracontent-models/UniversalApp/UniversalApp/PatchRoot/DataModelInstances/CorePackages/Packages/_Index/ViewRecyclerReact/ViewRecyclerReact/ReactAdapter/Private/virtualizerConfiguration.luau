local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local function toCorePinnedItem(data) -- 2 equivalent calls inferred from this helper
	if data == nil then
		return nil
	end

	return { key = data.key, value = data.value, itemViewType = data.itemType }
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
