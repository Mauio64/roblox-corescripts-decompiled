local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local fetchUniverseCreate = require(script.Parent.fetchUniverseCreate)
require(script.Parent.UniverseCreateStoreTypes)
local UniverseSearch = require(DataHydration.UniverseSearch)

local function createUniverseCreateStore(options)
	local v = options or {}
	local getSearchStore = v.getSearchStore or function()
		return UniverseSearch.getUniverseSearchStore()
	end

	return {
		createUniverse = function(p)
			return fetchUniverseCreate(p, { network = v.network, baseUrl = v.baseUrl }):andThen(function(p2)
				getSearchStore().invalidateAll()
				return p2
			end)
		end
	}
end

return createUniverseCreateStore
