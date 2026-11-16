local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)

local KeyUtils = require(script.Parent.KeyUtils)
local TranslatedDataSource = require(script.Parent.TranslatedDataSource)

local function createConcatDataSource(...)
	local v = { ... }

	local function getItemCount()
		local itemCount = 0

		for _, v2 in v do
			itemCount += v2.getItemCount()
		end

		return itemCount
	end

	local function resolve(p: number)
		for _, v2 in v do
			if p <= v2.getItemCount() then
				return v2, p
			end

			p -= v2.getItemCount()
		end

		error("DataSource.concat: index out of range")
	end

	local concatDataSource = TranslatedDataSource(getItemCount, function(p)
		local v2, v3 = resolve(p)
		return v2.getItem(v3)
	end, function(p)
		local v2, v3 = resolve(p)
		return v2.getItemKey(v3)
	end, function(callback)
		local v2 = {}

		for k, v3 in v do
			local v4 = table.create(v3.getItemCount())

			for i = 1, v3.getItemCount() do
				v4[i] = v3.getItemKey(i)
			end

			v2[k] = v4
		end

		local function collectAllKeys()
			local allKeys = {}

			for _, v3 in v2 do
				for _, v4 in v3 do
					table.insert(allKeys, v4)
				end
			end

			return allKeys
		end

		local function validateCurrentKeys() -- 1 equivalent call inferred from this helper
			KeyUtils.validateUnique(collectAllKeys(), "DataSource.concat")
		end
		local v3 = {}

		for k, v4 in v do
			table.insert(v3, v4.subscribe(function(p)
				local total = 0

				for i = 1, k - 1 do
					total += #v2[i]
				end

				local total2 = 0

				for _, v5 in v2 do
					total2 += #v5
				end

				local v5 = v2[k]
				local changes = {}

				for _, change in p.changes do
					if change.type == DataSourceChangeType.Insert then
						for k2, key in change.keys do
							table.insert(v5, change.index + k2 - 1, key)
						end

						table.insert(changes, {
							type = DataSourceChangeType.Insert,
							index = total + change.index,
							keys = table.clone(change.keys)
						})
					elseif change.type == DataSourceChangeType.Remove then
						for _ = 1, #change.keys do
							table.remove(v5, change.index)
						end

						table.insert(changes, {
							type = DataSourceChangeType.Remove,
							index = total + change.index,
							keys = table.clone(change.keys)
						})
					elseif change.type == DataSourceChangeType.Update then
						table.insert(changes, {
							type = DataSourceChangeType.Update,
							keys = table.clone(change.keys)
						})
					elseif change.type == DataSourceChangeType.Move then
						local v6 = table.remove(v5, change.fromIndex)
						table.insert(v5, change.toIndex, v6)
						table.insert(changes, {
							type = DataSourceChangeType.Move,
							fromIndex = total + change.fromIndex,
							toIndex = total + change.toIndex,
							key = change.key
						})
					elseif change.type == DataSourceChangeType.Reorder then
						v2[k] = table.clone(change.keys)
						v5 = v2[k]
						table.insert(changes, {
							type = DataSourceChangeType.Reorder,
							keys = collectAllKeys()
						})
					elseif change.type == DataSourceChangeType.Reset then
						v2[k] = table.clone(change.keys)
						v5 = v2[k]
						table.insert(changes, {
							type = DataSourceChangeType.Reset,
							keys = collectAllKeys()
						})
					end
				end

				validateCurrentKeys() -- inferred equivalent call
				callback({
					changes = changes,
					previousItemCount = total2,
					itemCount = #collectAllKeys()
				})
			end))
		end

		return function()
			for _, v4 in v3 do
				v4()
			end
		end
	end)

	local v2 = {}

	for i = 1, concatDataSource.getItemCount() do
		v2[i] = concatDataSource.getItemKey(i)
	end

	KeyUtils.validateUnique(v2, "DataSource.concat")
	return concatDataSource
end

return createConcatDataSource
