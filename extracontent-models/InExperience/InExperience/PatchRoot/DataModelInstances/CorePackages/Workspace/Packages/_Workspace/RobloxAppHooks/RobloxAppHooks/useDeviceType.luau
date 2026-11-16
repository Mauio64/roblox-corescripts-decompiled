local parent = script:FindFirstAncestor("RobloxAppHooks").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

require(parent.RobloxAppEnums)
local AppCommonLib = require(parent.AppCommonLib)
local getDeviceType = AppCommonLib.getDeviceType

local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if FFlagUseSignalsForDeviceOrientation then
	local DeviceOrientationStore = require(parent.DeviceOrientationStore)
	getDeviceOrientationStore = DeviceOrientationStore.GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local function useDeviceType()
	local v

	if FFlagUseSignalsForDeviceOrientation then
		v = useSignalState(getDeviceOrientationStore(false).getDeviceOrientation)
	else
		v = useSelector(function(p)
			return p.DeviceOrientation
		end)
	end

	return getDeviceType(v)
end

return useDeviceType
