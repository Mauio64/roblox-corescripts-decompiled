local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)

require(script.Parent.MomentsStoreTypes)

local fetchMomentsByIds = require(script.Parent.Requests.fetchMomentsByIds)

local function createMomentsStore(p1) -- line: 13
	-- upvalues: HttpClient (copy), fetchMomentsByIds (copy)
	local v6 = p1 or {}

	return {
		getMomentsByIds = function(t1: {[any]: any}) -- line: 16
			-- upvalues: HttpClient (copy), fetchMomentsByIds (copy), v6 (copy)
			return HttpClient.asPromise(fetchMomentsByIds(t1, v6.network))
		end
	}
end

return createMomentsStore
