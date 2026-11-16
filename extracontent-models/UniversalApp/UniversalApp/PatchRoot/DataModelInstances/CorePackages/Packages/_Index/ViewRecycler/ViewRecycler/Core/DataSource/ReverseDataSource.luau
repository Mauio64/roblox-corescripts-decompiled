local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)

local TranslatedDataSource = require(script.Parent.TranslatedDataSource)

local function reversedKeys(keys) -- 4 equivalent calls inferred from this helper
	local result = table.create(#keys)

	for k, item in keys do
		result[#keys - k + 1] = item
	end

	return result
end

local function createReverseDataSource(data)
	return TranslatedDataSource(data.getItemCount, function(p)
		return data.getItem(data.getItemCount() - p + 1)
	end, function(p)
		return data.getItemKey(data.getItemCount() - p + 1)
	end, function(callback)
		return data.subscribe(function(data2)
			local v = data2.previousItemCount
			local changes = {}

			for _, change in data2.changes do
				if change.type == DataSourceChangeType.Insert then
					local v2 = {
						type = DataSourceChangeType.Insert,
						index = v - change.index + 2,
						keys = reversedKeys(change.keys) -- inferred equivalent call
					}
					table.insert(changes, v2)

					v += #change.keys
				elseif change.type == DataSourceChangeType.Remove then
					local v2 = {
						type = DataSourceChangeType.Remove,
						index = v - change.index - #change.keys + 2,
						keys = reversedKeys(change.keys) -- inferred equivalent call
					}
					table.insert(changes, v2)

					v -= #change.keys
				elseif change.type == DataSourceChangeType.Update then
					table.insert(changes, {
						type = DataSourceChangeType.Update,
						keys = table.clone(change.keys)
					})
				elseif change.type == DataSourceChangeType.Move then
					table.insert(changes, {
						type = DataSourceChangeType.Move,
						fromIndex = v - change.fromIndex + 1,
						toIndex = v - change.toIndex + 1,
						key = change.key
					})
				elseif change.type == DataSourceChangeType.Reorder then
					local keys = reversedKeys(change.keys) -- inferred equivalent call
					table.insert(changes, { type = DataSourceChangeType.Reorder, keys = keys })
				elseif change.type == DataSourceChangeType.Reset then
					local keys = reversedKeys(change.keys) -- inferred equivalent call
					table.insert(changes, { type = DataSourceChangeType.Reset, keys = keys })
					v = #keys
				end
			end

			callback({
				changes = changes,
				previousItemCount = data2.previousItemCount,
				itemCount = data2.itemCount
			})
		end)
	end)
end

return createReverseDataSource
