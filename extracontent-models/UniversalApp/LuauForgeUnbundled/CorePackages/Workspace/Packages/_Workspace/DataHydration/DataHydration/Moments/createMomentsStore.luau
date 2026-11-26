local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local fetchMomentsByIds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchMomentsByIds")

local function createMomentsStore(options)
	local v5 = options or {}

	return {
		getMomentsByIds = function(p2, p3)
			return HttpClient.asPromise(fetchMomentsByIds(p2, v5.network, p3))
		end
	}
end

return createMomentsStore
