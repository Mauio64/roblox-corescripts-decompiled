local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DeviceOrientationStore/Signals")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/DeviceOrientationStore/RobloxAppEnums").DeviceOrientationMode
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/DeviceOrientationStore/AppCommonLib").IsVRAppBuild

return Signals.createComputed(function()
	local signal, v5 = Signals.createSignal(nil)

	local computed = Signals.createComputed(function(p2): boolean
		return signal(p2) == deviceOrientationMode.Portrait
	end)

	return {
		getDeviceOrientation = signal,
		getIsPortrait = computed,
		getIsAvatarScenePortrait = Signals.createComputed(function(p2)
			return isVRAppBuild() or computed(p2)
		end),
		setDeviceOrientation = v5,
		reset = function()
			v5(nil)
		end
	}
end)
