local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PrivatePlaytesters/PrivatePlaytestersStoreTypes")

local function createPlayersGetterCache()
	local computedsByCallback = {}

	return {
		getFor = function(callback)
			local v5 = computedsByCallback[callback]

			if v5 ~= nil then
				return v5
			end

			local computed = Signals.createComputed(function(p2)
				return callback(p2) or {}
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
