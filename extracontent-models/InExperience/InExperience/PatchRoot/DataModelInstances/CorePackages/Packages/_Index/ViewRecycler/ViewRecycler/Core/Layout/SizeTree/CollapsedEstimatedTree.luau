require(script.Parent.ISizeTree)
local WeightedOrderStatisticTree = require(script.Parent.WeightedOrderStatisticTree)

local CollapsedEstimatedTree = {}

local function concatenateMergingUnmeasured(p, p2)
	if p == nil then
		return p2
	end

	if p2 == nil then
		return p
	end

	local v, v2 = WeightedOrderStatisticTree.popMaximum(p)
	local v3, v4 = WeightedOrderStatisticTree.popMinimum(p2)

	if v2.measuredSize == nil and v4.measuredSize == nil then
		return WeightedOrderStatisticTree.join(
			v,
			WeightedOrderStatisticTree.newNode(v2.itemCount + v4.itemCount, nil),
			v3
		)
	end

	return WeightedOrderStatisticTree.concatenate(
		WeightedOrderStatisticTree.join(v, v2, nil),
		WeightedOrderStatisticTree.join(nil, v4, v3)
	)
end

local function concatenatePieces(left, p: number, p2, p3: number, right)
	if p > 0 then
		left = concatenateMergingUnmeasured(left, WeightedOrderStatisticTree.newNode(p, nil))
	end

	local v = concatenateMergingUnmeasured(left, p2)

	if p3 > 0 then
		v = concatenateMergingUnmeasured(v, WeightedOrderStatisticTree.newNode(p3, nil))
	end

	return (concatenateMergingUnmeasured(v, right))
end

local function growUnmeasuredRun(state, p: number)
	if state == nil then
		return nil, false
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

	if p <= nodeItemCount then
		local left, v = growUnmeasuredRun(state.left, p)
		state.left = left

		if v then
			WeightedOrderStatisticTree.refresh(state)
		end

		return state, v
	elseif nodeItemCount + state.itemCount < p then
		local right, v = growUnmeasuredRun(state.right, p - nodeItemCount - state.itemCount)
		state.right = right

		if v then
			WeightedOrderStatisticTree.refresh(state)
		end

		return state, v
	else
		if state.measuredSize ~= nil then
			return state, false
		end

		state.itemCount += 1
		WeightedOrderStatisticTree.refresh(state)
		return state, true
	end
end

local function shrinkUnmeasuredRun(state, p: number)
	if state == nil then
		return nil, false
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

	if p <= nodeItemCount then
		local left, v = shrinkUnmeasuredRun(state.left, p)
		state.left = left

		if v then
			WeightedOrderStatisticTree.refresh(state)
		end

		return state, v
	elseif nodeItemCount + state.itemCount < p then
		local right, v = shrinkUnmeasuredRun(state.right, p - nodeItemCount - state.itemCount)
		state.right = right

		if v then
			WeightedOrderStatisticTree.refresh(state)
		end

		return state, v
	else
		if state.measuredSize ~= nil or not (state.itemCount > 1) then
			return state, false
		end

		state.itemCount -= 1
		WeightedOrderStatisticTree.refresh(state)
		return state, true
	end
end

local function mergeAdjacentUnmeasured(state)
	if state.measuredSize == nil then
		if state.left ~= nil then
			local left, v = WeightedOrderStatisticTree.popMaximum(state.left)

			if v.measuredSize == nil then
				state.itemCount += v.itemCount
				state.left = left
			else
				state.left = WeightedOrderStatisticTree.join(left, v, nil)
			end
		end

		if state.right ~= nil then
			local right, v = WeightedOrderStatisticTree.popMinimum(state.right)

			if v.measuredSize == nil then
				state.itemCount += v.itemCount
				state.right = right
			else
				state.right = WeightedOrderStatisticTree.join(nil, v, right)
			end
		end
	end

	return WeightedOrderStatisticTree.balance(state)
end

