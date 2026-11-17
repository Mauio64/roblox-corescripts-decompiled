local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
require(script.Parent.ISizeTree)
local WeightedOrderStatisticTree = require(script.Parent.WeightedOrderStatisticTree)

local CollapsedEstimatedTree = {}

local isSameRun = FFlagViewRecyclerReact084 and function(p, p2): boolean
	return p.measuredSize == nil and p2.measuredSize == nil and p.estimatedSize == p2.estimatedSize
end or nil

local function concatenateMergingUnmeasured(p, p2)
	if p == nil then
		return p2
	end

	if p2 == nil then
		return p
	end

	local v, v2 = WeightedOrderStatisticTree.popMaximum(p)
	local v3, v4 = WeightedOrderStatisticTree.popMinimum(p2)
	local v5

	if FFlagViewRecyclerReact084 then
		v5 = isSameRun(v2, v4)
	elseif v2.measuredSize == nil then
		v5 = v4.measuredSize == nil
	else
		v5 = false
	end

	if not v5 then
		return WeightedOrderStatisticTree.concatenate(
			WeightedOrderStatisticTree.join(v, v2, nil),
			WeightedOrderStatisticTree.join(nil, v4, v3)
		)
	end

	local join = WeightedOrderStatisticTree.join
	local v6

	if FFlagViewRecyclerReact084 then
		v6 = WeightedOrderStatisticTree.newNode(v2.itemCount + v4.itemCount, nil, v2.estimatedSize)
	else
		v6 = WeightedOrderStatisticTree.newNode(v2.itemCount + v4.itemCount, nil)
	end

	return join(v, v6, v3)
end

local concatenatePieces, growUnmeasuredRun

if FFlagViewRecyclerReact084 then
	concatenatePieces = function(p, p2: number, p3, p4: number, p5, p6: number?)
		if p2 > 0 then
			p = concatenateMergingUnmeasured(p, WeightedOrderStatisticTree.newNode(p2, nil, p6))
		end

		local v = concatenateMergingUnmeasured(p, p3)

		if p4 > 0 then
			v = concatenateMergingUnmeasured(v, WeightedOrderStatisticTree.newNode(p4, nil, p6))
		end

		return (concatenateMergingUnmeasured(v, p5))
	end

	growUnmeasuredRun = function(state, p: number, p2: number?)
		if state == nil then
			return nil, false
		end

		local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

		if p <= nodeItemCount then
			local left, v = growUnmeasuredRun(state.left, p, p2)
			state.left = left

			if v then
				WeightedOrderStatisticTree.refresh(state)
			end

			return state, v
		elseif nodeItemCount + state.itemCount < p then
			local right, v = growUnmeasuredRun(state.right, p - nodeItemCount - state.itemCount, p2)
			state.right = right

			if v then
				WeightedOrderStatisticTree.refresh(state)
			end

			return state, v
		else
			if state.measuredSize ~= nil or state.estimatedSize ~= p2 then
				return state, false
			end

			state.itemCount += 1
			WeightedOrderStatisticTree.refresh(state)
			return state, true
		end
	end
else
	concatenatePieces = function(p, p2: number, p3, p4: number, p5)
		if p2 > 0 then
			p = concatenateMergingUnmeasured(p, WeightedOrderStatisticTree.newNode(p2, nil))
		end

		local v = concatenateMergingUnmeasured(p, p3)

		if p4 > 0 then
			v = concatenateMergingUnmeasured(v, WeightedOrderStatisticTree.newNode(p4, nil))
		end

		return (concatenateMergingUnmeasured(v, p5))
	end

	growUnmeasuredRun = function(state, p: number)
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
			local v2

			if FFlagViewRecyclerReact084 then
				v2 = isSameRun(state, v)
			else
				v2 = v.measuredSize == nil
			end

			if v2 then
				state.itemCount += v.itemCount
				state.left = left
			else
				state.left = WeightedOrderStatisticTree.join(left, v, nil)
			end
		end

		if state.right ~= nil then
			local right, v = WeightedOrderStatisticTree.popMinimum(state.right)
			local v2

			if FFlagViewRecyclerReact084 then
				v2 = isSameRun(state, v)
			else
				v2 = v.measuredSize == nil
			end

			if v2 then
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

	if FFlagViewRecyclerReact084 then
		return concatenatePieces(
			state.left,
			v - 1,
			WeightedOrderStatisticTree.newNode(1, measuredSize, state.estimatedSize),
			state.itemCount - v,
			state.right,
			state.estimatedSize
		)
	end

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

