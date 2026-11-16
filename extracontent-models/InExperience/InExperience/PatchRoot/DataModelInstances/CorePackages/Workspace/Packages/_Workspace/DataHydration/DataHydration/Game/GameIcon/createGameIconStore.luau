local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Dash = require(parent.Dash)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchGameIcons = require(script.Parent.fetchGameIcons)
require(script.Parent.GameIconStoreTypes)
local GameIconSize = require(script.Parent.GameIconSize)
local GameIconConstants = require(script.Parent.GameIconConstants)
local sizeString = GameIconConstants.sizeString

local FIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx
local FIntGameIconLargeSizePx = GameIconConstants.FIntGameIconLargeSizePx

local function toId(p) -- 3 equivalent calls inferred from this helper
	return (tostring(p))
end

local function toIds(items) -- 3 equivalent calls inferred from this helper
	local ids = {}

	for _, item in items do
		table.insert(ids, (tostring(item)))
	end

	return ids
end

local function createResolver(size: string)
	local dataCache = createDataCache()
	return dataCache, (createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = 0,
		requestBatchSize = 100,
		fetchFn = function(p)
			return fetchGameIcons(Dash.keys(p), size):andThen(function(items)
				local result = {}

				for _, item in items do
					if not (type(item) == "table" and type(item.targetId) == "number" and item.state ~= "Pending") then
						continue
					end

					local targetId = tostring(item.targetId)
					result[targetId] = {
						universeId = targetId,
						state = item.state,
						url = item.imageUrl,
						size = size
					}
				end

				return result
			end)
		end
	}))
end

local function createGameIconStore()
	local resolver, v = createResolver(sizeString(FIntGameIconSmallSizePx))
	local resolver2, v2 = createResolver(sizeString(FIntGameIconLargeSizePx))

	local function resolverFor(p) -- 6 equivalent calls inferred from this helper
		return if p == GameIconSize.Large then v2 else v
	end

	local function cacheFor(p) -- 1 equivalent call inferred from this helper
		return if p == GameIconSize.Large then resolver2 else resolver
	end

	return {
		fetchGameIcon = function(p, p2)
			return resolverFor(p2).fetchItem(toId(p)) -- inferred equivalent call
		end,
		fetchGameIcons = function(items, p)
			return resolverFor(p).fetchItems(toIds(items)) -- inferred equivalent call
		end,
		getGameIcon = function(p, p2)
			return resolverFor(p2).getCachedItem(toId(p)) -- inferred equivalent call
		end,
		getGameIcons = function(items, p)
			return resolverFor(p).getCachedItems(toIds(items)) -- inferred equivalent call
		end,
		getAndFetchGameIcon = function(p, p2, p3)
			return resolverFor(p2).getAndFetchItem(toId(p), p3) -- inferred equivalent call
		end,
		getAndFetchGameIcons = function(items, p, p2)
			return resolverFor(p).getAndFetchItems(toIds(items), p2) -- inferred equivalent call
		end,
		updateGameIcons = function(p, p2)
			cacheFor(p2).updateItems(p) -- inferred equivalent call
		end,
		clear = function()
			v.clear()
			v2.clear()
		end,
		dispose = function()
			v.dispose()
			v2.dispose()
		end
	}
end

return createGameIconStore
