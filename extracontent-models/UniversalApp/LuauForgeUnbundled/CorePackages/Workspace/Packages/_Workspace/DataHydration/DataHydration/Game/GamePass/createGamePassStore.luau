local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/GamePassStoreTypes")
local fetchGamePasses = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/fetchGamePasses")

local function createGamePassStore()
	local v5 = createDataCache()

	local v6 = createDataCache()
	local v7 = createDataResolver({
		cache = v6,
		supportsMultiGet = false,
		logError = function(p2)
			local v8 = if type(p2) == "table" and p2.StatusCode then p2.StatusCode else nil
			logResponseError("game-passes/v1/universes/.../game-passes", {
				StatusCode = v8
			})
			discoveryEventErrorLogger.reportError("GamePassStore", "Failed to fetch game passes", {
				err = tostring(p2)
			})
		end,
		fetchFn = function(p2, p3)
			return fetchGamePasses(p2):andThen(function(p4)
				local ids = {}

				for k, gamePass in p4.gamePasses do
					local id = tostring(gamePass.id)
					table.insert(ids, id)
					v5.updateItems({ [id] = gamePass })
				end

				return ids
			end)
		end
	})

	return {
		getPassesForUniverse = v7.getCachedItem,
		getAndFetchPassesForUniverse = v7.getAndFetchItem,
		fetchPassesForUniverse = v7.fetchItem,
		getGamePassInfo = v5.getItem,
		updateGamePassInfo = v5.updateItem,
		updateGamePassInfos = v5.updateItems,
		updateUniversePasses = v6.updateItems,
		clear = function()
			v6.clear()
			v7.clear()
			v5.clear()
		end,
		dispose = function()
			v7.dispose()
			v5.dispose()
		end
	}
end

return createGamePassStore
