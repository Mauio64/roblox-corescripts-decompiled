local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AveragePropagation = require(ViewRecycler.Core.Layout.Policies.AveragePropagation)
local CollapsedEstimatedTree = require(ViewRecycler.Core.Layout.SizeTree.CollapsedEstimatedTree)
local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
local DetachedMeasurementCache = require(ViewRecycler.Core.Layout.Policies.DetachedMeasurementCache)
require(ViewRecycler.Core.Layout.LayoutRuntime)
local Types = require(ViewRecycler.Core.Types)
local createDebugLogger = require(ViewRecycler.Internal.createDebugLogger)
local staticParts = require(ViewRecycler.Core.Layout.staticParts)

local debugLogger = createDebugLogger("Layout.measured")

local function measured(options)
	local v = options or {}
	local estimatedItemLength = v.estimatedItemLength or 50
	local estimationPolicy = v.estimationPolicy or AveragePropagation.new({
		initialAverage = estimatedItemLength
	})
	local v2 = DetachedMeasurementCache.new(v.detachedMeasurementCapacity)

	local v3 = CollapsedEstimatedTree.new(estimatedItemLength)
	local v4 = {}
	local v5 = {}
	local v6 = {}
	local v7 = 0
	local v8 = 0
	local v9 = nil
	local startOffset = 0
	local length2 = 0

	local function average() -- 3 equivalent calls inferred from this helper
		if v8 > 0 then
			return v7 / v8
		end

		return estimatedItemLength
	end

	local function addActiveMeasurement(p: string, p2: number) -- 2 equivalent calls inferred from this helper
		v4[p] = p2
		v7 += p2
		v8 += 1
	end

	local function restoreActiveMeasurement(p: string) -- 2 equivalent calls inferred from this helper
		local v10 = v2.take(p)

		if v10 ~= nil then
			addActiveMeasurement(p, v10) -- inferred equivalent call
		end
	end

	local function detachActiveMeasurement(p: string) -- 2 equivalent calls inferred from this helper
		local v10 = v4[p]

		if v10 == nil then
			return
		end

		v4[p] = nil
		v7 -= v10
		v8 -= 1
		v2.put(p, v10)
	end

	local function rebuildFromKeys(list) -- 4 equivalent calls inferred from this helper
		v6 = list
		v3.buildFromMeasurements(#list, function(p)
			return v4[list[p]]
		end)
	end

	local function applyReset(keys)
		local count = #keys
		local v10 = table.create(count)
		local set = {}

		for i = 1, count do
			local item = keys[i]

			if set[item] ~= nil then
				error(`Layout.measured: duplicate key "{item}"`, 2)
			end

			v10[i] = item
			set[item] = true
		end

		for k in set do
			if v5[k] == nil then
				restoreActiveMeasurement(k) -- inferred equivalent call
			end
		end

		for _, v11 in v6 do
			if set[v11] == nil then
				detachActiveMeasurement(v11) -- inferred equivalent call
			end
		end

		v5 = set
		rebuildFromKeys(v10) -- inferred equivalent call
	end

	local function applyInsert(index: number, keys)
		local count = #keys
		local set = {}

		for i = 0, count - 1 do
			local item = keys[i + 1]

			if v5[item] ~= nil or set[item] ~= nil then
				error(`Layout.measured: duplicate key "{item}"`, 2)
			end

			set[item] = true
		end

		for _, item in keys do
			restoreActiveMeasurement(item) -- inferred equivalent call
			v5[item] = true
		end

		if v3.prefersIncremental(count) then
			for k, item in keys do
				local v10 = index + k - 1
				table.insert(v6, v10, item)
				v3.insert(v10, v4[item])
			end
		else
			local count2 = #v6
			local v10 = table.create(count2 + count)
			table.move(v6, 1, index - 1, 1, v10)

			for k, item in keys do
				v10[index + k - 1] = item
			end

			table.move(v6, index, count2, index + count, v10)
			rebuildFromKeys(v10) -- inferred equivalent call
		end
	end

	local function applyRemove(index: number, keys)
		local count = #keys

		for i = index, index + count - 1 do
			local v10 = v6[i]
			assert(v10 == keys[i - index + 1], "Layout.measured: remove keys do not match current order")
			v5[v10] = nil
			detachActiveMeasurement(v10) -- inferred equivalent call
		end

		if v3.prefersIncremental(count) then
			for _ = 1, count do
				table.remove(v6, index)
				v3.remove(index)
			end
		else
			local count2 = #v6
			local v10 = table.create(count2 - count)
			table.move(v6, 1, index - 1, 1, v10)
			table.move(v6, index + count, count2, index, v10)
			rebuildFromKeys(v10) -- inferred equivalent call
		end
	end

	local function applyMove(fromIndex: number, toIndex: number, key: string) -- 1 equivalent call inferred from this helper
		assert(v6[fromIndex] == key, "Layout.measured: move key does not match current order")
		table.remove(v6, fromIndex)
		v3.remove(fromIndex)
		table.insert(v6, toIndex, key)
		v3.insert(toIndex, v4[key])
	end

	local function applyReorder(keys)
		assert(#keys == #v6, "Layout.measured: reorder must contain every active key")
		local set = {}

		for _, item in keys do
			local v10 = v5[item] == true and set[item] == nil
			assert(v10, "Layout.measured: reorder must contain every active key once")

			set[item] = true
		end

		rebuildFromKeys(table.clone(keys)) -- inferred equivalent call
	end

	return {
		getItemCount = function()
			return v3.length()
		end,
		getContentLength = function()
			return v3.totalSum()
		end,
		getIntersectingIndexRange = function(p: number, p2: number)
			local length = v3.length()

			if length == 0 or p2 <= p then
				v9 = nil
				return Types.EMPTY_INDEX_RANGE
			end

			local entryAtPrefixSum, v10, v11 = v3.entryAtPrefixSum(p)
			local firstIndex = math.clamp(entryAtPrefixSum, 1, length)

			if entryAtPrefixSum == firstIndex then
				v9 = firstIndex
				startOffset = v10
				length2 = v11
			else
				v9 = nil
			end

			local lastIndex = math.clamp(v3.indexAtPrefixSum(p2), firstIndex, length)

			if p2 <= v3.prefixSum(lastIndex) then
				lastIndex -= 1
			end

			if lastIndex < firstIndex then
				return Types.EMPTY_INDEX_RANGE
			end

			return { firstIndex = firstIndex, lastIndex = lastIndex }
		end,
		expandIndexRange = function(p, p2, p3)
			return staticParts.expandItemRange(p, p2, p3 or p2, v3.length())
		end,
		getItemLayout = function(p: number)
			if v9 == p then
				return { startOffset = startOffset, length = length2 }
			end

			return { startOffset = v3.prefixSum(p), length = v3.getSize(p) }
		end,
		getItemLayouts = function(p: number, p2: number, p3)
			v3.fillRange(p, p2, p3)
		end,
		updateItemMeasurement = function(data)
			local itemIndex = data.itemIndex
			local itemKey = data.itemKey
			local length = data.length

			if v6[itemIndex] ~= itemKey then
				debugLogger(
					"measurement DROPPED key=%s index=%d (index now holds %s)",
					itemKey,
					itemIndex,
					(tostring(v6[itemIndex]))
				)
				return { accepted = false, geometryChanged = false }
			end

			local v10 = v4[itemKey]

			if v10 == length then
				return { accepted = true, geometryChanged = false }
			end

			v9 = nil

			if v10 == nil then
				addActiveMeasurement(itemKey, length) -- inferred equivalent call
			else
				v7 += length - v10
				v4[itemKey] = length
			end

			local geometryChanged = v3.getSize(itemIndex) ~= length

			v3.update(itemIndex, length)

			if estimationPolicy.recordMeasurementAndShouldUpdateEstimates(average()) then -- inferred equivalent call
				geometryChanged = v3.setEstimatedItemLength((math.round(average()))) or geometryChanged -- inferred equivalent call
			end

			debugLogger(
				"measurement key=%s index=%d length=%.1f (avg=%.2f, changed=%s)",
				itemKey,
				itemIndex,
				length,
				average(), -- inferred equivalent call
				(tostring(geometryChanged))
			)

			return { accepted = true, geometryChanged = geometryChanged }
		end,
		requiresItemMeasurement = function(): boolean
			return true
		end,
		isItemMeasured = function(p): boolean
			local v10 = v6[p]
			return v10 ~= nil and v4[v10] ~= nil
		end,
		applyDataSourceChange = function(data)
			v9 = nil
			local v10 = true

			if data.type == DataSourceChangeType.Reset then
				applyReset(data.keys)
				return true
			end

			if data.type == DataSourceChangeType.Insert then
				applyInsert(data.index, data.keys)
				return v10
			end

			if data.type == DataSourceChangeType.Remove then
				applyRemove(data.index, data.keys)
				return v10
			end

			if data.type == DataSourceChangeType.Update then
				return false
			end

			if data.type == DataSourceChangeType.Move then
				applyMove(data.fromIndex, data.toIndex, data.key) -- inferred equivalent call
			elseif data.type == DataSourceChangeType.Reorder then
				applyReorder(data.keys)
			end

			return v10
		end,
		setViewportCrossAxisLength = staticParts.geometryUnchanged,
		stackedSpacing = function(): number
			return 0
		end,
		destroy = function() end
	}
end

return measured
