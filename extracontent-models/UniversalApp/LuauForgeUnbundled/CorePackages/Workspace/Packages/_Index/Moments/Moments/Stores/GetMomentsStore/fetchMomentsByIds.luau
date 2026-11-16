local MomentsGetMomentsStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsStore")

local function fetchMomentsByIds(p2, p3)
	return MomentsGetMomentsStore(false).getMomentsByIds(p2, p3)
end

return fetchMomentsByIds
