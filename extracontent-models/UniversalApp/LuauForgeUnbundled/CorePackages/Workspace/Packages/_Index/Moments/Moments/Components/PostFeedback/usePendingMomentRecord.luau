local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")

local function usePendingMomentRecord(p2)
	local v5 = SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getPendingUserMoments)

	for k, v6 in v5 do
		if v6 == nil then
			continue
		end

		for k2, v7 in v6 do
			if v7.moment.momentId == p2 then
				if v7.publishedMoment == nil then
					return v7
				end

				return nil
			end
		end
	end

	return nil
end

return usePendingMomentRecord
