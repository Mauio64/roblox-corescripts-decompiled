local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppCommonLib").Parent
local IsVRAppBuild = require(script.Parent.IsVRAppBuild)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local DeviceType = RobloxAppEnums.DeviceType

local function getDeviceType(p1) -- line: 16
	-- upvalues: IsVRAppBuild (copy), DeviceType (copy), GuiService (copy), UserInputService (copy), DeviceOrientationMode (copy)
	if IsVRAppBuild() then
		return DeviceType.VR
	end

	if GuiService:IsTenFootInterface() then
		return DeviceType.Console
	end

	local None = Enum.Platform.None

	pcall(function() -- line: 26
		-- upvalues: None (ref), UserInputService (copy)
		None = UserInputService:GetPlatform()
	end)

	if None == Enum.Platform.Windows or None == Enum.Platform.OSX or None == Enum.Platform.UWP then
		return DeviceType.Desktop
	end

	if None == Enum.Platform.IOS or None == Enum.Platform.Android then
		if p1 == DeviceOrientationMode.Landscape then
			return DeviceType.Tablet
		end

		if p1 == DeviceOrientationMode.Portrait then
			return DeviceType.Phone
		end
	end

	return DeviceType.Unknown
end

return getDeviceType