local insertMeasuredAt

if FFlagViewRecyclerReact084 then
	insertMeasuredAt = function(state, p: number, p2: number, p3: number?)
		if state == nil then
			return WeightedOrderStatisticTree.newNode(1, p2, p3)
		end

		local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(state.left)

		if p <= nodeItemCount then
			state.left = insertMeasuredAt(state.left, p, p2, p3)
			return mergeAdjacentUnmeasured(state)
		end

		if nodeItemCount + state.itemCount < p then
			state.right = insertMeasuredAt(state.right, p - nodeItemCount - state.itemCount, p2, p3)
			return mergeAdjacentUnmeasured(state)
		end

		if state.measuredSize == nil then
			local v = p - nodeItemCount
			return concatenatePieces(
				state.left,
				v - 1,
				WeightedOrderStatisticTree.newNode(1, p2, p3),
				state.itemCount - v + 1,
				state.right,
				state.estimatedSize
			)
		end

		local left = state.left
		local right = state.right
		state.left = nil
		state.right = nil
		WeightedOrderStatisticTree.refresh(state)
		return concatenatePieces(
			left,
			0,
			WeightedOrderStatisticTree.newNode(1, p2, p3),
			0,
			WeightedOrderStatisticTree.concatenate(state, right)
		)
	end
else
	insertMeasuredAt = function(state, p: number, p2: number)
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
		return concatenatePieces(
			left,
			0,
			WeightedOrderStatisticTree.newNode(1, p2),
			0,
			WeightedOrderStatisticTree.concatenate(state, right)
		)
	end
end

