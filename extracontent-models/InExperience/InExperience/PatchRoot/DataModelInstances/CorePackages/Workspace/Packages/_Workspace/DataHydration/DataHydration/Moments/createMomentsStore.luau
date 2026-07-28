local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpClient = require(Parent.HttpClient)
local SharedFlags = require(Parent.SharedFlags)

require(script.Parent.MomentsStoreTypes)

local fetchMomentsByIds = require(script.Parent.Requests.fetchMomentsByIds)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis

local function createMomentsStore(p1) -- line: 15
	-- upvalues: HttpClient (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy)
	local v8 = p1 or {}

	return {
		getMomentsByIds = function(t1: {[any]: any}, s1: string?) -- line: 18
			-- upvalues: HttpClient (copy), FFlagMomentsPassFeedItemIdToBackendApis (copy), fetchMomentsByIds (copy), v8 (copy)
			return HttpClient.asPromise(if not FFlagMomentsPassFeedItemIdToBackendApis then fetchMomentsByIds(t1, v8.network) else fetchMomentsByIds(t1, v8.network, s1))
		end
	}
end

return createMomentsStore
