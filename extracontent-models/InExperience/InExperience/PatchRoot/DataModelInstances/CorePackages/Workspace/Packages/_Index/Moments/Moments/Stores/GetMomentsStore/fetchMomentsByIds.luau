local parent = script:FindFirstAncestor("Moments").Parent

local MomentsGetMomentsStore = require(parent.DataHydration.MomentsGetMomentsStore)

local function fetchMomentsByIds(p, p2: string?)
	return MomentsGetMomentsStore(false).getMomentsByIds(p, p2)
end

return fetchMomentsByIds
