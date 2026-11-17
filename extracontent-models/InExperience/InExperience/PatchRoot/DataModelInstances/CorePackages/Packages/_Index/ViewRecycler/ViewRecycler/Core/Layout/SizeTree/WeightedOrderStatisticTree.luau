local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084

local function nodeHeight(p) -- 12 equivalent calls inferred from this helper
	return if p == nil then 0 else p.height
end

local function nodeItemCount(p) -- 14 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeItemCount
end

local function nodeMeasuredCount(p) -- 2 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeMeasuredCount
end

local nodeFixedCount
local nodeMeasuredSum

if FFlagViewRecyclerReact084 then
	nodeFixedCount = function(p)
		return if p == nil then 0 else p.subtreeFixedCount
	end
else
	nodeMeasuredSum = function(p)
		return if p == nil then 0 else p.subtreeMeasuredSum
	end
end

local function nodeCount(p) -- 2 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeNodeCount
end

local function nodeEffectiveSum(left, p: number) -- 3 equivalent calls inferred from this helper
	if left == nil then
		return 0
	end

	local v

	if FFlagViewRecyclerReact084 then
		v = left.subtreeFixedSum
	else
		v = left.subtreeMeasuredSum
	end

	local subtreeItemCount = left.subtreeItemCount
	local v2

	if FFlagViewRecyclerReact084 then
		v2 = left.subtreeFixedCount
	else
		v2 = left.subtreeMeasuredCount
	end

	return v + (subtreeItemCount - v2) * p
end

local unitSize = FFlagViewRecyclerReact084 and function(p, p2: number)
	return p.measuredSize or p.estimatedSize or p2
end or nil

local function ownEffectiveSum(data, p: number)
	if data.measuredSize ~= nil then
		return data.measuredSize
	end

	local itemCount = data.itemCount
	p = FFlagViewRecyclerReact084 and data.estimatedSize or p
	return itemCount * p
end

local function refresh(state)
	local subtreeItemCount, measuredSize

	if FFlagViewRecyclerReact084 then
		subtreeItemCount = state.itemCount
		measuredSize = state.measuredSize
	end

	local v

	if FFlagViewRecyclerReact084 then
		v = subtreeItemCount
	else
		v = state.itemCount
	end

	assert(v >= 1, "WeightedOrderStatisticTree: node itemCount must be positive")

	local v2 = true
	local v3

	if FFlagViewRecyclerReact084 then
		v3 = measuredSize
	else
		v3 = state.measuredSize
	end

	if v3 ~= nil then
		local v4

		if FFlagViewRecyclerReact084 then
			v4 = subtreeItemCount
		else
			v4 = state.itemCount
		end

		v2 = v4 == 1
	end

	assert(v2, "WeightedOrderStatisticTree: measured nodes must represent exactly one item")
	local subtreeMeasuredCount, subtreeFixedCount, subtreeFixedSum, subtreeNodeCount, v4, v5

	if FFlagViewRecyclerReact084 then
		subtreeMeasuredCount = 0
		subtreeFixedCount = 0
		subtreeFixedSum = 0
		subtreeNodeCount = 1
		v4 = 0
		v5 = 0

		if measuredSize == nil then
			local estimatedSize = state.estimatedSize

			if estimatedSize ~= nil then
				subtreeFixedSum = subtreeItemCount * estimatedSize
				subtreeFixedCount = subtreeItemCount
			end
		else
			subtreeFixedSum = measuredSize
			subtreeMeasuredCount = 1
			subtreeFixedCount = 1
		end

		local left = state.left

		if left ~= nil then
			subtreeItemCount += left.subtreeItemCount
			subtreeMeasuredCount += left.subtreeMeasuredCount
			subtreeFixedCount += left.subtreeFixedCount
			subtreeFixedSum += left.subtreeFixedSum
			subtreeNodeCount += left.subtreeNodeCount
			v4 = left.height
		end

		local right = state.right

		if right ~= nil then
			subtreeItemCount += right.subtreeItemCount
			subtreeMeasuredCount += right.subtreeMeasuredCount
			subtreeFixedCount += right.subtreeFixedCount
			subtreeFixedSum += right.subtreeFixedSum
			subtreeNodeCount += right.subtreeNodeCount
			v5 = right.height
		end
	else
		subtreeItemCount = nil
	end

	if not FFlagViewRecyclerReact084 then
		subtreeItemCount = nodeItemCount(state.left) + state.itemCount + nodeItemCount(state.right) -- inferred equivalent call
	end

	state.subtreeItemCount = subtreeItemCount

	if not FFlagViewRecyclerReact084 then
		subtreeMeasuredCount = nodeMeasuredCount(state.left) + (state.measuredSize == nil and 0 or 1) + nodeMeasuredCount(state.right) -- inferred equivalent call
	end

	state.subtreeMeasuredCount = subtreeMeasuredCount

	if FFlagViewRecyclerReact084 then
		state.subtreeFixedCount = subtreeFixedCount
		state.subtreeFixedSum = subtreeFixedSum
	else
		state.subtreeMeasuredSum = nodeMeasuredSum(state.left) + (state.measuredSize or 0) + nodeMeasuredSum(state.right)
	end

	if not FFlagViewRecyclerReact084 then
		subtreeNodeCount = nodeCount(state.left) + 1 + nodeCount(state.right) -- inferred equivalent call
	end

	state.subtreeNodeCount = subtreeNodeCount

	if FFlagViewRecyclerReact084 then
		if v5 < v4 then
			v5 = v4
		end
	else
		v5 = math.max(nodeHeight(state.left), nodeHeight(state.right)) -- inferred equivalent call
	end

	state.height = 1 + v5
