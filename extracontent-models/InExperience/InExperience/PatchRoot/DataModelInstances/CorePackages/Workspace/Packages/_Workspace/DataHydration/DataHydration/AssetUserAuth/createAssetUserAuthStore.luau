local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchAssetUserAuth = require(script.Parent.fetchAssetUserAuth)

require(script.Parent.AssetUserAuthStoreTypes)

local function ALWAYS_REFRESH() -- line: 22
	return true
end
local function createAssetUserAuthStore(t1: {[any]: any}?) -- line: 28
	-- upvalues: createDataCache (copy), createDataResolver (copy), fetchAssetUserAuth (copy), ALWAYS_REFRESH (copy)
	local v9 = t1 or {}
	local t2 = {
		network = v9.network,
		baseUrl = v9.baseUrl
	}
	local v11 = createDataCache()
	local v12 = createDataResolver({
		supportsMultiGet = false,
		cache = v11,
		fetchFn = function(s1: string, _) -- line: 36
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy)
			return fetchAssetUserAuth.fetchOperation(s1, t2)
		end
	})

	return {
		patchAssetIcon = function(s2: string, p2) -- line: 41
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), v11 (copy)
			return fetchAssetUserAuth.patchAssetIcon(s2, p2, t2):andThen(function(p3) -- line: 42
				-- upvalues: v11 (copy)
				local path = p3.path

				if typeof(path) == "string" and #path > 0 then
					local v21 = string.match(path, "operations/(.+)$") or path

					v11.updateItem(v21, p3)
				end

				return p3
			end)
		end,
		getOperation = v12.getCachedItem,
		fetchOperation = v12.fetchItem,
		getAndFetchOperation = function(s3: string) -- line: 64
			-- upvalues: v12 (copy), ALWAYS_REFRESH (copy)
			return v12.getAndFetchItem(s3, ALWAYS_REFRESH)
		end,
		refreshOperation = function(s4: string) -- line: 52
			-- upvalues: fetchAssetUserAuth (copy), t2 (copy), v11 (copy)
			return fetchAssetUserAuth.fetchOperation(s4, t2):andThen(function(p4) -- line: 53
				-- upvalues: v11 (copy), s4 (copy)
				v11.updateItem(s4, p4)

				return p4
			end)
		end,
		updateOperation = v11.updateItem,
		clear = v12.clear,
		dispose = v12.dispose
	}
end

return createAssetUserAuthStore
