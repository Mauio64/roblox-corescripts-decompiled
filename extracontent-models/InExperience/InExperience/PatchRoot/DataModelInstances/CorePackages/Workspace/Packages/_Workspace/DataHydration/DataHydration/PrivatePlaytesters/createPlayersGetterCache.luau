local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

require(script.Parent.PrivatePlaytestersStoreTypes)

local function createPlayersGetterCache()
	local computedsByCallback = {}

	return {
		getFor = function(callback)
			local v = computedsByCallback[callback]

			if v ~= nil then
				return v
			end

			local computed = Signals.createComputed(function(p)
				return callback(p) or {}
			end)

			computedsByCallback[callback] = computed
			return computed
		end,
		clear = function()
			table.clear(computedsByCallback)
		end
	}
end

return createPlayersGetterCache
