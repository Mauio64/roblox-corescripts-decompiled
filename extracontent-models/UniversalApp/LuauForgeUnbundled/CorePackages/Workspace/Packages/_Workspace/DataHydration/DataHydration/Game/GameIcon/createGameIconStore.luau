local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Dash")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/fetchGameIcons")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconStoreTypes")
local GameIconSize = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconSize")
local GameIconConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconConstants")
local sizeString = GameIconConstants.sizeString

local fIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx
local fIntGameIconLargeSizePx = GameIconConstants.FIntGameIconLargeSizePx

local function toId(p2)
	return (tostring(p2))
end

local function toIds(items)
	local ids = {}

	for k, item in items do
		table.insert(ids, (tostring(item)))
	end

	return ids
end

local function createResolver(p2)
	local v5 = createDataCache()
	return v5, (createDataResolver({
		cache = v5,
		queueProcessDelaySec = 0,
		requestBatchSize = 100,
		fetchFn = function(p3)
			return module4(Dash.keys(p3), p2):andThen(function(items)
				local result = {}

				for k, item in items do
					if not (type(item) == "table" and type(item.targetId) == "number" and item.state ~= "Pending") then
						continue
					end

					local targetId = tostring(item.targetId)
					result[targetId] = {
						universeId = targetId,
						state = item.state,
						url = item.imageUrl,
						size = p2
					}
				end

				return result
			end)
		end
	}))
end

local function createGameIconStore()
	local resolver, v5 = createResolver(sizeString(fIntGameIconSmallSizePx))
	local resolver2, v6 = createResolver(sizeString(fIntGameIconLargeSizePx))

	local function resolverFor(p2)
		if p2 == GameIconSize.Large then
			return v6
		end

		return v5
	end

	local function cacheFor(p2)
		if p2 == GameIconSize.Large then
			return resolver2
		end

		return resolver
	end

	return {
		fetchGameIcon = function(p2, p3)
			local v7 = if p3 == GameIconSize.Large then v6 else v5
			return v7.fetchItem((tostring(p2)))
		end,
		fetchGameIcons = function(items, p2)
			local fetchItems = (if p2 == GameIconSize.Large then v6 else v5).fetchItems
			local v8 = {}

			for k, item in items do
				table.insert(v8, (tostring(item)))
			end

			return fetchItems(v8)
		end,
		getGameIcon = function(p2, p3)
			local v7 = if p3 == GameIconSize.Large then v6 else v5
			return v7.getCachedItem((tostring(p2)))
		end,
		getGameIcons = function(items, p2)
			local getCachedItems = (if p2 == GameIconSize.Large then v6 else v5).getCachedItems
			local v8 = {}

			for k, item in items do
				table.insert(v8, (tostring(item)))
			end

			return getCachedItems(v8)
		end,
		getAndFetchGameIcon = function(p2, p3, p4)
			local v7 = if p3 == GameIconSize.Large then v6 else v5
			return v7.getAndFetchItem(tostring(p2), p4)
		end,
		getAndFetchGameIcons = function(items, p2, p3)
			local getAndFetchItems = (if p2 == GameIconSize.Large then v6 else v5).getAndFetchItems
			local v8 = {}

			for k, item in items do
				table.insert(v8, (tostring(item)))
			end

			return getAndFetchItems(v8, p3)
		end,
		updateGameIcons = function(p2, p3)
			local v7 = if p3 == GameIconSize.Large then resolver2 else resolver

			v7.updateItems(p2)
		end,
		clear = function()
			v5.clear()
			v6.clear()
		end,
		dispose = function()
			v5.dispose()
			v6.dispose()
		end
	}
end

return createGameIconStore
