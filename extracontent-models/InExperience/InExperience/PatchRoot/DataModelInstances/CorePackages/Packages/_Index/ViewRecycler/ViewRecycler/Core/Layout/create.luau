local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Layout.LayoutRuntime)
local Types = require(ViewRecycler.Core.Types)
local staticParts = require(ViewRecycler.Core.Layout.staticParts)

local function create(p)
	local getItemLayout = p.getItemLayout
	local itemCount = 0

	local function applyDataSourceChange(p2): boolean
		if p2.type == DataSourceChangeType.Reset then
			itemCount = #p2.keys
		elseif p2.type == DataSourceChangeType.Insert then
			itemCount += #p2.keys
		elseif p2.type == DataSourceChangeType.Remove then
			itemCount -= #p2.keys
		end

		return true
	end

	return {
		getItemCount = function()
			return itemCount
		end,
		getContentLength = function()
			if itemCount == 0 then
				return 0
			end

			local itemLayout = getItemLayout(itemCount)
			return itemLayout.startOffset + itemLayout.length
		end,
		getIntersectingIndexRange = function(p2: number, p3: number)
			if itemCount == 0 or p3 <= p2 then
				return Types.EMPTY_INDEX_RANGE
			end

			local v = itemCount
			local firstIndex = 1

			while firstIndex < v do
				local v2 = (firstIndex + v) // 2
				local itemLayout = getItemLayout(v2)

				if p2 < itemLayout.startOffset + itemLayout.length then
					v = v2
				else
					firstIndex = v2 + 1
				end
			end

			local itemLayout = getItemLayout(firstIndex)

			if itemLayout.startOffset + itemLayout.length <= p2 then
				return Types.EMPTY_INDEX_RANGE
			end

			local v2 = itemCount
			local lastIndex = 1

			while lastIndex < v2 do
				local v3 = (lastIndex + v2 + 1) // 2

				if getItemLayout(v3).startOffset < p3 then
					lastIndex = v3
				else
					v2 = v3 - 1
				end
			end

			if p3 <= getItemLayout(lastIndex).startOffset or lastIndex < firstIndex then
				return Types.EMPTY_INDEX_RANGE
			end

			return { firstIndex = firstIndex, lastIndex = lastIndex }
		end,
		expandIndexRange = function(p2, p3, p4)
			return staticParts.expandItemRange(p2, p3, p4 or p3, itemCount)
		end,
		getItemLayout = getItemLayout,
		updateItemMeasurement = staticParts.updateItemMeasurementNoop,
		requiresItemMeasurement = staticParts.requiresItemMeasurementFalse,
		applyDataSourceChange = applyDataSourceChange,
		setViewportCrossAxisLength = staticParts.geometryUnchanged,
		destroy = staticParts.noop
	}
end

return create
