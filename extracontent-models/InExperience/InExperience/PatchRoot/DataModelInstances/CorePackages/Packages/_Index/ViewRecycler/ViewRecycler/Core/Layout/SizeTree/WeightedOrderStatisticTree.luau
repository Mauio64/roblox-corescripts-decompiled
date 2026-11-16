local function nodeHeight(p) -- 12 equivalent calls inferred from this helper
	return if p == nil then 0 else p.height
end

local function nodeItemCount(p) -- 11 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeItemCount
end

local function nodeMeasuredCount(p) -- 2 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeMeasuredCount
end

local function nodeMeasuredSum(p) -- 2 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeMeasuredSum
end

local function nodeCount(p) -- 2 equivalent calls inferred from this helper
	return if p == nil then 0 else p.subtreeNodeCount
end

local function nodeEffectiveSum(left, p: number) -- 3 equivalent calls inferred from this helper
	if left == nil then
		return 0
	end

	return left.subtreeMeasuredSum + (left.subtreeItemCount - left.subtreeMeasuredCount) * p
end

local function ownEffectiveSum(data, p: number) -- 2 equivalent calls inferred from this helper
	if data.measuredSize == nil then
		return data.itemCount * p
	end

	return data.measuredSize
end

local function refresh(state)
	assert(state.itemCount >= 1, "WeightedOrderStatisticTree: node itemCount must be positive")
	assert(
		state.measuredSize == nil or state.itemCount == 1,
		"WeightedOrderStatisticTree: measured nodes must represent exactly one item"
	)
	state.subtreeItemCount = nodeItemCount(state.left) + state.itemCount + nodeItemCount(state.right) -- inferred equivalent call
	state.subtreeMeasuredCount = nodeMeasuredCount(state.left) + (state.measuredSize == nil and 0 or 1) + nodeMeasuredCount(state.right) -- inferred equivalent call
	state.subtreeMeasuredSum = nodeMeasuredSum(state.left) + (state.measuredSize or 0) + nodeMeasuredSum(state.right) -- inferred equivalent call
	state.subtreeNodeCount = nodeCount(state.left) + 1 + nodeCount(state.right) -- inferred equivalent call
	state.height = math.max(nodeHeight(state.left), nodeHeight(state.right)) + 1 -- inferred equivalent call
end

local function newNode(p: number, measuredSize: number?) -- 4 equivalent calls inferred from this helper
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

local function concatenate(left, state) -- 2 equivalent calls inferred from this helper
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
		local v5 = concatenate(state.left, newNode(v3)) -- inferred equivalent call
		local node = newNode(v4) -- inferred equivalent call
		local right = state.right

		if node == nil then
			return v5, right
		end

		if right == nil then
			return v5, node
		end

		local v6, v7

		if right.left == nil then
			v6 = right.right
			right.left = nil
			right.right = nil
			refresh(right)
			v7 = right
		else
			local left
			left, v7 = popMinimum(right.left)
			right.left = left
			v6 = balance(right)
		end

		return v5, (join(node, v7, v6))
	end
end

local function insertUnitAt(state, p: number, measuredSize: number?)
	if state == nil then
		return newNode(1, measuredSize) -- inferred equivalent call
	else
		local v = nodeItemCount(state.left) + 1 -- inferred equivalent call

		if p <= v then
			state.left = insertUnitAt(state.left, p, measuredSize)
		else
			state.right = insertUnitAt(state.right, p - v, measuredSize)
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
		v3 = v2 * p2
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
	local v3 = ownEffectiveSum(data, p2) -- inferred equivalent call

	if p < v + v3 then
		if data.measuredSize ~= nil then
			return v2 + 1, v, data.measuredSize
		end

		local v4 = math.floor((p - v) / p2)
		return v2 + v4 + 1, v + v4 * p2, p2
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
		local measuredSize = left.measuredSize or p5

		for i = v4, v5 do
			local v6 = i - p3 + 1
			local v7 = p6[v6]

			if v7 == nil then
				v7 = { startOffset = 0, length = 0 }
				p6[v6] = v7
			end

			v7.startOffset = v3 + (i - v) * measuredSize
			v7.length = measuredSize
		end
	end

	if v2 < p4 then
		fillRangeFromNode(left.right, v2, v3 + ownEffectiveSum(left, p5), p3, p4, p5, p6) -- inferred equivalent call
	end
end

local function buildBalanced(p, p2: number, p3: number)
	if p3 < p2 then
		return nil
	end

	local v = (p2 + p3) // 2
	local v2 = p[v]
	local node = newNode(v2.itemCount, v2.measuredSize) -- inferred equivalent call
	node.left = buildBalanced(p, p2, v - 1)
	node.right = buildBalanced(p, v + 1, p3)
	refresh(node)
	return node
end

local function appendToArray(data, measuredSizes, p: number)
	if data == nil then
		return
	end

	appendToArray(data.left, measuredSizes, p)
	local measuredSize = data.measuredSize or p

	for _ = 1, data.itemCount do
		table.insert(measuredSizes, measuredSize)
	end

	appendToArray(data.right, measuredSizes, p)
end

return {
	["newNode"] = newNode,
	refresh = refresh,
	balance = balance,
	join = join,
	popMinimum = popMinimum,
	popMaximum = popMaximum,
	concatenate = concatenate,
	splitByItems = splitByItems,
	insertUnitAt = insertUnitAt,
	removeUnitAt = removeUnitAt,
	updateUnitAt = updateUnitAt,
	updateAt = updateAt,
	measuredAt = measuredAt,
	prefixSumUpTo = prefixSumUpTo,
	entryAtPrefixSum = entryAtPrefixSum,
	fillRangeFromNode = fillRangeFromNode,
	buildBalanced = buildBalanced,
	appendToArray = appendToArray,
	nodeItemCount = nodeItemCount,
	nodeMeasuredCount = nodeMeasuredCount,
	nodeCount = nodeCount,
	nodeEffectiveSum = nodeEffectiveSum
}
