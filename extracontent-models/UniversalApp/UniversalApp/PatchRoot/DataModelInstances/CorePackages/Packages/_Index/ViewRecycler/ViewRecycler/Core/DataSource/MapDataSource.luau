local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
require(ViewRecycler.Core.Types)
local createEvent = require(ViewRecycler.Internal.createEvent)
local readDenseRange = require(script.Parent.readDenseRange)

local function createMapDataSource(data, callback)
	local v = {}
	local event = createEvent()
	local v2 = 0
	local v3 = nil

	local function getItem(p: number)
		local item = data.getItem(p)

		if v2 == 0 then
			return callback(item, p)
		end

		local itemKey = data.getItemKey(p)
		local v4 = v[itemKey]

		if v4 ~= nil and v4.input == item and v4.index == p then
			return v4.output
		end

		local output = callback(item, p)
		v[itemKey] = { input = item, index = p, output = output }

		return output
	end

	local function connectChild() -- 1 equivalent call inferred from this helper
		v3 = data.subscribe(function(data2)
			for _, change in data2.changes do
				if change.type == DataSourceChangeType.Reset then
					v = {}
					break
				end

				if not (change.type == DataSourceChangeType.Update or change.type == DataSourceChangeType.Remove) then
					continue
				end

				if change.type == DataSourceChangeType.Update then
				end

				for _, key in change.keys do
					v[key] = nil
				end
			end

			event.fire({
				changes = data2.changes,
				previousItemCount = data2.previousItemCount,
				itemCount = data2.itemCount
			})
		end)
	end

	local function subscribe(callback2)
		if v2 == 0 then
			v = {}
			connectChild() -- inferred equivalent call
		end

		v2 += 1
		local v4 = event.connect(callback2)
		local v5 = true
		return function()
			if not v5 then
				return
			end

			v5 = false
			v4()
			v2 -= 1

			if v2 == 0 and v3 ~= nil then
				v3()
				v3 = nil
				v = {}
			end
		end
	end

	return {
		getItemCount = data.getItemCount,
		getItem = getItem,
		getItemKey = data.getItemKey,
		getItems = function(p, p2)
			return readDenseRange(data.getItemCount(), getItem, p, p2)
		end,
		subscribe = subscribe
	}
end

return createMapDataSource
