local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Layout.LayoutRuntime)
local Types = require(ViewRecycler.Core.Types)
local staticParts = require(ViewRecycler.Core.Layout.staticParts)

local function grid(data)
	assert(data.itemLength > 0, "Layout.grid: itemLength must be positive")
	assert(
		(data.crossAxisCount ~= nil) ~= (data.crossAxisItemLength ~= nil),
		"Layout.grid: provide exactly one of crossAxisCount or crossAxisItemLength"
	)

	local itemLength = data.itemLength
	local spacing = data.spacing or 0
	local paddingBefore = data.paddingBefore or 0
	local paddingAfter = data.paddingAfter or 0
	local v = itemLength + spacing

	local crossAxisCount = data.crossAxisCount or 1
	local itemCount = 0

	local function rowCount() -- 3 equivalent calls inferred from this helper
		return (math.ceil(itemCount / crossAxisCount))
	end

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

	local function setViewportCrossAxisLength(p: number): boolean
		if data.crossAxisItemLength == nil then
			return false
		end

		local v2 = math.max(1, p // data.crossAxisItemLength)

		if v2 == crossAxisCount then
			return false
		end

		crossAxisCount = v2
		return true
	end

	return {
		getItemCount = function()
			return itemCount
		end,
		getContentLength = function()
			local v2 = rowCount() -- inferred equivalent call

			if v2 == 0 then
				return 0
			end

			return paddingBefore + v2 * itemLength + (v2 - 1) * spacing + paddingAfter
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

			local v6 = math.max(1, v3)
			local v7 = math.min(rowCount(), v5) -- inferred equivalent call

			if v7 < v6 then
				return Types.EMPTY_INDEX_RANGE
			end

			return {
				firstIndex = (v6 - 1) * crossAxisCount + 1,
				lastIndex = math.min(itemCount, v7 * crossAxisCount)
			}
		end,
		expandIndexRange = function(p, p2: number, p3: number?)
			local v2 = (p.firstIndex - 1) // crossAxisCount + 1
			local v3 = (p.lastIndex - 1) // crossAxisCount + 1
			local v4 = math.max(1, v2 - p2)
			local v5 = math.min(rowCount(), v3 + (p3 or p2)) -- inferred equivalent call
			return {
				firstIndex = (v4 - 1) * crossAxisCount + 1,
				lastIndex = math.min(itemCount, v5 * crossAxisCount)
			}
		end,
		getItemLayout = function(p: number)
			return {
				startOffset = paddingBefore + ((p - 1) // crossAxisCount + 1 - 1) * v,
				length = itemLength,
				crossAxisIndex = (p - 1) % crossAxisCount + 1,
				crossAxisCount = crossAxisCount
			}
		end,
		updateItemMeasurement = staticParts.updateItemMeasurementNoop,
		requiresItemMeasurement = staticParts.requiresItemMeasurementFalse,
		applyDataSourceChange = applyDataSourceChange,
		setViewportCrossAxisLength = setViewportCrossAxisLength,
		destroy = staticParts.noop
	}
end

return grid