local function measureAt(state, p: number, measuredSize: number)
	if state == nil then
		return nil
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

	if p <= nodeItemCount then
		state.left = measureAt(state.left, p, measuredSize)
		return mergeAdjacentUnmeasured(state)
	end

	if nodeItemCount + state.itemCount < p then
		state.right = measureAt(state.right, p - nodeItemCount - state.itemCount, measuredSize)
		return mergeAdjacentUnmeasured(state)
	end

	if state.itemCount == 1 then
		state.measuredSize = measuredSize
		return mergeAdjacentUnmeasured(state)
	end

	local v = p - nodeItemCount
	return concatenatePieces(
		state.left,
		v - 1,
		WeightedOrderStatisticTree.newNode(1, measuredSize),
		state.itemCount - v,
		state.right
	)
end

local function unmeasureAt(state, p: number)
	if state == nil then
		return nil
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

	if p <= nodeItemCount then
		state.left = unmeasureAt(state.left, p)
	elseif nodeItemCount + state.itemCount < p then
		state.right = unmeasureAt(state.right, p - nodeItemCount - state.itemCount)
	else
		assert(state.itemCount == 1, "CollapsedEstimatedTree: unmeasure requires a unit node")
		state.measuredSize = nil
	end

	return mergeAdjacentUnmeasured(state)
end

local function insertMeasuredAt(state, p: number, p2: number)
	if state == nil then
		return WeightedOrderStatisticTree.newNode(1, p2)
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

	if p <= nodeItemCount then
		state.left = insertMeasuredAt(state.left, p, p2)
		return mergeAdjacentUnmeasured(state)
	end

	if nodeItemCount + state.itemCount < p then
		state.right = insertMeasuredAt(state.right, p - nodeItemCount - state.itemCount, p2)
		return mergeAdjacentUnmeasured(state)
	end

	if state.measuredSize == nil then
		local v = p - nodeItemCount
		return concatenatePieces(
			state.left,
			v - 1,
			WeightedOrderStatisticTree.newNode(1, p2),
			state.itemCount - v + 1,
			state.right
		)
	end

	local left = state.left
	local right = state.right
	state.left = nil
	state.right = nil
	WeightedOrderStatisticTree.refresh(state)
	local node = WeightedOrderStatisticTree.newNode(1, p2)
	local concatenate = WeightedOrderStatisticTree.concatenate(state, right)
	return (concatenateMergingUnmeasured(concatenateMergingUnmeasured(left, node), concatenate))
end

