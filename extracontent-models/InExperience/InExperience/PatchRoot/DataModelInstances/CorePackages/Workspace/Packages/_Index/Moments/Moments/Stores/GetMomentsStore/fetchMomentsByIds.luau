local Parent = script:FindFirstAncestor("Moments").Parent
local SharedFlags = require(Parent.SharedFlags)
local MomentsGetMomentsStore = require(Parent.DataHydration.MomentsGetMomentsStore)
local FFlagMomentsPassFeedItemIdToBackendApis = SharedFlags.FFlagMomentsPassFeedItemIdToBackendApis

local function fetchMomentsByIds(t1: {[any]: any}, s1: string?) -- line: 9
	-- upvalues: FFlagMomentsPassFeedItemIdToBackendApis (copy), MomentsGetMomentsStore (copy)
	if FFlagMomentsPassFeedItemIdToBackendApis then
		return (MomentsGetMomentsStore(false).getMomentsByIds(t1, s1))
	end

	return (MomentsGetMomentsStore(false).getMomentsByIds(t1))
end

return fetchMomentsByIds
