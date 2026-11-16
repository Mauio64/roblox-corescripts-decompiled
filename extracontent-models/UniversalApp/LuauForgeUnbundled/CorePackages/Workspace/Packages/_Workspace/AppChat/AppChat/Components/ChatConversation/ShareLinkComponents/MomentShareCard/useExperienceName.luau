local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local GameGetGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration/GameGetGameInfoStore")

local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus

local FFlagAppChatMomentShareCardLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMomentShareCardLoadingSkeletons")

local computed = Signals.createComputed(function(): nil
	return nil
end)

local function useExperienceName(p2, p3)
	local v5 = if p2 and p2 ~= 0 then tostring(p2) else nil

	local v6 = if p3 and v5 then GameGetGameInfoStore(false).getAndFetchGameInfo(v5) else nil

	local useSignalState = SignalsReact.useSignalState
	local v7 = if v6 then v6.data else computed
	local v8 = useSignalState(v7)
	local v9

	if FFlagAppChatMomentShareCardLoadingSkeletons then
		local useSignalState2 = SignalsReact.useSignalState
		local v10 = if v6 then v6.status else computed
		v9 = useSignalState2(v10)
	end

	local v11 = if v8 then v8.name else nil
	return {
		name = v11,
		isLoading = v9 == dataStatus.NotReady
	}
end

return useExperienceName
