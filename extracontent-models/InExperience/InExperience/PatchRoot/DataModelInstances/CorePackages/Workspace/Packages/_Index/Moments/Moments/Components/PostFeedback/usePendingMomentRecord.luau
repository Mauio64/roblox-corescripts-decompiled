local parent = script:FindFirstAncestor("Moments").Parent

local SignalsReact = require(parent.SignalsReact)
require(parent.DataHydration.MomentsStoreTypes)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)

local function usePendingMomentRecord(p: string)
	local v = SignalsReact.useSignalState(MomentsGetMomentsUserStore(false).getPendingUserMoments)

	for _, v2 in v do
		if v2 == nil then
			continue
		end

		for _, v3 in v2 do
			if v3.moment.momentId == p then
				return if v3.publishedMoment == nil then v3 else nil
			end
		end
	end

	return nil
end

return usePendingMomentRecord
