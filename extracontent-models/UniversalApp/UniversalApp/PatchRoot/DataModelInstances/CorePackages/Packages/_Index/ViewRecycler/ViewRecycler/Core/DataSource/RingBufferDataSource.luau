local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)

local ItemKeyRegistry = require(script.Parent.ItemKeyRegistry)
local MutationController = require(script.Parent.MutationController)
local readDenseRange = require(script.Parent.readDenseRange)

local function createRingBufferDataSource(p: number, options, callback)
	local v = p > 0 and p % 1 == 0
	assert(v, "DataSource.ringBuffer: capacity must be a positive integer")
	local v2 = options or {}
	assert(#v2 <= p, "DataSource.ringBuffer: initial values exceed capacity")

	local v3 = ItemKeyRegistry.create(callback, "DataSource.ringBuffer")
	local rebuild = v3.rebuild(v2)

	local itemCount = #v2
	local v4 = {}
	local v5 = {}
	local head = 1

	for k, v6 in v2 do
		v4[k] = v6
		v5[k] = rebuild[k]
	end

	local mutationController = MutationController(function()
		return itemCount
	end, function()
		return {
			values = table.clone(v4),
			keys = table.clone(v5),
			head = head,
			count = itemCount,
			keyRegistry = v3.snapshot()
		}
	end, function(data)
		v4 = data.values
		v5 = data.keys
		head = data.head
		itemCount = data.count
		v3.restore(data.keyRegistry)
	end)

	local function physical(p2: number) -- 3 equivalent calls inferred from this helper
		return (head + p2 - 2) % p + 1
	end

	local ringBufferDataSource = nil
	ringBufferDataSource = {
		getItemCount = function()
			return itemCount
		end,
		getItem = function(p2)
			return v4[physical(p2)] -- inferred equivalent call
		end,
		getItemKey = function(p2)
			return v5[physical(p2)] -- inferred equivalent call
		end,
		getItems = function(p2, p3)
			return readDenseRange(itemCount, ringBufferDataSource.getItem, p2, p3)
		end,
		subscribe = mutationController.subscribe,
		transaction = mutationController.transaction
	}

	function ringBufferDataSource.push(p2)
		local v6 = itemCount

		if itemCount == p then
			local v7 = head
			local v8 = v5[v7]
			local v9 = v3.replace(v8, p2, p)
			v4[v7] = p2
			v5[v7] = v9
			head = head % p + 1
			mutationController.emitMany({
				{
					type = DataSourceChangeType.Remove,
					index = 1,
					keys = { v8 }
				},
				{
					type = DataSourceChangeType.Insert,
					index = p,
					keys = { v9 }
				}
			}, v6)
		else
			local claim = v3.claim(p2, itemCount + 1)
			local v7 = physical(itemCount + 1) -- inferred equivalent call
			v4[v7] = p2
			v5[v7] = claim
			itemCount += 1
			mutationController.emit({
				type = DataSourceChangeType.Insert,
				index = itemCount,
				keys = { claim }
			}, v6)
		end
	end

	function ringBufferDataSource.clear()
		local v6 = itemCount

		if v6 == 0 then
			return
		end

		v4 = {}
		v5 = {}
		v3.clear()
		head = 1
		itemCount = 0
		mutationController.emit({ type = DataSourceChangeType.Reset, keys = {} }, v6)
	end

	return ringBufferDataSource
end

return createRingBufferDataSource
