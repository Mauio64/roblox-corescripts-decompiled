local parent = script:FindFirstAncestor("DeviceOrientationStore").Parent

local Signals = require(parent.Signals)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild

return Signals.createComputed(function()
	local signal, setDeviceOrientation = Signals.createSignal(nil)

	local getIsPortrait = Signals.createComputed(function(p): boolean
		return signal(p) == DeviceOrientationMode.Portrait
	end)

	return {
		getDeviceOrientation = signal,
		getIsPortrait = getIsPortrait,
		getIsAvatarScenePortrait = Signals.createComputed(function(p)
			return IsVRAppBuild() or getIsPortrait(p)
		end),
		setDeviceOrientation = setDeviceOrientation,
		reset = function()
			setDeviceOrientation(nil)
		end
	}
end)