end

local newNode

if FFlagViewRecyclerReact084 then
	newNode = function(p: number, measuredSize: number?, estimatedSize: number?)
		local node = {
			itemCount = p,
			measuredSize = measuredSize,
			estimatedSize = estimatedSize,
			subtreeItemCount = p,
			subtreeMeasuredCount = 0,
			subtreeFixedCount = 0,
			subtreeFixedSum = 0,
			subtreeNodeCount = 1,
			height = 1,
			left = nil,
			right = nil
		}

		refresh(node)
		return node
	end
else
	newNode = function(p: number, measuredSize: number?)
		local node = {
			itemCount = p,
			measuredSize = measuredSize,
			subtreeItemCount = p,
			subtreeMeasuredCount = measuredSize == nil and 0 or 1,
			subtreeMeasuredSum = measuredSize or 0,
			subtreeNodeCount = 1,
			height = 1,
			left = nil,
			right = nil
		}

		refresh(node)
		return node
	end
end

local function rotateRight(right) -- 2 equivalent calls inferred from this helper
	local left = right.left
	right.left = left.right
	left.right = right
	refresh(right)
	refresh(left)
	return left
end

local function rotateLeft(left) -- 2 equivalent calls inferred from this helper
	local right = left.right
	left.right = right.left
	right.left = left
	refresh(left)
	refresh(right)
	return right
end

local function balance(state)
	refresh(state)
	local v = nodeHeight(state.left) - nodeHeight(state.right) -- inferred equivalent call

	if v > 1 then
		local left = state.left

		if nodeHeight(left.left) < nodeHeight(left.right) then -- inferred equivalent call
			state.left = rotateLeft(left) -- inferred equivalent call
		end

		return rotateRight(state) -- inferred equivalent call
	else
		if not (v < -1) then
			return state
		end

		local right = state.right

		if nodeHeight(right.right) < nodeHeight(right.left) then -- inferred equivalent call
			state.right = rotateRight(right) -- inferred equivalent call
		end

		return rotateLeft(state) -- inferred equivalent call
	end
end

local function join(left, p, right)
	if nodeHeight(left) > nodeHeight(right) + 1 then -- inferred equivalent call
		left.right = join(left.right, p, right)
		return (balance(left))
	end

	if nodeHeight(right) > nodeHeight(left) + 1 then -- inferred equivalent call
		right.left = join(left, p, right.left)
		return (balance(right))
	end

	p.left = left
	p.right = right
	return (balance(p))
end

local function popMinimum(left)
	if left.left == nil then
		local right = left.right
		left.left = nil
		left.right = nil
		refresh(left)
		return right, left
	else
		local left2, v = popMinimum(left.left)
		left.left = left2
		return balance(left), v
	end
end

local function popMaximum(right)
	if right.right == nil then
		local left = right.left
		right.left = nil
		right.right = nil
		refresh(right)
		return left, right
	else
		local right2, v = popMaximum(right.right)
		right.right = right2
		return balance(right), v
	end
end

local function concatenate(left, state) -- 3 equivalent calls inferred from this helper
	if left == nil then
		return state
	end

	if state == nil then
		return left
	end

	local v, v2

	if state.left == nil then
		v = state.right
		state.left = nil
		state.right = nil
		refresh(state)
		v2 = state
	else
		local left2
		left2, v2 = popMinimum(state.left)
		state.left = left2
		v = balance(state)
	end

	return (join(left, v2, v))
