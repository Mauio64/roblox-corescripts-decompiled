local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchUniverseSearch = require(script.Parent.fetchUniverseSearch)
require(script.Parent.UniverseSearchStoreTypes)

local function paramsKey(p) -- 4 equivalent calls inferred from this helper
	return HttpService:JSONEncode(p)
end

local function createUniverseSearchStore(options)
	local v = options or {}

	local v2 = {}
	local v3 = {}
	local values = {}

	local function applyItemPatches(data)
		local data2 = data.data

		if data2 == nil or next(values) == nil then
			return data
		end

		local values2 = table.create(#data2)
		local flag = false

		for k, v4 in data2 do
			local v5 = values[v4.id]

			if v5 == nil then
				values2[k] = v4
			else
				values2[k] = Cryo.Dictionary.join(v4, v5)
				flag = true
			end
		end

		if flag then
			return Cryo.Dictionary.join(data, { data = values2 })
		end

		return data
	end

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(p: string, _)
			return fetchUniverseSearch(v2[p], { network = v.network, baseUrl = v.baseUrl }):andThen(applyItemPatches)
		end
	})

	return {
		getSearch = function(p)
			local v4 = paramsKey(p) -- inferred equivalent call
			v2[v4] = p
			return dataResolver.getCachedItem(v4)
		end,
		fetchSearch = function(p)
			local v4 = paramsKey(p) -- inferred equivalent call
			v2[v4] = p
			return dataResolver.fetchItem(v4)
		end,
		refreshSearch = function(p)
			local v4 = paramsKey(p) -- inferred equivalent call
			v2[v4] = p
			local v5 = (v3[v4] or 0) + 1
			v3[v4] = v5
			dataCache.resetFailedItem(v4)

			return fetchUniverseSearch(p, { network = v.network, baseUrl = v.baseUrl }):andThen(applyItemPatches):andThen(function(p2)
				if v3[v4] == v5 then
					dataCache.replaceItem(v4, p2)
				end

				return p2
			end):catch(function(message)
				if v3[v4] == v5 then
					dataCache.markItemsAsFailed({ v4 })
				end

				error(message)
			end)
		end,
		getAndFetchSearch = function(p)
			local v4 = paramsKey(p) -- inferred equivalent call
			v2[v4] = p
			return dataResolver.getAndFetchItem(v4)
		end,
		updateSearchItem = function(p: number, p2)
			values[p] = Cryo.Dictionary.join(values[p] or {}, p2)

			for k in v2 do
				local data = dataResolver.getCachedItem(k).data(false)

				if data == nil then
					continue
				end

				local v4 = applyItemPatches(data)

				if v4 ~= data then
					dataCache.updateItem(k, v4)
				end
			end
		end,
		invalidateAll = function()
			v2 = {}
			v3 = {}
			dataResolver.clear()
		end,
		dispose = function()
			v2 = {}
			v3 = {}
			values = {}
			dataResolver.dispose()
		end
	}
end

return createUniverseSearchStore
