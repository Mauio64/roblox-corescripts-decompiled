local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
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

local estimatedLength, lengthOf

if FFlagViewRecyclerReact084 then
	estimatedLength = function(p)
		local estimatedLength2

		if p ~= nil then
			estimatedLength2 = p.estimatedLength
		end

		if estimatedLength2 == nil then
			return 0
		end

		local v = estimatedLength2 >= 0 and estimatedLength2 < 1e999
		assert(v, "PinnedItems: estimated length must be finite and non-negative")
		return estimatedLength2
	end

	lengthOf = function(p)
		if p.item == nil then
			return 0
		end

		return p.measuredLength or estimatedLength(p.item)
	end
else
	estimatedLength = nil
	lengthOf = nil
end

local function createPinnedItemPlanner(p, p2)
	local v = p2
	local stickyIndexResolver = StickyIndexResolver(p, v.isItemStickyKey)

	if FFlagViewRecyclerReact084 then
		estimatedLength(v.pinnedStartItem)
		estimatedLength(v.pinnedEndItem)
	end

	local v2 = {
		item = v.pinnedStartItem,
		revision = 1,
		measuredLength = nil,
		length = not FFlagViewRecyclerReact084 and 0 or nil
	}

	local v3 = {
		item = v.pinnedEndItem,
		revision = 1,
		measuredLength = nil,
		length = not FFlagViewRecyclerReact084 and 0 or nil
	}

	local function setItem(state, p3): boolean -- 2 equivalent calls inferred from this helper
		if sameItem(state.item, p3) then -- inferred equivalent call
			local v4

			if FFlagViewRecyclerReact084 then
				v4 = lengthOf(state)
				state.item = p3
			end

			if FFlagViewRecyclerReact084 then
				return lengthOf(state) ~= v4
			end

			return false
		end

		state.item = p3
		state.revision += 1

		if FFlagViewRecyclerReact084 then
			state.measuredLength = nil
		else
			state.length = 0
		end

		return true
	end

	local function getContentInsets()
		local start

		if FFlagViewRecyclerReact084 then
			start = lengthOf(v2)
		else
			start = v2.item == nil and 0 or v2.length
		end

		local finish

		if FFlagViewRecyclerReact084 then
			finish = lengthOf(v3)
		else
			finish = v3.item == nil and 0 or v3.length
		end

		return { start = start, finish = finish }
	end

	local function resolvedItem(data, position) -- 2 equivalent calls inferred from this helper
		local item = data.item

		if item == nil then
			return nil
		end

		local v4 = { key = item.key, revision = data.revision, length = 0, position = 0 }
		local length

		if FFlagViewRecyclerReact084 then
			length = lengthOf(data)
		else
			length = data.length
		end

		v4.length = length
		v4.position = position
		return v4
	end

	return {
		getContentInsets = getContentInsets,
		update = function(data)
			stickyIndexResolver.setItemSequence(data.itemSequence)
			local v4

			if FFlagViewRecyclerReact084 then
				v4 = lengthOf(v2)
			else
				v4 = v2.item == nil and 0 or v2.length
			end

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
		updatePinnedMeasurement = function(p3, p4, p5, p6)
			local v4 = p6 >= 0 and p6 < 1e999
			assert(v4, "PinnedItems: measured length must be finite and non-negative")
			local v5

			if p3 == PlacementTypes.PinnedPosition.Start then
				v5 = v2
			else
				v5 = v3
			end

			local item = v5.item
			local v6

			if FFlagViewRecyclerReact084 then
				v6 = item == nil
			else
				v6 = item == nil or item.key ~= p4
			end

			if not v6 then
				local v7

				if FFlagViewRecyclerReact084 then
					v7 = item.key
				else
					v7 = v5.revision
				end

				if not FFlagViewRecyclerReact084 then
					p4 = p5
				end

				if v7 == p4 then
					local v8

					if FFlagViewRecyclerReact084 then
						v8 = v5.revision ~= p5
					else
						v8 = v5.length == p6
					end

					if not v8 then
						if not FFlagViewRecyclerReact084 then
							v5.length = p6
							return getContentInsets()
						end

						local v9 = lengthOf(v5)
						v5.measuredLength = p6

						if p6 == v9 then
							return nil, true
						end

						return getContentInsets(), true
					end
				end
			end

			if FFlagViewRecyclerReact084 then
				return nil, false
			end

			return nil
		end,
		setOptions = function(data)
			if FFlagViewRecyclerReact084 then
				estimatedLength(data.pinnedStartItem)
				estimatedLength(data.pinnedEndItem)
			end

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
