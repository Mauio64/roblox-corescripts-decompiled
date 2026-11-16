local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)

local ItemKeyRegistry = require(script.Parent.ItemKeyRegistry)
local MutationController = require(script.Parent.MutationController)
local readDenseRange = require(script.Parent.readDenseRange)

local function createDequeDataSource(options, callback)
	local v = options or {}

	local v2 = ItemKeyRegistry.create(callback, "DataSource.deque")
	local rebuild = v2.rebuild(v)
	local capacity = math.max(8, #v)

	local itemCount = #v
	local v3 = {}
	local v4 = {}
	local head = 1

	for k, v5 in v do
		v3[k] = v5
		v4[k] = rebuild[k]
	end

	local mutationController = MutationController(function()
		return itemCount
	end, function()
		return {
			values = table.clone(v3),
			keys = table.clone(v4),
			capacity = capacity,
			head = head,
			count = itemCount,
			keyRegistry = v2.snapshot()
		}
	end, function(data)
		v3 = data.values
		v4 = data.keys
		capacity = data.capacity
		head = data.head
		itemCount = data.count
		v2.restore(data.keyRegistry)
	end)

	local function physical(p: number) -- 6 equivalent calls inferred from this helper
		return (head + p - 2) % capacity + 1
	end

	local function ensureCapacity(p: number)
		if p <= capacity then
			return
		end

		local v5 = capacity * 2

		while v5 < p do
			v5 *= 2
		end

		local v6 = {}
		local v7 = {}

		for i = 1, itemCount do
			v6[i] = v3[physical(i)] -- inferred equivalent call
			v7[i] = v4[physical(i)] -- inferred equivalent call
		end

		v3 = v6
		v4 = v7
		capacity = v5
		head = 1
	end

	local function claimMany(list, p: number)
		local result = table.create(#list)
		local v5 = table.pack(pcall(function()
			for k, item in list do
				result[k] = v2.claim(item, p + k - 1)
			end
		end))

		if not v5[1] then
			for _, v6 in result do
				v2.release(v6)
			end

			error(v5[2], 0)
		end

		return result
	end

	local dequeDataSource = nil
	dequeDataSource = {
		getItemCount = function()
			return itemCount
		end,
		getItem = function(p)
			return v3[physical(p)] -- inferred equivalent call
		end,
		getItemKey = function(p)
			return v4[physical(p)] -- inferred equivalent call
		end,
		getItems = function(p, p2)
			return readDenseRange(itemCount, dequeDataSource.getItem, p, p2)
		end,
		subscribe = mutationController.subscribe,
		transaction = mutationController.transaction
	}

	function dequeDataSource.pushFront(p)
		dequeDataSource.pushFrontMany({ p })
	end

	function dequeDataSource.pushBack(p)
		dequeDataSource.pushBackMany({ p })
	end

	function dequeDataSource.pushFrontMany(list)
		local count = #list

		if count == 0 then
			return
		end

		local v5 = itemCount
		local keys = claimMany(list, 1)
		ensureCapacity(itemCount + count)
		head = (head - count - 1) % capacity + 1

		for k, item in list do
			local v6 = (head + k - 2) % capacity + 1
			v3[v6] = item
			v4[v6] = keys[k]
		end

		itemCount += count
		mutationController.emit({ type = DataSourceChangeType.Insert, index = 1, keys = keys }, v5)
	end

	function dequeDataSource.pushBackMany(list)
		local count = #list

		if count == 0 then
			return
		end

		local v5 = itemCount
		local keys = claimMany(list, itemCount + 1)
		ensureCapacity(itemCount + count)

		for k, item in list do
			local v6 = physical(itemCount + k) -- inferred equivalent call
			v3[v6] = item
			v4[v6] = keys[k]
		end

		itemCount += count
		mutationController.emit({
			type = DataSourceChangeType.Insert,
			index = v5 + 1,
			keys = keys
		}, v5)
	end

	function dequeDataSource.popFront()
		if itemCount == 0 then
			return nil
		end

		local v5 = itemCount
		local v6 = v3[head]
		v3[head] = nil
		local v7 = v4[head]
		v4[head] = nil
		v2.release(v7)
		head = head % capacity + 1
		itemCount -= 1
		mutationController.emit({
			type = DataSourceChangeType.Remove,
			index = 1,
			keys = { v7 }
		}, v5)
		return v6
	end

	function dequeDataSource.popBack()
		if itemCount == 0 then
			return nil
		end

		local v5 = itemCount
		local v6 = (head + itemCount - 2) % capacity + 1

		local v7 = v3[v6]
		v3[v6] = nil
		local v8 = v4[v6]
		v4[v6] = nil
		v2.release(v8)
		itemCount -= 1
		mutationController.emit({
			type = DataSourceChangeType.Remove,
			index = v5,
			keys = { v8 }
		}, v5)

		return v7
	end

	function dequeDataSource.setItem(p: number, p2)
		local v5 = itemCount
		local v6 = p >= 1 and p <= v5
		assert(v6, "DataSource.deque: setItem index out of range")
		local v7 = physical(p) -- inferred equivalent call
		local v8 = v4[v7]
		v2.assertPreserved(v8, p2, p)
		v3[v7] = p2
		mutationController.emit({
			type = DataSourceChangeType.Update,
			keys = { v8 }
		}, v5)
	end

	return dequeDataSource
end

return createDequeDataSource
