local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)

require(DataHydrationParent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchUniverseSearch = require(script.Parent.fetchUniverseSearch)

require(script.Parent.UniverseSearchStoreTypes)

local function paramsKey(p1) -- line: 30
	-- upvalues: HttpService (copy)
	return HttpService:JSONEncode(p1)
end
local function createUniverseSearchStore(t1: {[any]: any}?) -- line: 34
	-- upvalues: Cryo (copy), createDataCache (copy), createDataResolver (copy), fetchUniverseSearch (copy), HttpService (copy)
	local v12 = t1 or {}
	local t2 = {}
	local t3 = {}

	local function applyItemPatches(p2) -- line: 40
		-- upvalues: t3 (ref), Cryo (copy)
		local data = p2.data

		if data == nil or next(t3) == nil then
			return p2
		end

		local v20 = false
		local t4 = table.create(#data)

		for v22, v23 in data do
			local v24 = t3[v23.id]

			if v24 ~= nil then
				v20 = true
				t4[v22] = Cryo.Dictionary.join(v23, v24)
			else
				t4[v22] = v23
			end
		end

		if not v20 then
			return p2
		end

		return Cryo.Dictionary.join(p2, {
			data = t4
		})
	end

	local v16 = createDataCache()
	local v17 = createDataResolver({
		supportsMultiGet = false,
		cache = v16,
		fetchFn = function(s1: string, _) -- line: 71
			-- upvalues: t2 (ref), fetchUniverseSearch (copy), v12 (copy), applyItemPatches (copy)
			local v27 = t2[s1]

			return fetchUniverseSearch(v27, {
				network = v12.network,
				baseUrl = v12.baseUrl
			}):andThen(applyItemPatches)
		end
	})

	return {
		getSearch = function(p4) -- line: 80
			-- upvalues: HttpService (copy), t2 (ref), v17 (copy)
			local json = HttpService:JSONEncode(p4)

			t2[json] = p4

			return v17.getCachedItem(json)
		end,
		fetchSearch = function(p5) -- line: 86
			-- upvalues: HttpService (copy), t2 (ref), v17 (copy)
			local json = HttpService:JSONEncode(p5)

			t2[json] = p5

			return v17.fetchItem(json)
		end,
		getAndFetchSearch = function(p6) -- line: 92
			-- upvalues: HttpService (copy), t2 (ref), v17 (copy)
			local json = HttpService:JSONEncode(p6)

			t2[json] = p6

			return v17.getAndFetchItem(json)
		end,
		updateSearchItem = function(n1: number, t5: {[any]: any}) -- line: 100
			-- upvalues: t3 (ref), Cryo (copy), t2 (ref), v17 (copy), applyItemPatches (copy), v16 (copy)
			t3[n1] = Cryo.Dictionary.join(t3[n1] or {}, t5)

			for v36 in t2 do
				local v37 = v17.getCachedItem(v36).data(false)

				if v37 ~= nil then
					local v38 = applyItemPatches(v37)

					if v38 ~= v37 then
						v16.updateItem(v36, v38)
					end
				end
			end
		end,
		invalidateAll = function() -- line: 117
			-- upvalues: t2 (ref), v17 (copy)
			t2 = {}
			v17.clear()
		end,
		dispose = function() -- line: 122
			-- upvalues: t2 (ref), t3 (ref), v17 (copy)
			t2 = {}
			t3 = {}
			v17.dispose()
		end
	}
end

return createUniverseSearchStore
