local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local GameGetGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/GameGetGameInfoStore")

local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos

local useSignalState = SignalsReact.useSignalState

local v5 = {
	name = nil,
	creatorName = nil,
	isCreatorVerified = false,
	rootPlaceId = nil
}
local computed = Signals.createComputed(function(): nil
	return nil
end)

return function(p2)
	local v6 = if p2 and p2 ~= 0 then tostring(p2) else nil
	local v7 = if v6 then GameGetGameInfoStore(false).getAndFetchGameInfo(v6).data else computed
	local v8 = useSignalState(v7)

	if v8 == nil then
		return v5
	end

	local creator = v8.creator
	local v9 = {
		name = v8.name,
		creatorName = 0,
		isCreatorVerified = 0,
		rootPlaceId = 0
	}
	local v10 = if creator then creator.name else nil
	v9.creatorName = v10
	local v11 = if creator then creator.hasVerifiedBadge == true else false
	v9.isCreatorVerified = v11
	local v12 = if fFlagMomentsServeEDPVideos then tonumber(v8.rootPlaceId) else nil
	v9.rootPlaceId = v12
	return v9
end
