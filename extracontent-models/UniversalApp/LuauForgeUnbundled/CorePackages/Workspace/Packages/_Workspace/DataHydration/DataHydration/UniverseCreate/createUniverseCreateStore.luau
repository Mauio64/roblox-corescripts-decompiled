require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local fetchUniverseCreate = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseCreate/fetchUniverseCreate")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseCreate/UniverseCreateStoreTypes")
local UniverseSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch")

local function createUniverseCreateStore(options)
	local v5 = options or {}
	local getSearchStore = v5.getSearchStore or function()
		return UniverseSearch.getUniverseSearchStore()
	end

	return {
		createUniverse = function(p2)
			return fetchUniverseCreate(p2, { network = v5.network, baseUrl = v5.baseUrl }):andThen(function(p3)
				getSearchStore().invalidateAll()
				return p3
			end)
		end
	}
end

return createUniverseCreateStore