end

local function splitByItems(state, p: number)
	if state == nil then
		return nil, nil
	end

	local v = nodeItemCount(state.left) -- inferred equivalent call
	local v2 = v + state.itemCount

	if p < v then
		local v3, left = splitByItems(state.left, p)
		state.left = left
		return v3, (balance(state))
	elseif v2 < p then
		local right, v3 = splitByItems(state.right, p - v2)
		state.right = right
		return balance(state), v3
	elseif p == v then
		local left = state.left
		local right = state.right
		state.left = nil
		state.right = nil
		refresh(state)

		if state == nil then
			return left, right
		end

		if right == nil then
			return left, state
		end

		local v3, v4

		if right.left == nil then
			v3 = right.right
			right.left = nil
			right.right = nil
			refresh(right)
			v4 = right
		else
			local left2
			left2, v4 = popMinimum(right.left)
			right.left = left2
			v3 = balance(right)
		end

		return left, (join(state, v4, v3))
	elseif p == v2 then
		local left = state.left
		local right = state.right
		state.left = nil
		state.right = nil
		refresh(state)
		left = concatenate(left, state) -- inferred equivalent call
		return left, right
	else
		assert(state.measuredSize == nil, "WeightedOrderStatisticTree: cannot split a measured node")
		local v3 = p - v
		local v4 = state.itemCount - v3
		local left

		if FFlagViewRecyclerReact084 then
			left = state.left
			left = concatenate(left, newNode(v3, nil, state.estimatedSize)) -- inferred equivalent call
		else
			left = state.left
			left = concatenate(left, newNode(v3, nil)) -- inferred equivalent call
		end

		local v5

		if FFlagViewRecyclerReact084 then
			v5 = newNode(v4, nil, state.estimatedSize)
		else
			v5 = newNode(v4, nil)
		end

		local right = state.right

		if v5 == nil then
			return left, right
		end

		if right == nil then
			return left, v5
		end

		local v6, v7

		if right.left == nil then
			v6 = right.right
			right.left = nil
			right.right = nil
			refresh(right)
			v7 = right
		else
			local left2
			left2, v7 = popMinimum(right.left)
			right.left = left2
			v6 = balance(right)
		end

		return left, (join(v5, v7, v6))
	end
end

local insertUnitAt

if FFlagViewRecyclerReact084 then
	insertUnitAt = function(state, p: number, p2: number?, p3: number?)
		if state == nil then
			return newNode(1, p2, p3)
		end

		local v = nodeItemCount(state.left) + 1 -- inferred equivalent call

		if p <= v then
			state.left = insertUnitAt(state.left, p, p2, p3)
		else
			state.right = insertUnitAt(state.right, p - v, p2, p3)
		end

		return (balance(state))
	end
else
	insertUnitAt = function(state, p: number, p2: number?)
		if state == nil then
			return newNode(1, p2)
		end

		local v = nodeItemCount(state.left) + 1 -- inferred equivalent call

		if p <= v then
			state.left = insertUnitAt(state.left, p, p2)
		else
			state.right = insertUnitAt(state.right, p - v, p2)
		end

		return (balance(state))
	end
end

local function findMin(left)
	if left.left == nil then
		return left
	end

	return (findMin(left.left))
end

local function removeUnitAt(state, p: number)
	if state == nil then
		return nil
	end

	local v = nodeItemCount(state.left) + 1 -- inferred equivalent call

	if p < v then
		state.left = removeUnitAt(state.left, p)
	elseif v < p then
		state.right = removeUnitAt(state.right, p - v)
	else
		if state.left == nil then
			return state.right
		end

		if state.right == nil then
			return state.left
		end

		local v2 = state.right

		if v2.left ~= nil then
			v2 = findMin(v2.left)
		end

		state.measuredSize = v2.measuredSize

		if FFlagViewRecyclerReact084 then
			state.estimatedSize = v2.estimatedSize
		end

		state.itemCount = v2.itemCount
		state.right = removeUnitAt(state.right, 1)
	end

	return (balance(state))
end

local function updateUnitAt(state, p: number, measuredSize: number?)
	if state == nil then
		return
	end

	local v = nodeItemCount(state.left) + 1 -- inferred equivalent call

	if p < v then
		updateUnitAt(state.left, p, measuredSize)
	elseif v < p then
		updateUnitAt(state.right, p - v, measuredSize)
	else
		state.measuredSize = measuredSize
	end

	refresh(state)
