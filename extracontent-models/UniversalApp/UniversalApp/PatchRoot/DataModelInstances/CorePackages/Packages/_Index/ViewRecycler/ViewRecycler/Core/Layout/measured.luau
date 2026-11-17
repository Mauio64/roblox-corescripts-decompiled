local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
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
	local getEstimatedItemLength

	if FFlagViewRecyclerReact084 then
		getEstimatedItemLength = v.getEstimatedItemLength
	else
		getEstimatedItemLength = nil
	end

	local v3 = CollapsedEstimatedTree.new(estimatedItemLength)
	local v4 = {}
	local v5 = {}
	local v6 = {}
	local v7 = 0
	local v8 = 0
	local v9 = nil
	local startOffset = 0
	local length2 = 0
	local v10, v11, v12, queueEstimate

	if FFlagViewRecyclerReact084 then
		v10 = {}
		v11 = {}
		v12 = {}

		queueEstimate = function(p: string, p2: number)
			if getEstimatedItemLength ~= nil then
				table.insert(v11, p)
				table.insert(v12, p2)
			end
		end
	else
		v10 = nil
		queueEstimate = nil
		v11 = nil
		v12 = nil
	end

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

	local function restoreActiveMeasurement(p: string) -- 3 equivalent calls inferred from this helper
		local v13 = v2.take(p)

		if v13 ~= nil then
			addActiveMeasurement(p, v13) -- inferred equivalent call
		end
	end

	local function detachActiveMeasurement(p: string) -- 2 equivalent calls inferred from this helper
		local v13 = v4[p]

		if v13 == nil then
			return
		end

		v4[p] = nil
		v7 -= v13
		v8 -= 1
		v2.put(p, v13)
	end

	local function getItemLayout(p: number)
		if v9 == p then
			return { startOffset = startOffset, length = length2 }
		end

		return { startOffset = v3.prefixSum(p), length = v3.getSize(p) }
	end

	local function getIntersectingIndexRange(p: number, p2: number)
		local length = v3.length()

		if length == 0 or p2 <= p then
			v9 = nil
			return Types.EMPTY_INDEX_RANGE
		end

		local entryAtPrefixSum, v13, v14 = v3.entryAtPrefixSum(p)
		local firstIndex = math.clamp(entryAtPrefixSum, 1, length)

		if entryAtPrefixSum == firstIndex then
			v9 = firstIndex
			startOffset = v13
			length2 = v14
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
	end

	local function updateItemMeasurement(data)
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

		local v13 = v4[itemKey]

		if v13 == length then
			return { accepted = true, geometryChanged = false }
		end

		v9 = nil

		if v13 == nil then
			addActiveMeasurement(itemKey, length) -- inferred equivalent call
		else
			v7 += length - v13
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
	end

	local function rebuildFromKeys(list)
		v6 = list

		if FFlagViewRecyclerReact084 then
			v3.buildFromMeasurements(#list, function(p)
				return v4[list[p]]
			end, getEstimatedItemLength ~= nil and function(p)
				return v10[list[p]]
			end or nil)
		else
			v3.buildFromMeasurements(#list, function(p)
				return v4[list[p]]
			end)
		end
	end

	local function applyReset(keys)
		local count = #keys
		local v13 = table.create(count)
		local set = {}

		for i = 1, count do
			local item = keys[i]

			if set[item] ~= nil then
				error(`Layout.measured: duplicate key "{item}"`, 2)
			end

			v13[i] = item
			set[item] = true
		end

		for k in set do
			if v5[k] == nil then
				restoreActiveMeasurement(k) -- inferred equivalent call
			end
		end

		for _, v14 in v6 do
			if set[v14] ~= nil then
				continue
			end

			detachActiveMeasurement(v14) -- inferred equivalent call

			if FFlagViewRecyclerReact084 then
				v10[v14] = nil
			end
		end

		v5 = set

		if FFlagViewRecyclerReact084 then
			for k, v14 in v13 do
				queueEstimate(v14, k)
			end
		end

		rebuildFromKeys(v13)
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

		if FFlagViewRecyclerReact084 then
			for k, item in keys do
				restoreActiveMeasurement(item) -- inferred equivalent call
				v5[item] = true
				queueEstimate(item, index + k - 1)
			end
		else
			for _, item in keys do
				restoreActiveMeasurement(item) -- inferred equivalent call
				v5[item] = true
			end
		end

		if v3.prefersIncremental(count) then
			for k, item in keys do
				local v13 = index + k - 1
				table.insert(v6, v13, item)
				v3.insert(v13, v4[item])
			end
		else
			local count2 = #v6
			local v13 = table.create(count2 + count)
			table.move(v6, 1, index - 1, 1, v13)

			for k, item in keys do
				v13[index + k - 1] = item
			end

			table.move(v6, index, count2, index + count, v13)
			rebuildFromKeys(v13)
		end
	end

	local function applyRemove(index: number, keys)
		local count = #keys

		for i = index, index + count - 1 do
			local v13 = v6[i]
			assert(v13 == keys[i - index + 1], "Layout.measured: remove keys do not match current order")
			v5[v13] = nil
			detachActiveMeasurement(v13) -- inferred equivalent call

			if FFlagViewRecyclerReact084 then
				v10[v13] = nil
			end
		end

		if v3.prefersIncremental(count) then
			for _ = 1, count do
				table.remove(v6, index)
				v3.remove(index)
			end
		else
			local count2 = #v6
			local v13 = table.create(count2 - count)
			table.move(v6, 1, index - 1, 1, v13)
			table.move(v6, index + count, count2, index, v13)
			rebuildFromKeys(v13)
		end
	end

	local function applyMove(fromIndex: number, toIndex: number, key: string)
		assert(v6[fromIndex] == key, "Layout.measured: move key does not match current order")
		table.remove(v6, fromIndex)
		v3.remove(fromIndex)
		table.insert(v6, toIndex, key)

		if FFlagViewRecyclerReact084 then
			v3.insert(toIndex, v4[key], v10[key])
		else
			v3.insert(toIndex, v4[key])
		end
	end

	local function applyReorder(keys)
		assert(#keys == #v6, "Layout.measured: reorder must contain every active key")
		local set = {}

		for _, item in keys do
			local v13 = v5[item] == true and set[item] == nil
			assert(v13, "Layout.measured: reorder must contain every active key once")

			set[item] = true
		end

		rebuildFromKeys(table.clone(keys))
	end

	local function applyDataSourceChange(data)
		v9 = nil
		local v13 = true

		if data.type == DataSourceChangeType.Reset then
			applyReset(data.keys)
			return true
		end

		if data.type == DataSourceChangeType.Insert then
			applyInsert(data.index, data.keys)
			return v13
		end

		if data.type == DataSourceChangeType.Remove then
			applyRemove(data.index, data.keys)
			return v13
		end

		if data.type == DataSourceChangeType.Update then
			v13 = false

			if FFlagViewRecyclerReact084 then
				for _, key in data.keys do
					queueEstimate(key, 0)
				end

				return false
			end
		elseif data.type == DataSourceChangeType.Move then
			applyMove(data.fromIndex, data.toIndex, data.key)
			return v13
		elseif data.type == DataSourceChangeType.Reorder then
			applyReorder(data.keys)
		end

		return v13
	end

	local readEstimate
	local resolveItemEstimates

	if FFlagViewRecyclerReact084 then
		readEstimate = function(p, p2: number)
			local estimatedItemLength2 = getEstimatedItemLength(p, p2)

			if estimatedItemLength2 == nil then
				return nil
			end

			local v13 = type(estimatedItemLength2) == "number"
				and estimatedItemLength2 >= 0
				and estimatedItemLength2 < 1e999
			assert(v13, "Layout.measured: getEstimatedItemLength must return nil or a finite, non-negative number")

			return estimatedItemLength2
		end

		resolveItemEstimates = function(callback)
			local count = #v11

			if count == 0 then
				return false
			end

			v9 = nil
			local v13 = nil

			for i = 1, count do
				local v14 = v11[i]

				if not (v5[v14] ~= nil and v6[v12[i]] ~= v14) then
					continue
				end

				v13 = v13 or {}
				v13[v14] = 0
			end

			if v13 ~= nil then
				for k, v14 in v6 do
					if v13[v14] ~= nil then
						v13[v14] = k
					end
				end
			end

			local v14 = not v3.prefersIncremental(count)
			local v15 = false

			for i = 1, count do
				local v16 = v11[i]

				if v5[v16] == nil then
					continue
				end

				local v17

				if v13 == nil or v13[v16] == nil then
					v17 = v12[i]
				else
					v17 = v13[v16]
				end

				local v18 = readEstimate(callback(v17), v17)

				if v14 then
					if not v15 then
						if v10[v16] == v18 then
							v15 = false
						else
							v15 = v4[v16] == nil
						end
					end
				else
					v15 = v3.setItemEstimate(v17, v18) or v15
				end

				v10[v16] = v18
			end

			table.clear(v11)
			table.clear(v12)

			if v14 then
				rebuildFromKeys(v6)
			end

			return v15
		end
	end

	local v13 = {
		getItemCount = function()
			return v3.length()
		end,
		getContentLength = function()
			return v3.totalSum()
		end,
		getIntersectingIndexRange = getIntersectingIndexRange,
		expandIndexRange = function(p, p2, p3)
			return staticParts.expandItemRange(p, p2, p3 or p2, v3.length())
		end,
		getItemLayout = getItemLayout,
		getItemLayouts = function(p: number, p2: number, p3)
			v3.fillRange(p, p2, p3)
		end,
		updateItemMeasurement = updateItemMeasurement,
		requiresItemMeasurement = function(): boolean
			return true
		end,
		isItemMeasured = function(p): boolean
			local v13 = v6[p]
			return v13 ~= nil and v4[v13] ~= nil
		end,
		applyDataSourceChange = applyDataSourceChange,
		resolveItemEstimates = 0,
		setViewportCrossAxisLength = 0,
		stackedSpacing = 0,
		destroy = 0
	}

	if FFlagViewRecyclerReact084 then
		if getEstimatedItemLength == nil then
			resolveItemEstimates = nil
		end
	else
		resolveItemEstimates = nil
	end

	v13.resolveItemEstimates = resolveItemEstimates

	v13.setViewportCrossAxisLength = staticParts.geometryUnchanged
	function v13.stackedSpacing(): number
		return 0
	end

	function v13.destroy() end
	return v13
end

return measured
