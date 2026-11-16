local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

require(script.Parent.GamePassStoreTypes)
local fetchGamePasses = require(script.Parent.fetchGamePasses)

local function createGamePassStore()
	local dataCache = createDataCache()

	local dataCache2 = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache2,
		supportsMultiGet = false,
		logError = function(p)
			local statusCode

			if type(p) == "table" and p.StatusCode then
				statusCode = p.StatusCode
			end

			logResponseError("game-passes/v1/universes/.../game-passes", { StatusCode = statusCode })
			DiscoveryEventErrorLogger.reportError("GamePassStore", "Failed to fetch game passes", {
				err = tostring(p)
			})
		end,
		fetchFn = function(p: string, _)
			return fetchGamePasses(p):andThen(function(p2)
				local ids = {}

				for _, gamePass in p2.gamePasses do
					local id = tostring(gamePass.id)
					table.insert(ids, id)
					dataCache.updateItems({ [id] = gamePass })
				end

				return ids
			end)
		end
	})

	return {
		getPassesForUniverse = dataResolver.getCachedItem,
		getAndFetchPassesForUniverse = dataResolver.getAndFetchItem,
		fetchPassesForUniverse = dataResolver.fetchItem,
		getGamePassInfo = dataCache.getItem,
		updateGamePassInfo = dataCache.updateItem,
		updateGamePassInfos = dataCache.updateItems,
		updateUniversePasses = dataCache2.updateItems,
		clear = function()
			dataCache2.clear()
			dataResolver.clear()
			dataCache.clear()
		end,
		dispose = function()
			dataResolver.dispose()
			dataCache.dispose()
		end
	}
end

return createGamePassStore
