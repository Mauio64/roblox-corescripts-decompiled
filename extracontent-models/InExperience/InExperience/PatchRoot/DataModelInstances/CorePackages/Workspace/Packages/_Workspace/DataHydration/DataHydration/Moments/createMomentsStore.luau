local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
require(script.Parent.MomentsStoreTypes)
local fetchMomentsByIds = require(script.Parent.Requests.fetchMomentsByIds)

local function createMomentsStore(options)
	local v = options or {}

	return {
		getMomentsByIds = function(p, p2: string?)
			return HttpClient.asPromise(fetchMomentsByIds(p, v.network, p2))
		end
	}
end

return createMomentsStore
