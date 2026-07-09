local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsGetMomentsStore = require(Parent.DataHydration.MomentsGetMomentsStore)

local function fetchMomentsByIds(t1: {[any]: any}) -- line: 7
	-- upvalues: MomentsGetMomentsStore (copy)
	return MomentsGetMomentsStore(false).getMomentsByIds(t1)
end

return fetchMomentsByIds
