local UserInputService = game:GetService("UserInputService")

local IsVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/IsVRAppBuild")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isTenFootInterface")

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/RobloxAppEnums")
local deviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local deviceType = RobloxAppEnums.DeviceType

local function getDeviceType(p2)
	if IsVRAppBuild() then
		return deviceType.VR
	end

	if isTenFootInterface() then
		return deviceType.Console
	end

	local v5 = Enum.Platform.None
	pcall(function()
		v5 = UserInputService:GetPlatform()
	end)

	if v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX or v5 == Enum.Platform.UWP then
		return deviceType.Desktop
	end

	if v5 ~= Enum.Platform.IOS and v5 ~= Enum.Platform.Android then
		return deviceType.Unknown
	end

	if p2 == deviceOrientationMode.Landscape then
		return deviceType.Tablet
	end

	if p2 == deviceOrientationMode.Portrait then
		return deviceType.Phone
	end

	return deviceType.Unknown
end

return getDeviceType
