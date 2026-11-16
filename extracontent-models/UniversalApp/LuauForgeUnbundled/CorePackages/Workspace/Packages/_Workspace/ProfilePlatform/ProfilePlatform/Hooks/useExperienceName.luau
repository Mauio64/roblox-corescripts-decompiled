local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact")

local GameGetGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration/GameGetGameInfoStore")

local useSignalState = SignalsReact.useSignalState
local computed = Signals.createComputed(function(): nil
	return nil
end)

local function useExperienceName(p2)
	local v5 = if not (p2 == nil or p2 == 0) then tostring(p2) else nil
	local v6 = if v5 == nil then computed else GameGetGameInfoStore(false).getAndFetchGameInfo(v5).data

	local v7 = useSignalState(v6)

	if v7 == nil then
		return nil
	end

	return v7.name
end

return useExperienceName
