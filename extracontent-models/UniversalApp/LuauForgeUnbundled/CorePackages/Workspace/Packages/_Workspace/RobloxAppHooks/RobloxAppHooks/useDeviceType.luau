local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/SignalsReact").useSignalState

require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppEnums")
local getDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/AppCommonLib").getDeviceType

local fFlagUseSignalsForDeviceOrientation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/SharedFlags").FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/DeviceOrientationStore").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local function useDeviceType()
	local v5

	if fFlagUseSignalsForDeviceOrientation then
		v5 = useSignalState(getDeviceOrientationStore(false).getDeviceOrientation)
	else
		v5 = useSelector(function(p2)
			return p2.DeviceOrientation
		end)
	end

	return getDeviceType(v5)
end

return useDeviceType
