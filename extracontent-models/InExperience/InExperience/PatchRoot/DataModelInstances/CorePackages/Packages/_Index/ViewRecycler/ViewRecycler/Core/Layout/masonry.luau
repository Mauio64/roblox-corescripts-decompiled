local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Layout.LayoutRuntime)
local Types = require(ViewRecycler.Core.Types)
local staticParts = require(ViewRecycler.Core.Layout.staticParts)

local function validateNonNegative(p: string, p2: number) -- 4 equivalent calls inferred from this helper
	if p2 < 0 or p2 >= 1e999 then
		assert(false, `Layout.masonry: {p} must be finite and non-negative`)
	end
end

local function masonry(data)
	assert(type(data.getItemLength) == "function", "Layout.masonry: getItemLength must be a function")
	assert(
		(data.crossAxisCount ~= nil) ~= (data.crossAxisItemLength ~= nil),
		"Layout.masonry: provide exactly one of crossAxisCount or crossAxisItemLength"
	)

	if data.crossAxisCount ~= nil then
		local v = data.crossAxisCount > 0 and data.crossAxisCount % 1 == 0
		assert(v, "Layout.masonry: crossAxisCount must be a positive integer")
	end

	if data.crossAxisItemLength ~= nil then
		local v = data.crossAxisItemLength > 0 and data.crossAxisItemLength < 1e999
		assert(v, "Layout.masonry: crossAxisItemLength must be finite and positive")
	end

	local getItemLength = data.getItemLength
	local spacing = data.spacing or 0
	local crossAxisSpacing = data.crossAxisSpacing or 0
	local paddingBefore = data.paddingBefore or 0
	local paddingAfter = data.paddingAfter or 0
	validateNonNegative("spacing", spacing) -- inferred equivalent call
	validateNonNegative("crossAxisSpacing", crossAxisSpacing) -- inferred equivalent call
	validateNonNegative("paddingBefore", paddingBefore) -- inferred equivalent call
	validateNonNegative("paddingAfter", paddingAfter) -- inferred equivalent call
	local crossAxisCount = data.crossAxisCount or 1
	local v = {}
	local v2 = {}
	local v3 = {}
	local contentLength = 0
	local v4 = true

	local function markGeometryDirty() -- 2 equivalent calls inferred from this helper
		v4 = true
	end

	local function rebuildGeometry()
		if not v4 then
			return
		end

		table.clear(v2)
		table.clear(v3)

		local v5 = table.create(crossAxisCount, paddingBefore)

		for i = 1, crossAxisCount do
			v5[i] = paddingBefore
			v3[i] = {}
		end

		for i = 1, #v do
			local itemLength = getItemLength(i)

			if type(itemLength) ~= "number" or itemLength <= 0 or itemLength >= 1e999 then
				assert(false, `Layout.masonry: getItemLength({i}) must return a finite positive number`)
			end

			local startOffset = v5[1]
			local crossAxisIndex = 1

			for j = 2, crossAxisCount do
				local v6 = v5[j]

				if not (v6 < startOffset) then
					continue
				end

				crossAxisIndex = j
				startOffset = v6
			end

			v2[i] = {
				startOffset = startOffset,
				length = itemLength,
				crossAxisIndex = crossAxisIndex,
				crossAxisCount = crossAxisCount,
				crossAxisSpacing = crossAxisSpacing
			}

			table.insert(v3[crossAxisIndex], i)
			v5[crossAxisIndex] = startOffset + itemLength + spacing
		end

		if #v == 0 then
			contentLength = 0
			v4 = false
		else
			local v6 = paddingBefore

			for i = 1, crossAxisCount do
				v6 = math.max(v6, v5[i])
			end

			contentLength = v6 - spacing + paddingAfter
			v4 = false
		end
	end

	local function firstIntersectingInColumn(list, p: number, p2: number)
		if #list == 0 then
			return nil, nil
		end

		local v5 = #list
		local v6 = 1

		while v6 < v5 do
			local v7 = (v6 + v5) // 2
			local v8 = v2[list[v7]]

			if p < v8.startOffset + v8.length then
				v5 = v7
			else
				v6 = v7 + 1
			end
		end

		local v7 = v2[list[v6]]

		if v7.startOffset + v7.length <= p or p2 <= v7.startOffset then
			return nil, nil
		end

		local v8 = #list
		local v9 = v6

		while v6 < v8 do
			local v10 = (v6 + v8 + 1) // 2

			if v2[list[v10]].startOffset < p2 then
				v6 = v10
			else
				v8 = v10 - 1
			end
		end

		return list[v9], list[v6]
	end

	local function applyDataSourceChange(data2): boolean
		if data2.type == DataSourceChangeType.Reset then
			v = table.clone(data2.keys)
		elseif data2.type == DataSourceChangeType.Insert then
			for k, key in data2.keys do
				table.insert(v, data2.index + k - 1, key)
			end
		elseif data2.type == DataSourceChangeType.Remove then
			for _, key in data2.keys do
				assert(v[data2.index] == key, "Layout.masonry: remove keys do not match current order")

				table.remove(v, data2.index)
			end
		elseif data2.type == DataSourceChangeType.Move then
			assert(v[data2.fromIndex] == data2.key, "Layout.masonry: move key does not match current order")

			table.remove(v, data2.fromIndex)
			table.insert(v, data2.toIndex, data2.key)
		elseif data2.type == DataSourceChangeType.Reorder then
			v = table.clone(data2.keys)
		end

		markGeometryDirty() -- inferred equivalent call
		return true
	end

	local function setViewportCrossAxisLength(p: number): boolean
		if data.crossAxisItemLength == nil then
			return false
		end

		local crossAxisItemLength = data.crossAxisItemLength
		local v5 = math.max(1, (p + crossAxisSpacing) // (crossAxisItemLength + crossAxisSpacing))

		if v5 == crossAxisCount then
			return false
		end

		crossAxisCount = v5
		markGeometryDirty() -- inferred equivalent call
		return true
	end

	return {
		getItemCount = function()
			return #v
		end,
		getContentLength = function()
			rebuildGeometry()
			return contentLength
		end,
		getIntersectingIndexRange = function(p: number, p2: number)
			rebuildGeometry()

			if #v == 0 or p2 <= p then
				return Types.EMPTY_INDEX_RANGE
			end

			local firstIndex = nil
			local lastIndex = nil

			for i = 1, crossAxisCount do
				local v5, v6 = firstIntersectingInColumn(v3[i], p, p2)

				if v5 == nil then
					continue
				end

				if firstIndex == nil then
					firstIndex = v5
				else
					firstIndex = math.min(firstIndex, v5)
				end

				if lastIndex == nil then
					lastIndex = v6
				else
					lastIndex = math.max(lastIndex, v6)
				end
			end

			if firstIndex == nil then
				return Types.EMPTY_INDEX_RANGE
			end

			return { firstIndex = firstIndex, lastIndex = lastIndex }
		end,
		expandIndexRange = function(p, p2, p3)
			return staticParts.expandItemRange(p, p2, p3 or p2, #v)
		end,
		getItemLayout = function(p: number)
			rebuildGeometry()
			local itemLayout = v2[p]

			if itemLayout == nil then
				assert(false, `Layout.masonry: item index {p} is out of bounds`)
			end

			return itemLayout
		end,
		updateItemMeasurement = staticParts.updateItemMeasurementNoop,
		requiresItemMeasurement = staticParts.requiresItemMeasurementFalse,
		applyDataSourceChange = applyDataSourceChange,
		setViewportCrossAxisLength = setViewportCrossAxisLength,
		destroy = staticParts.noop
	}
end

return masonry
