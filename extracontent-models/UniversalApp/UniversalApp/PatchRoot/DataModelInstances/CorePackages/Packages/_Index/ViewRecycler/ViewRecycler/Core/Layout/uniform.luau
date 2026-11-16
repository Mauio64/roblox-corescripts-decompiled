local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Layout.LayoutRuntime)
local Types = require(ViewRecycler.Core.Types)
local staticParts = require(ViewRecycler.Core.Layout.staticParts)

local function uniform(data)
	assert(data.itemLength > 0, "Layout.uniform: itemLength must be positive")

	local itemLength = data.itemLength
	local spacing = data.spacing or 0
	local paddingBefore = data.paddingBefore or 0
	local paddingAfter = data.paddingAfter or 0
	local v = itemLength + spacing

	local itemCount = 0

	local function applyDataSourceChange(p): boolean
		local v2 = itemCount

		if p.type == DataSourceChangeType.Reset then
			itemCount = #p.keys
		elseif p.type == DataSourceChangeType.Insert then
			itemCount += #p.keys
		elseif p.type == DataSourceChangeType.Remove then
			itemCount -= #p.keys
		end

		return itemCount ~= v2
	end

	return {
		getItemCount = function()
			return itemCount
		end,
		getContentLength = function()
			if itemCount == 0 then
				return 0
			end

			return paddingBefore + itemCount * itemLength + (itemCount - 1) * spacing + paddingAfter
		end,
		getIntersectingIndexRange = function(p: number, p2: number)
			if itemCount == 0 or p2 <= p then
				return Types.EMPTY_INDEX_RANGE
			end

			local v2 = p - paddingBefore
			local v3

			if v2 > 0 then
				v3 = v2 // v + 1

				if paddingBefore + (v3 - 1) * v + itemLength <= p then
					v3 += 1
				end
			else
				v3 = 1
			end

			local v4 = p2 - paddingBefore

			if v4 <= 0 then
				return Types.EMPTY_INDEX_RANGE
			end

			local v5 = v4 // v + 1

			if p2 <= paddingBefore + (v5 - 1) * v then
				v5 -= 1
			end

			local firstIndex = math.max(1, v3)
			local lastIndex = math.min(itemCount, v5)

			if lastIndex < firstIndex then
				return Types.EMPTY_INDEX_RANGE
			end

			return { firstIndex = firstIndex, lastIndex = lastIndex }
		end,
		expandIndexRange = function(p, p2, p3)
			return staticParts.expandItemRange(p, p2, p3 or p2, itemCount)
		end,
		getItemLayout = function(p: number)
			return {
				startOffset = paddingBefore + (p - 1) * v,
				length = itemLength
			}
		end,
		getItemLayouts = function(p: number, p2: number, p3)
			for i = p, p2 do
				p3[i - p + 1] = {
					startOffset = paddingBefore + (i - 1) * v,
					length = itemLength
				}
			end
		end,
		updateItemMeasurement = staticParts.updateItemMeasurementNoop,
		requiresItemMeasurement = staticParts.requiresItemMeasurementFalse,
		applyDataSourceChange = applyDataSourceChange,
		setViewportCrossAxisLength = staticParts.geometryUnchanged,
		destroy = staticParts.noop
	}
end

return uniform
