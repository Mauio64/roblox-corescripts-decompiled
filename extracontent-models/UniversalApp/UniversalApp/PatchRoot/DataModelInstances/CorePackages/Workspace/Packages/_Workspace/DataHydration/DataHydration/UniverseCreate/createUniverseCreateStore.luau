local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local fetchUniverseCreate = require(script.Parent.fetchUniverseCreate)

require(script.Parent.UniverseCreateStoreTypes)

local UniverseSearch = require(DataHydration.UniverseSearch)

local function createUniverseCreateStore(t1: {[any]: any}?) -- line: 21
	-- upvalues: UniverseSearch (copy), fetchUniverseCreate (copy)
	local v7 = t1 or {}
	local v8 = v7.getSearchStore or function() -- line: 23
		-- upvalues: UniverseSearch (copy)
		return UniverseSearch.getUniverseSearchStore()
	end

	return {
		createUniverse = function(p1) -- line: 27
			-- upvalues: fetchUniverseCreate (copy), v7 (copy), v8 (copy)
			return fetchUniverseCreate(p1, {
				network = v7.network,
				baseUrl = v7.baseUrl
			}):andThen(function(p2) -- line: 31
				-- upvalues: v8 (copy)
				v8().invalidateAll()

				return p2
			end)
		end
	}
end

return createUniverseCreateStore
