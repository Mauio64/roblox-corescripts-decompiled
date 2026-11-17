local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
require(script.Parent.ISizeTree)
local WeightedOrderStatisticTree = require(script.Parent.WeightedOrderStatisticTree)

local OrderStatisticTree = {}
local function prefixSumUpTo(data, p: number, estimatedItemLength: number)
	if data == nil or p <= 0 then
		return 0
	end

	local v = WeightedOrderStatisticTree.nodeItemCount(data.left) + 1

	if p < v then
		return prefixSumUpTo(data.left, p, estimatedItemLength)
	end

	if v < p then
		local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(data.left, estimatedItemLength)
		local v2

		if FFlagViewRecyclerReact084 then
			v2 = data.measuredSize or data.estimatedSize
		else
			v2 = data.measuredSize
		end

		return nodeEffectiveSum + (v2 or estimatedItemLength) + prefixSumUpTo(data.right, p - v, estimatedItemLength)
	else
		local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(data.left, estimatedItemLength)
		local v2

		if FFlagViewRecyclerReact084 then
			v2 = data.measuredSize or data.estimatedSize
		else
			v2 = data.measuredSize
		end

		return nodeEffectiveSum + (v2 or estimatedItemLength)
	end
end

local function rankAtPrefixSum(data, p: number, estimatedItemLength: number)
	if data == nil then
		return 0
	end

	local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(data.left, estimatedItemLength)

	if p < nodeEffectiveSum then
		return rankAtPrefixSum(data.left, p, estimatedItemLength)
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(data.left)
	local measuredSize

	if FFlagViewRecyclerReact084 then
		measuredSize = data.measuredSize or data.estimatedSize or estimatedItemLength
	else
		measuredSize = data.measuredSize or estimatedItemLength
	end

	if p < nodeEffectiveSum + measuredSize then
		return nodeItemCount + 1
	end

	local v = rankAtPrefixSum(data.right, p - nodeEffectiveSum - measuredSize, estimatedItemLength)

	if v == 0 then
		return 0
	end

	return nodeItemCount + 1 + v
end

local function entryAtPrefixSum(data, p: number, estimatedItemLength: number)
	if data == nil then
		return 0, 0, 0
	end

	local nodeEffectiveSum = WeightedOrderStatisticTree.nodeEffectiveSum(data.left, estimatedItemLength)

	if p < nodeEffectiveSum then
		return entryAtPrefixSum(data.left, p, estimatedItemLength)
	end

	local nodeItemCount = WeightedOrderStatisticTree.nodeItemCount(data.left)
	local measuredSize

	if FFlagViewRecyclerReact084 then
		measuredSize = data.measuredSize or data.estimatedSize or estimatedItemLength
	else
		measuredSize = data.measuredSize or estimatedItemLength
	end

	if p < nodeEffectiveSum + measuredSize then
		return nodeItemCount + 1, nodeEffectiveSum, measuredSize
	end

	local v, v2, v3 = entryAtPrefixSum(data.right, p - nodeEffectiveSum - measuredSize, estimatedItemLength)

	if v == 0 then
		return 0, 0, 0
	end

	return nodeItemCount + 1 + v, nodeEffectiveSum + measuredSize + v2, v3
end

function OrderStatisticTree.new(value: number?)
	local v = nil
	local estimatedItemLength = value or 0

	local function length() -- 6 equivalent calls inferred from this helper
		return WeightedOrderStatisticTree.nodeItemCount(v)
	end

	local function prefixSum(p: number)
		if p <= 1 then
			return 0
		end

		return (prefixSumUpTo(v, p - 1, estimatedItemLength))
	end

	local function indexAtPrefixSum(p: number)
		local v2 = length() -- inferred equivalent call

		if v2 == 0 or p <= 0 then
			return 1
		end

		if WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength) <= p then
			return v2 + 1
		end

		return rankAtPrefixSum(v, p, estimatedItemLength)
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

			return entryAtPrefixSum(v, p, estimatedItemLength)
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
		WeightedOrderStatisticTree.updateUnitAt(v, p, p2)
	end

	local insert

	if FFlagViewRecyclerReact084 then
		insert = function(p: number, p2: number?, p3: number?)
			v = WeightedOrderStatisticTree.insertUnitAt(v, p, p2, p3)
		end
	else
		insert = function(p: number, p2: number?)
			v = WeightedOrderStatisticTree.insertUnitAt(v, p, p2)
		end
	end

	local function remove(p: number)
		v = WeightedOrderStatisticTree.removeUnitAt(v, p)
	end

	local function buildFromArray(list)
		local v2 = table.create(#list)

		for k, item in list do
			v2[k] = { itemCount = 1, measuredSize = item }
		end

		v = WeightedOrderStatisticTree.buildBalanced(v2, 1, #v2)
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
			v = WeightedOrderStatisticTree.removeUnitAt(v, p)
			v = WeightedOrderStatisticTree.insertUnitAt(v, p, measuredAt, p2)
			return getSize(p) ~= size -- inferred equivalent call
		end

		buildFromMeasurements = function(p: number, callback, callback2)
			local v2 = table.create(p)

			for i = 1, p do
				local v3 = { itemCount = 1, measuredSize = callback(i), estimatedSize = 0 }
				local estimatedSize

				if callback2 ~= nil then
					estimatedSize = callback2(i)
				end

				v3.estimatedSize = estimatedSize
				v2[i] = v3
			end

			v = WeightedOrderStatisticTree.buildBalanced(v2, 1, p)
		end
	else
		buildFromMeasurements = function(p: number, callback)
			local v2 = table.create(p)

			for i = 1, p do
				v2[i] = { itemCount = 1, measuredSize = callback(i) }
			end

			v = WeightedOrderStatisticTree.buildBalanced(v2, 1, p)
		end
	end

	if not FFlagViewRecyclerReact084 then
		setItemEstimate = nil
	end

	return {
		prefixSum = prefixSum,
		indexAtPrefixSum = indexAtPrefixSum,
		entryAtPrefixSum = getEntryAtPrefixSum,
		getSize = getSize,
		fillRange = fillRange,
		update = update,
		insert = insert,
		remove = remove,
		setItemEstimate = setItemEstimate,
		buildFromArray = buildFromArray,
		buildFromMeasurements = buildFromMeasurements,
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
				local v3

				if FFlagViewRecyclerReact084 then
					v3 = WeightedOrderStatisticTree.nodeFixedCount
				else
					v3 = WeightedOrderStatisticTree.nodeMeasuredCount
				end

				v2 = v3(v) < length() -- inferred equivalent call
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
			return v2 ~= 0 and p < v2 / math.log(v2, 2)
		end,
		length = length,
		totalSum = function()
			return WeightedOrderStatisticTree.nodeEffectiveSum(v, estimatedItemLength)
		end
	}
end

return OrderStatisticTree
