local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AppCommonLib").Parent

local IsVRAppBuild = require(script.Parent.IsVRAppBuild)
local isTenFootInterface = require(script.Parent.isTenFootInterface)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local DeviceType = RobloxAppEnums.DeviceType

local function getDeviceType(p)
	if IsVRAppBuild() then
		return DeviceType.VR
	end

	if isTenFootInterface() then
		return DeviceType.Console
	end

	local v = Enum.Platform.None
	pcall(function()
		v = UserInputService:GetPlatform()
	end)

	if v == Enum.Platform.Windows or v == Enum.Platform.OSX or v == Enum.Platform.UWP then
		return DeviceType.Desktop
	end

	if v ~= Enum.Platform.IOS and v ~= Enum.Platform.Android then
		return DeviceType.Unknown
	end

	if p == DeviceOrientationMode.Landscape then
		return DeviceType.Tablet
	end

	if p == DeviceOrientationMode.Portrait then
		return DeviceType.Phone
	end

	return DeviceType.Unknown
end

return getDeviceType