end

local function updateAt(state, p: number, measuredSize: number?)
	if state == nil then
		return nil
	end

	local v = nodeItemCount(state.left) -- inferred equivalent call

	if p <= v then
		state.left = updateAt(state.left, p, measuredSize)
	elseif v + state.itemCount < p then
		state.right = updateAt(state.right, p - v - state.itemCount, measuredSize)
	else
		assert(state.itemCount == 1, "WeightedOrderStatisticTree: in-place update requires a unit node")
		state.measuredSize = measuredSize
	end

	refresh(state)
	return state
end

local function measuredAt(data, p: number)
	if data == nil then
		return nil
	end

	local v = nodeItemCount(data.left) -- inferred equivalent call

	if p <= v then
		return measuredAt(data.left, p)
	end

	if v + data.itemCount < p then
		return measuredAt(data.right, p - v - data.itemCount)
	end

	return data.measuredSize
end

local unitSizeAt, estimatedAt

if FFlagViewRecyclerReact084 then
	unitSizeAt = function(data, p: number, p2: number)
		if data == nil then
			return p2
		end

		local v = nodeItemCount(data.left) -- inferred equivalent call

		if p <= v then
			return unitSizeAt(data.left, p, p2)
		end

		if v + data.itemCount < p then
			return unitSizeAt(data.right, p - v - data.itemCount, p2)
		end

		return unitSize(data, p2)
	end

	estimatedAt = function(data, p: number)
		if data == nil then
			return nil
		end

		local v = nodeItemCount(data.left) -- inferred equivalent call

		if p <= v then
			return estimatedAt(data.left, p)
		end

		if v + data.itemCount < p then
			return estimatedAt(data.right, p - v - data.itemCount)
		end

		return data.estimatedSize
	end
else
	estimatedAt = nil
	unitSizeAt = nil
end

local function prefixSumUpTo(data, p: number, p2: number)
	if data == nil or p <= 0 then
		return 0
	end

	local v = nodeItemCount(data.left) -- inferred equivalent call

	if p <= v then
		return prefixSumUpTo(data.left, p, p2)
	end

	local v2 = math.min(data.itemCount, p - v)
	local v3

	if data.measuredSize == nil then
		local v4

		if FFlagViewRecyclerReact084 then
			v4 = data.estimatedSize or p2
		else
			v4 = p2
		end

		v3 = v2 * v4
	else
		v3 = data.measuredSize
	end

	local v4 = nodeEffectiveSum(data.left, p2) + v3 -- inferred equivalent call

	if p <= v + data.itemCount then
		return v4
	end

	return v4 + prefixSumUpTo(data.right, p - v - data.itemCount, p2)
end

local function entryAtPrefixSum(data, p: number, p2: number)
	if data == nil then
		return 0, 0, 0
	end

	local v = nodeEffectiveSum(data.left, p2) -- inferred equivalent call

	if p < v then
		return entryAtPrefixSum(data.left, p, p2)
	end

	local v2 = nodeItemCount(data.left) -- inferred equivalent call
	local v3

	if data.measuredSize == nil then
		local itemCount = data.itemCount
		local v4

		if FFlagViewRecyclerReact084 then
			v4 = data.estimatedSize or p2
		else
			v4 = p2
		end

		v3 = itemCount * v4
	else
		v3 = data.measuredSize
	end

	if p < v + v3 then
		if data.measuredSize ~= nil then
			return v2 + 1, v, data.measuredSize
		end

		local estimatedSize

		if FFlagViewRecyclerReact084 then
			estimatedSize = data.estimatedSize or p2
		end

		local v4 = p - v
		local v5

		if FFlagViewRecyclerReact084 then
			v5 = estimatedSize
		else
			v5 = p2
		end

		local v6 = math.floor(v4 / v5)
		local v7 = v2 + v6 + 1
		local v8

		if FFlagViewRecyclerReact084 then
			v8 = estimatedSize
		else
			v8 = p2
		end

		local v9 = v + v6 * v8

		if FFlagViewRecyclerReact084 then
			return v7, v9, estimatedSize
		end

		return v7, v9, p2
	else
		local v4, v5, v6 = entryAtPrefixSum(data.right, p - v - v3, p2)

		if v4 == 0 then
			return 0, 0, 0
		end

		return v2 + data.itemCount + v4, v + v3 + v5, v6
	end
