local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.GamePassStoreTypes)

local fetchGamePasses = require(script.Parent.fetchGamePasses)

local function createGamePassStore() -- line: 23
	-- upvalues: createDataCache (copy), createDataResolver (copy), logResponseError (copy), DiscoveryEventErrorLogger (copy), fetchGamePasses (copy)
	local v10 = createDataCache()
	local v11 = createDataCache()
	local v12 = createDataResolver({
		supportsMultiGet = false,
		cache = v11,
		logError = function(p1) -- line: 33
			-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy)
			local v14 = if type(p1) ~= "table" or not p1.StatusCode then nil else p1.StatusCode

			logResponseError("game-passes/v1/universes/.../game-passes", {
				StatusCode = v14
			})
			DiscoveryEventErrorLogger.reportError("GamePassStore", "Failed to fetch game passes", {
				err = tostring(p1)
			})
		end,
		fetchFn = function(s1: string, _) -- line: 40
			-- upvalues: fetchGamePasses (copy), v10 (copy)
			return fetchGamePasses(s1):andThen(function(p3) -- line: 41
				-- upvalues: v10 (copy)
				local t1 = {}

				for _, v20 in p3.gamePasses do
					local str = tostring(v20.id)

					table.insert(t1, str)
					v10.updateItems({
						[str] = v20
					})
				end

				return t1
			end)
		end
	})

	return {
		getPassesForUniverse = v12.getCachedItem,
		getAndFetchPassesForUniverse = v12.getAndFetchItem,
		fetchPassesForUniverse = v12.fetchItem,
		getGamePassInfo = v10.getItem,
		updateGamePassInfo = v10.updateItem,
		updateGamePassInfos = v10.updateItems,
		updateUniversePasses = v11.updateItems,
		clear = function() -- line: 55
			-- upvalues: v11 (copy), v12 (copy), v10 (copy)
			v11.clear()
			v12.clear()
			v10.clear()
		end,
		dispose = function() -- line: 61
			-- upvalues: v12 (copy), v10 (copy)
			v12.dispose()
			v10.dispose()
		end
	}
end

return createGamePassStore
