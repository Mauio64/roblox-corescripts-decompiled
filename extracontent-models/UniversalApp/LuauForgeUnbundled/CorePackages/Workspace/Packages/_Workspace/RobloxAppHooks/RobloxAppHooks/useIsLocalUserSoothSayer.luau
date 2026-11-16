local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/SignalsReact").useSignalState
local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if fFlagUseSignalsForIsLocalUserSoothsayer then
	getIsLocalUserSoothsayerStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/IsLocalUserSoothsayerStore").GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

return function()
	if fFlagUseSignalsForIsLocalUserSoothsayer then
		return useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
	end

	return useSelector(function(p2)
		return p2.IsLocalUserSoothsayer
	end)
end
