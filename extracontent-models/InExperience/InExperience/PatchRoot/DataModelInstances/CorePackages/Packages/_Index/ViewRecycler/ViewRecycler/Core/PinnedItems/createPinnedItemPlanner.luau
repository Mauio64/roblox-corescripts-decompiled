local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Virtualizer.ItemSequence)
require(ViewRecycler.Core.Layout)
local PlacementTypes = require(ViewRecycler.Core.Placement.PlacementTypes)
local ShallowTable = require(ViewRecycler.Internal.ShallowTable)
require(ViewRecycler.Core.Types)
local buildPlacementPlan = require(ViewRecycler.Core.PinnedItems.buildPlacementPlan)
local StickyIndexResolver = require(ViewRecycler.Core.PinnedItems.StickyIndexResolver)

local frozen = table.freeze({ "key" })

local function sameItem(item, p) -- 1 equivalent call inferred from this helper
	if item == p then
		return true
	elseif item == nil or p == nil then
		return false
	else
		return (ShallowTable.containsEqual(item, p, frozen))
	end
end

local function createPinnedItemPlanner(p, p2)
	local v = p2
	local stickyIndexResolver = StickyIndexResolver(p, v.isItemStickyKey)
	local v2 = { item = v.pinnedStartItem, revision = 1, length = 0 }

	local v3 = { item = v.pinnedEndItem, revision = 1, length = 0 }

	local function setItem(state, p3): boolean -- 2 equivalent calls inferred from this helper
		if sameItem(state.item, p3) then -- inferred equivalent call
			return false
		end

		state.item = p3
		state.revision += 1
		state.length = 0
		return true
	end

	local function getContentInsets() -- 1 equivalent call inferred from this helper
		return {
			start = v2.item == nil and 0 or v2.length,
			finish = v3.item == nil and 0 or v3.length
		}
	end

	local function resolvedItem(data, position) -- 2 equivalent calls inferred from this helper
		local item = data.item

		if item == nil then
			return nil
		end

		return {
			key = item.key,
			revision = data.revision,
			length = data.length,
			position = position
		}
	end

	return {
		getContentInsets = getContentInsets,
		update = function(data)
			stickyIndexResolver.setItemSequence(data.itemSequence)
			local v4 = v2.item == nil and 0 or v2.length
			local active, nextStickyIndex = stickyIndexResolver.resolveActive(function(p3): boolean
				return data.layout.getItemLayout(p3).startOffset + data.contentStartOffset - data.scrollOffset < v4
			end)

			return buildPlacementPlan({
				itemSequence = data.itemSequence,
				layout = data.layout,
				activeStickyIndex = active,
				nextStickyIndex = nextStickyIndex,
				scrollOffset = data.scrollOffset,
				viewportLength = data.viewportLength,
				contentStartOffset = data.contentStartOffset,
				pinnedStartItem = resolvedItem(v2, PlacementTypes.PinnedPosition.Start), -- inferred equivalent call
				pinnedEndItem = resolvedItem(v3, PlacementTypes.PinnedPosition.Finish) -- inferred equivalent call
			})
		end,
		applyDataSourceChange = function(p3)
			stickyIndexResolver.applyDataSourceChange(p3)
		end,
		updatePinnedMeasurement = function(p3, p4, p5, length)
			local v4 = length >= 0 and length < 1e999
			assert(v4, "PinnedItems: measured length must be finite and non-negative")
			local v5

			if p3 == PlacementTypes.PinnedPosition.Start then
				v5 = v2
			else
				v5 = v3
			end

			local item = v5.item

			if item == nil or item.key ~= p4 or v5.revision ~= p5 or v5.length == length then
				return nil
			end

			v5.length = length
			return getContentInsets() -- inferred equivalent call
		end,
		setOptions = function(data)
			v = data
			local v4 = stickyIndexResolver.setPredicate(data.isItemStickyKey)
			local v5 = setItem(v2, data.pinnedStartItem) or v4 -- inferred equivalent call
			return setItem(v3, data.pinnedEndItem) or v5 -- inferred equivalent call
		end,
		setItemSequence = stickyIndexResolver.setItemSequence,
		destroy = function() end
	}
end

return createPinnedItemPlanner