function CollapsedEstimatedTree.new(value: number?)
	local v = nil
	local estimatedItemLength = value or 0

	local function length() -- 8 equivalent calls inferred from this helper
		return WeightedOrderStatisticTree.nodeItemCount(v)
	end

	local function getEntryAtPrefixSum(p: number)
		local v2 = length() -- inferred equivalent call

		if v2 == 0 then
			return 1, 0, 0
		end

		if p <= 0 then
			return 1, 0, WeightedOrderStatisticTree.measuredAt(v, 1) or estimatedItemLength
		end

		local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength)

		if nodeEffectiveSum <= p then
			return v2 + 1, nodeEffectiveSum, 0
		end

		return WeightedOrderStatisticTree.entryAtPrefixSum(v, p, estimatedItemLength)
	end

	return {
		prefixSum = function(p: number)
			if p <= 1 then
				return 0
			end

			return (WeightedOrderStatisticTree.prefixSumUpTo(v, p - 1, estimatedItemLength))
		end,
		indexAtPrefixSum = function(p: number)
			local v2 = length() -- inferred equivalent call

			if v2 == 0 or p <= 0 then
				return 1
			end

			if WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength) <= p then
				return v2 + 1
			end

			return (WeightedOrderStatisticTree.entryAtPrefixSum(v, p, estimatedItemLength))
		end,
		entryAtPrefixSum = getEntryAtPrefixSum,
		getSize = function(p: number)
			if p < 1 or length() < p then -- inferred equivalent call
				return 0
			end

			return WeightedOrderStatisticTree.measuredAt(v, p) or estimatedItemLength
		end,
		fillRange = function(p: number, p2: number, list)
			WeightedOrderStatisticTree.fillRangeFromNode(v, 0, 0, p, p2, estimatedItemLength, list)

			for i = #list, p2 - p + 2, -1 do
				list[i] = nil
			end
		end,
		update = function(p: number, p2: number?)
			if p < 1 or length() < p then -- inferred equivalent call
				return
			end

			local measuredAt = WeightedOrderStatisticTree.measuredAt(v, p)

			if measuredAt ~= nil and p2 ~= nil then
				v = WeightedOrderStatisticTree.updateAt(v, p, p2)
			elseif measuredAt == nil and p2 ~= nil then
				v = measureAt(v, p, p2)
			elseif measuredAt ~= nil and p2 == nil then
				v = unmeasureAt(v, p)
			end
		end,
		insert = function(p: number, p2: number?)
			local v2 = length() -- inferred equivalent call

			if v2 == 0 then
				v = WeightedOrderStatisticTree.newNode(1, p2)
				return
			end

			if p2 ~= nil then
				v = insertMeasuredAt(v, p, p2)
				return
			end

			if p <= v2 then
				local v3, v4 = growUnmeasuredRun(v, p)
				v = v3

				if v4 then
					return
				end
			end

			if p > 1 then
				local v3, v4 = growUnmeasuredRun(v, p - 1)
				v = v3

				if v4 then
					return
				end
			end

			local splitByItems, v3 = WeightedOrderStatisticTree.splitByItems(v, p - 1)
			v = concatenateMergingUnmeasured(
				concatenateMergingUnmeasured(splitByItems, WeightedOrderStatisticTree.newNode(1, nil)),
				v3
			)
		end,
		remove = function(p: number)
			if p < 1 or length() < p then -- inferred equivalent call
				return
			end

			local v2, v3 = shrinkUnmeasuredRun(v, p)
			v = v2

			if v3 then
				return
			end

			local splitByItems, v4 = WeightedOrderStatisticTree.splitByItems(v, p - 1)
			local _, v5 = WeightedOrderStatisticTree.splitByItems(v4, 1)
			v = concatenateMergingUnmeasured(splitByItems, v5)
		end,
		buildFromArray = function(list)
			local v2 = table.create(#list)

			for k, item in list do
				v2[k] = { itemCount = 1, measuredSize = item }
			end

			v = WeightedOrderStatisticTree.buildBalanced(v2, 1, #v2)
		end,
		buildFromMeasurements = function(p: number, callback)
			local v2 = {}

			for i = 1, p do
				local measuredSize = callback(i)
				local v3 = v2[#v2]

				if measuredSize == nil and v3 ~= nil and v3.measuredSize == nil then
					v3.itemCount += 1
				else
					table.insert(v2, { itemCount = 1, measuredSize = measuredSize })
				end
			end

			v = WeightedOrderStatisticTree.buildBalanced(v2, 1, #v2)
		end,
		toArray = function()
			local array = table.create(length())
			WeightedOrderStatisticTree.appendToArray(v, array, estimatedItemLength)
			return array
		end,
		setEstimatedItemLength = function(p: number)
			local v2

			if estimatedItemLength == p then
				v2 = false
			else
				v2 = WeightedOrderStatisticTree.nodeMeasuredCount(v) < length() -- inferred equivalent call
			end

			estimatedItemLength = p
			return v2
		end,
		getEstimatedItemLength = function()
			return estimatedItemLength
		end,
		getMeasuredItemCount = function()
			return WeightedOrderStatisticTree.nodeMeasuredCount(v)
		end,
		prefersIncremental = function(p: number): boolean
			local v2 = length() -- inferred equivalent call
			return v2 ~= 0 and p * math.log(math.max(WeightedOrderStatisticTree.nodeCount(v), 2), 2) < v2
		end,
		length = length,
		totalSum = function()
			return WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength)
		end,
		getNodeCount = function()
			return WeightedOrderStatisticTree.nodeCount(v)
		end
	}
end

return CollapsedEstimatedTree
