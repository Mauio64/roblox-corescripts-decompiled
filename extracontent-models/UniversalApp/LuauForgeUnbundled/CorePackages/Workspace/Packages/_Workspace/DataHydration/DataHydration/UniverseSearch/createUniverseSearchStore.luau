local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchUniverseSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/fetchUniverseSearch")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/UniverseSearchStoreTypes")

local function paramsKey(p2)
	return HttpService:JSONEncode(p2)
end

local function createUniverseSearchStore(options)
	local v5 = options or {}

	local v6 = {}
	local v7 = {}
	local values = {}

	local function applyItemPatches(data)
		local data2 = data.data

		if data2 == nil or next(values) == nil then
			return data
		end

		local values2 = table.create(#data2)
		local flag = false

		for k, v8 in data2 do
			local v9 = values[v8.id]

			if v9 == nil then
				values2[k] = v8
			else
				values2[k] = Cryo.Dictionary.join(v8, v9)
				flag = true
			end
		end

		if flag then
			return Cryo.Dictionary.join(data, { data = values2 })
		end

		return data
	end

	local v8 = createDataCache()
	local v9 = createDataResolver({
		cache = v8,
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			return fetchUniverseSearch(v6[p2], { network = v5.network, baseUrl = v5.baseUrl }):andThen(applyItemPatches)
		end
	})

	return {
		getSearch = function(p2)
			local jsonEncode = HttpService:JSONEncode(p2)

			v6[jsonEncode] = p2
			return v9.getCachedItem(jsonEncode)
		end,
		fetchSearch = function(p2)
			local jsonEncode = HttpService:JSONEncode(p2)

			v6[jsonEncode] = p2
			return v9.fetchItem(jsonEncode)
		end,
		refreshSearch = function(p2)
			local jsonEncode = HttpService:JSONEncode(p2)

			v6[jsonEncode] = p2
			local v10 = (v7[jsonEncode] or 0) + 1
			v7[jsonEncode] = v10
			v8.resetFailedItem(jsonEncode)

			return fetchUniverseSearch(p2, { network = v5.network, baseUrl = v5.baseUrl }):andThen(applyItemPatches):andThen(function(p3)
				if v7[jsonEncode] == v10 then
					v8.replaceItem(jsonEncode, p3)
				end

				return p3
			end):catch(function(message)
				if v7[jsonEncode] == v10 then
					v8.markItemsAsFailed({ jsonEncode })
				end

				error(message)
			end)
		end,
		getAndFetchSearch = function(p2)
			local jsonEncode = HttpService:JSONEncode(p2)

			v6[jsonEncode] = p2
			return v9.getAndFetchItem(jsonEncode)
		end,
		updateSearchItem = function(p2, p3)
			values[p2] = Cryo.Dictionary.join(values[p2] or {}, p3)

			for k in v6 do
				local data = v9.getCachedItem(k).data(false)

				if data == nil then
					continue
				end

				local v10 = applyItemPatches(data)

				if v10 ~= data then
					v8.updateItem(k, v10)
				end
			end
		end,
		invalidateAll = function()
			v6 = {}
			v7 = {}
			v9.clear()
		end,
		dispose = function()
			v6 = {}
			v7 = {}
			values = {}
			v9.dispose()
		end
	}
end

return createUniverseSearchStore