end

local function fillRangeFromNode(left, p: number, p2: number, p3: number, p4: number, p5: number, p6)
	if left == nil then
		return
	end

	local v = p + nodeItemCount(left.left) + 1 -- inferred equivalent call
	local v2 = v + left.itemCount - 1
	local v3 = p2 + nodeEffectiveSum(left.left, p5) -- inferred equivalent call

	if p3 < v then
		fillRangeFromNode(left.left, p, p2, p3, p4, p5, p6)
	end

	local v4 = math.max(p3, v)
	local v5 = math.min(p4, v2)

	if v4 <= v5 then
		local length

		if FFlagViewRecyclerReact084 then
			length = unitSize(left, p5)
		else
			length = left.measuredSize or p5
		end

		for i = v4, v5 do
			local v6 = i - p3 + 1
			local v7 = p6[v6]

			if v7 == nil then
				v7 = { startOffset = 0, length = 0 }
				p6[v6] = v7
			end

			v7.startOffset = v3 + (i - v) * length
			v7.length = length
		end
	end

	if v2 < p4 then
		local right = left.right
		local v6

		if left.measuredSize == nil then
			local itemCount = left.itemCount
			local v7

			if FFlagViewRecyclerReact084 then
				v7 = left.estimatedSize or p5
			else
				v7 = p5
			end

			v6 = itemCount * v7
		else
			v6 = left.measuredSize
		end

		fillRangeFromNode(right, v2, v3 + v6, p3, p4, p5, p6)
	end
end

local function buildBalanced(p, p2: number, p3: number)
	if p3 < p2 then
		return nil
	end

	local v = (p2 + p3) // 2
	local v2 = p[v]
	local selected

	if FFlagViewRecyclerReact084 then
		selected = newNode(v2.itemCount, v2.measuredSize, v2.estimatedSize)
	else
		selected = newNode(v2.itemCount, v2.measuredSize)
	end

	selected.left = buildBalanced(p, p2, v - 1)
	selected.right = buildBalanced(p, v + 1, p3)
	refresh(selected)
	return selected
end

local function appendToArray(data, list, p: number)
	if data == nil then
		return
	end

	appendToArray(data.left, list, p)
	local v

	if FFlagViewRecyclerReact084 then
		v = unitSize(data, p)
	else
		v = data.measuredSize or p
	end

	for _ = 1, data.itemCount do
		table.insert(list, v)
	end

	appendToArray(data.right, list, p)
end

local WeightedOrderStatisticTree = {}
WeightedOrderStatisticTree.newNode = newNode
WeightedOrderStatisticTree.refresh = refresh
WeightedOrderStatisticTree.balance = balance
WeightedOrderStatisticTree.join = join
WeightedOrderStatisticTree.popMinimum = popMinimum
WeightedOrderStatisticTree.popMaximum = popMaximum
WeightedOrderStatisticTree.concatenate = concatenate
WeightedOrderStatisticTree.splitByItems = splitByItems
WeightedOrderStatisticTree.insertUnitAt = insertUnitAt
WeightedOrderStatisticTree.removeUnitAt = removeUnitAt
WeightedOrderStatisticTree.updateUnitAt = updateUnitAt
WeightedOrderStatisticTree.updateAt = updateAt
WeightedOrderStatisticTree.measuredAt = measuredAt

if FFlagViewRecyclerReact084 then
	WeightedOrderStatisticTree.estimatedAt = estimatedAt
	WeightedOrderStatisticTree.unitSize = unitSize
	WeightedOrderStatisticTree.unitSizeAt = unitSizeAt
end

WeightedOrderStatisticTree.prefixSumUpTo = prefixSumUpTo
WeightedOrderStatisticTree.entryAtPrefixSum = entryAtPrefixSum
WeightedOrderStatisticTree.fillRangeFromNode = fillRangeFromNode
WeightedOrderStatisticTree.buildBalanced = buildBalanced
WeightedOrderStatisticTree.appendToArray = appendToArray
WeightedOrderStatisticTree.nodeItemCount = nodeItemCount
WeightedOrderStatisticTree.nodeMeasuredCount = nodeMeasuredCount

if FFlagViewRecyclerReact084 then
	WeightedOrderStatisticTree.nodeFixedCount = nodeFixedCount
end

WeightedOrderStatisticTree.nodeCount = nodeCount
WeightedOrderStatisticTree.nodeEffectiveSum = nodeEffectiveSum

return WeightedOrderStatisticTree
