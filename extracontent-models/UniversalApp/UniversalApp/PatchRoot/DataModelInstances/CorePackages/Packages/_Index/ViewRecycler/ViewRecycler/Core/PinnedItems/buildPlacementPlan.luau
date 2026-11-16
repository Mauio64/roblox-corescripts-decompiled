local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Virtualizer.ItemSequence)
require(ViewRecycler.Core.Layout)
local PlacementTypes = require(ViewRecycler.Core.Placement.PlacementTypes)

local frozen = table.freeze({
	retainedItems = table.freeze({}),
	additionalItems = table.freeze({}),
	placements = table.freeze({}),
	hasViewportRelativePlacements = false
})

local function buildPlacementPlan(data)
	if data.activeStickyIndex == nil and data.pinnedStartItem == nil and data.pinnedEndItem == nil then
		return frozen
	end

	local retainedItems = {}
	local additionalItems = {}
	local placements = {}
	local mainAxisOffset = data.pinnedStartItem == nil and 0 or data.pinnedStartItem.length

	local activeStickyIndex = data.activeStickyIndex

	if activeStickyIndex ~= nil then
		local itemLayout = data.layout.getItemLayout(activeStickyIndex)

		local nextStickyIndex = data.nextStickyIndex
		local mainAxisEndLimit

		if nextStickyIndex ~= nil then
			mainAxisEndLimit = data.layout.getItemLayout(nextStickyIndex).startOffset + data.contentStartOffset - data.scrollOffset
		end

		local itemKey = data.itemSequence.getItemKey(activeStickyIndex)
		table.insert(retainedItems, { key = itemKey, index = activeStickyIndex })

		placements[itemKey] = {
			mainAxisOffset = mainAxisOffset,
			mainAxisLength = itemLayout.length,
			mainAxisEndLimit = mainAxisEndLimit,
			viewportRelative = true,
			zIndex = 1
		}
	end

	for _, v in { data.pinnedStartItem, data.pinnedEndItem } do
		if v == nil then
			continue
		end

		table.insert(additionalItems, {
			key = v.key,
			identity = {
				kind = PlacementTypes.IdentityKind.Pinned,
				position = v.position,
				revision = v.revision
			}
		})

		placements[v.key] = {
			mainAxisOffset = v.position == PlacementTypes.PinnedPosition.Start and 0 or math.max(0, data.viewportLength - v.length),
			mainAxisLength = v.length,
			viewportRelative = true,
			zIndex = 2
		}
	end

	return {
		retainedItems = retainedItems,
		additionalItems = additionalItems,
		placements = placements,
		hasViewportRelativePlacements = activeStickyIndex ~= nil or data.pinnedStartItem ~= nil or data.pinnedEndItem ~= nil
	}
end

return buildPlacementPlan