function CollapsedEstimatedTree.new(value: number?)
	local v = nil
	local estimatedItemLength = value or 0

	local function length() -- 10 equivalent calls inferred from this helper
		return WeightedOrderStatisticTree.nodeItemCount(v)
	end

	local function prefixSum(p: number)
		if p <= 1 then
			return 0
		end

		return (WeightedOrderStatisticTree.prefixSumUpTo(v, p - 1, estimatedItemLength))
	end

	local function indexAtPrefixSum(p: number)
		local v2 = length() -- inferred equivalent call

		if v2 == 0 or p <= 0 then
			return 1
		end

		if WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength) <= p then
			return v2 + 1
		end

		return (WeightedOrderStatisticTree.entryAtPrefixSum(v, p, estimatedItemLength))
	end

	local function getEntryAtPrefixSum(p: number)
		local v2 = length() -- inferred equivalent call

		if v2 == 0 then
			return 1, 0, 0
		end

		if p <= 0 then
			if FFlagViewRecyclerReact084 then
				return 1, 0, WeightedOrderStatisticTree.unitSizeAt(v, 1, estimatedItemLength)
			end

			return 1, 0, WeightedOrderStatisticTree.measuredAt(v, 1) or estimatedItemLength
		else
			local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength)

			if nodeEffectiveSum <= p then
				return v2 + 1, nodeEffectiveSum, 0
			end

			return WeightedOrderStatisticTree.entryAtPrefixSum(v, p, estimatedItemLength)
		end
	end

	local function getSize(p: number) -- 2 equivalent calls inferred from this helper
		if p < 1 or length() < p then -- inferred equivalent call
			return 0
		end

		if FFlagViewRecyclerReact084 then
			return WeightedOrderStatisticTree.unitSizeAt(v, p, estimatedItemLength)
		end

		return WeightedOrderStatisticTree.measuredAt(v, p) or estimatedItemLength
	end

	local function fillRange(p: number, p2: number, list)
		WeightedOrderStatisticTree.fillRangeFromNode(v, 0, 0, p, p2, estimatedItemLength, list)

		for i = #list, p2 - p + 2, -1 do
			list[i] = nil
		end
	end

	local function update(p: number, p2: number?)
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
	end

	local insert

	if FFlagViewRecyclerReact084 then
		insert = function(p: number, p2: number?, p3: number?)
			local v2 = length() -- inferred equivalent call

			if v2 == 0 then
				v = WeightedOrderStatisticTree.newNode(1, p2, p3)
				return
			end

			if p2 ~= nil then
				v = insertMeasuredAt(v, p, p2, p3)
				return
			end

			if p <= v2 then
				local v3, v4 = growUnmeasuredRun(v, p, p3)
				v = v3

				if v4 then
					return
				end
			end

			if p > 1 then
				local v3, v4 = growUnmeasuredRun(v, p - 1, p3)
				v = v3

				if v4 then
					return
				end
			end

			local splitByItems, v3 = WeightedOrderStatisticTree.splitByItems(v, p - 1)
			v = concatenateMergingUnmeasured(
				concatenateMergingUnmeasured(splitByItems, WeightedOrderStatisticTree.newNode(1, nil, p3)),
				v3
			)
		end
	else
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
		end
	end

	local function remove(p: number)
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
	end

	local setItemEstimate = nil
	local buildFromMeasurements

	if FFlagViewRecyclerReact084 then
		setItemEstimate = function(p: number, p2: number?): boolean
			if p < 1 or length() < p or WeightedOrderStatisticTree.estimatedAt(v, p) == p2 then -- inferred equivalent call
				return false
			end

			local measuredAt = WeightedOrderStatisticTree.measuredAt(v, p)
			local size = getSize(p) -- inferred equivalent call
			remove(p)
			insert(p, measuredAt, p2)
			return getSize(p) ~= size -- inferred equivalent call
		end

		buildFromMeasurements = function(p: number, callback, callback2)
			local v2 = {}

			for i = 1, p do
				local measuredSize = callback(i)
				local estimatedSize

				if callback2 ~= nil then
					estimatedSize = callback2(i)
				end

				local v3 = v2[#v2]

				if
					measuredSize == nil
					and v3 ~= nil
					and v3.measuredSize == nil
					and v3.estimatedSize == estimatedSize
				then
					v3.itemCount += 1
				else
					table.insert(v2, {
						itemCount = 1,
						measuredSize = measuredSize,
						estimatedSize = estimatedSize
					})
				end
			end

			v = WeightedOrderStatisticTree.buildBalanced(v2, 1, #v2)
		end
	else
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
		end
	end

	local v2 = {
		prefixSum = prefixSum,
		indexAtPrefixSum = indexAtPrefixSum,
		entryAtPrefixSum = getEntryAtPrefixSum,
		getSize = getSize,
		fillRange = fillRange,
		update = update,
		insert = insert,
		remove = remove,
		setItemEstimate = nil,
		buildFromArray = 0,
		buildFromMeasurements = 0,
		toArray = 0,
		setEstimatedItemLength = 0,
		getEstimatedItemLength = 0,
		getMeasuredItemCount = 0,
		prefersIncremental = 0,
		length = 0,
		totalSum = 0,
		getNodeCount = 0
	}

	if not FFlagViewRecyclerReact084 then
		setItemEstimate = nil
	end

	v2.setItemEstimate = setItemEstimate
	function v2.buildFromArray(list)
		local v3 = table.create(#list)

		for k, item in list do
			v3[k] = { itemCount = 1, measuredSize = item }
		end

		v = WeightedOrderStatisticTree.buildBalanced(v3, 1, #v3)
	end
	v2.buildFromMeasurements = buildFromMeasurements
	function v2.toArray()
		local array = table.create(length())
		WeightedOrderStatisticTree.appendToArray(v, array, estimatedItemLength)
		return array
	end

	function v2.setEstimatedItemLength(p: number)
		local v3

		if estimatedItemLength == p then
			v3 = false
		else
			local v4

			if FFlagViewRecyclerReact084 then
				v4 = WeightedOrderStatisticTree.nodeFixedCount
			else
				v4 = WeightedOrderStatisticTree.nodeMeasuredCount
			end

			v3 = v4(v) < length() -- inferred equivalent call
		end

		estimatedItemLength = p
		return v3
	end

	function v2.getEstimatedItemLength()
		return estimatedItemLength
	end

	function v2.getMeasuredItemCount()
		return WeightedOrderStatisticTree.nodeMeasuredCount(v)
	end

	function v2.prefersIncremental(p: number): boolean
		local v3 = length() -- inferred equivalent call
		return v3 ~= 0 and p * math.log(math.max(WeightedOrderStatisticTree.nodeCount(v), 2), 2) < v3
	end

	v2.length = length
	function v2.totalSum()
		return WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength)
	end

	function v2.getNodeCount()
		return WeightedOrderStatisticTree.nodeCount(v)
	end

	return v2
end

return CollapsedEstimatedTree
