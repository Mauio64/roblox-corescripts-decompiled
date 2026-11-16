local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)

local ItemKeyRegistry = require(script.Parent.ItemKeyRegistry)
local MutationController = require(script.Parent.MutationController)

local function createSequenceDataSource(options, callback)
	local values = table.clone(options or {})
	local v = ItemKeyRegistry.create(callback, "DataSource.sequence")
	local keys = v.rebuild(values)

	local v2 = {}
	local v3 = 0

	local function record(p) -- 7 equivalent calls inferred from this helper
		if v3 > 0 then
			table.insert(v2, p)
		end
	end

	local function undo(data)
		local kind = data.kind

		if kind == "insert" then
			table.remove(values, data.index)
			table.remove(keys, data.index)
			v.release(data.key)
		elseif kind == "remove" then
			for k, key in data.keys do
				table.insert(values, data.index + k - 1, data.values[k])
				table.insert(keys, data.index + k - 1, key)
				v.adopt(key)
			end
		elseif kind == "set" then
			values[data.index] = data.value
		elseif kind == "move" then
			local v4 = table.remove(values, data.toIndex)
			local v5 = table.remove(keys, data.toIndex)
			table.insert(values, data.fromIndex, v4)
			table.insert(keys, data.fromIndex, v5)
		else
			values = data.values
			keys = data.keys

			if data.keyRegistry ~= nil then
				v.restore(data.keyRegistry)
			end
		end
	end

	local function closeTransaction() -- 1 equivalent call inferred from this helper
		v3 -= 1

		if v3 == 0 then
			table.clear(v2)
		end
	end

	local mutationController = MutationController(function()
		return #values
	end, function()
		v3 += 1
		return #v2
	end, function(p)
		for i = #v2, p + 1, -1 do
			undo(v2[i])
			v2[i] = nil
		end

		closeTransaction() -- inferred equivalent call
	end, closeTransaction)

	local sequenceDataSource = {
		getItemCount = function()
			return #values
		end,
		getItem = function(p)
			return values[p]
		end,
		getItemKey = function(p)
			return keys[p]
		end,
		getItems = function(p, p2)
			return table.move(values, p, p2, 1, {})
		end,
		subscribe = mutationController.subscribe,
		transaction = mutationController.transaction
	}

	function sequenceDataSource.append(p)
		sequenceDataSource.insert(#values + 1, p)
	end

	function sequenceDataSource.prepend(p)
		sequenceDataSource.insert(1, p)
	end

	function sequenceDataSource.insert(p: number, p2)
		local count = #values
		local v4 = p >= 1 and p <= count + 1
		assert(v4, "DataSource.sequence: insert index out of range")
		local claim = v.claim(p2, p)
		table.insert(values, p, p2)
		table.insert(keys, p, claim)
		record({ kind = "insert", index = p, key = claim }) -- inferred equivalent call
		mutationController.emit({
			type = DataSourceChangeType.Insert,
			index = p,
			keys = { claim }
		}, count)
	end

	function sequenceDataSource.remove(p: number, value: number?)
		local count = #values
		local v4 = value or 1

		local v5 = v4 > 0 and p >= 1 and p + v4 - 1 <= count
		assert(v5, "DataSource.sequence: remove range out of range")

		local keys2 = table.create(v4)
		local values2 = table.create(v4)

		for i = 1, v4 do
			values2[i] = table.remove(values, p)
			local v6 = table.remove(keys, p)
			keys2[i] = v6
			v.release(v6)
		end

		record({ kind = "remove", index = p, keys = keys2, values = values2 }) -- inferred equivalent call
		mutationController.emit({ type = DataSourceChangeType.Remove, index = p, keys = keys2 }, count)
	end

	function sequenceDataSource.setItem(p: number, p2)
		local count = #values
		local v4 = p >= 1 and p <= count
		assert(v4, "DataSource.sequence: setItem index out of range")
		local v5 = keys[p]
		v.assertPreserved(v5, p2, p)
		record({ kind = "set", index = p, value = values[p] }) -- inferred equivalent call
		values[p] = p2
		mutationController.emit({
			type = DataSourceChangeType.Update,
			keys = { v5 }
		}, count)
	end

	function sequenceDataSource.moveItem(fromIndex: number, toIndex: number)
		local count = #values

		local v4 = fromIndex >= 1 and fromIndex <= count
		assert(v4, "DataSource.sequence: moveItem source index out of range")

		local v5 = toIndex >= 1 and toIndex <= count
		assert(v5, "DataSource.sequence: moveItem destination index out of range")

		if fromIndex == toIndex then
			return
		end

		local v6 = table.remove(values, fromIndex)
		local v7 = table.remove(keys, fromIndex)
		table.insert(values, toIndex, v6)
		table.insert(keys, toIndex, v7)
		record({ kind = "move", fromIndex = fromIndex, toIndex = toIndex }) -- inferred equivalent call
		mutationController.emit(
			{ type = DataSourceChangeType.Move, fromIndex = fromIndex, toIndex = toIndex, key = v7 },
			count
		)
	end

	function sequenceDataSource.reorder(list)
		local count = #values
		assert(#list == count, "DataSource.sequence: reorder must contain every key")
		local v4 = {}

		for k, v5 in keys do
			v4[v5] = values[k]
		end

		local v5 = table.create(count)
		local v6 = table.create(count)
		local set = {}

		for k, item in list do
			local v7 = v4[item] ~= nil and set[item] == nil
			assert(v7, "DataSource.sequence: reorder must contain every key once")

			set[item] = true
			v5[k] = v4[item]
			v6[k] = item
		end

		record({ kind = "replace", values = values, keys = keys }) -- inferred equivalent call
		values = v5
		keys = v6
		mutationController.emit({ type = DataSourceChangeType.Reorder, keys = table.clone(v6) }, count)
	end

	function sequenceDataSource.replaceItems(p: number, p2: number, list)
		local v4 = p >= 1 and p <= p2 and p2 <= #values
		assert(v4, "DataSource.sequence: replaceItems range out of range")

		mutationController.transaction(function()
			sequenceDataSource.remove(p, p2 - p + 1)

			if #list == 0 then
				return
			end

			local count = #values
			record({ kind = "replace", values = values, keys = keys, keyRegistry = v.snapshot() }) -- inferred equivalent call
			local keys2 = table.create(#list)

			for k, item in list do
				keys2[k] = v.claim(item, p + k - 1)
			end

			local v5 = table.create(count + #list)
			local v6 = table.create(count + #list)

			if p > 1 then
				table.move(values, 1, p - 1, 1, v5)
				table.move(keys, 1, p - 1, 1, v6)
			end

			for k, item in list do
				local v7 = p + k - 1
				v5[v7] = item
				v6[v7] = keys2[k]
			end

			if p <= count then
				table.move(values, p, count, p + #list, v5)
				table.move(keys, p, count, p + #list, v6)
			end

			values = v5
			keys = v6
			mutationController.emit({ type = DataSourceChangeType.Insert, index = p, keys = keys2 }, count)
		end)
	end

	function sequenceDataSource.reset(p)
		local v4 = #values
		local clone = table.clone(p)
		local keyRegistry

		if v3 > 0 then
			keyRegistry = v.snapshot()
		end

		local rebuild = v.rebuild(clone)
		record({ kind = "replace", values = values, keys = keys, keyRegistry = keyRegistry }) -- inferred equivalent call
		values = clone
		keys = rebuild
		mutationController.emit({ type = DataSourceChangeType.Reset, keys = table.clone(rebuild) }, v4)
	end

	return sequenceDataSource
end

return createSequenceDataSource
