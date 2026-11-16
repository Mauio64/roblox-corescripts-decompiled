local UserInputService = game:GetService("UserInputService")

local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local AppCommonLib = require(NotificationsCommon.Parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local DeviceInfo = {}

function DeviceInfo.isDesktopDevice(): boolean
	local v = Enum.Platform.None
	pcall(function()
		v = UserInputService:GetPlatform()
	end)
	return v == Enum.Platform.Windows or v == Enum.Platform.OSX or v == Enum.Platform.UWP
end

function DeviceInfo.isConsole()
	return isTenFootInterface()
end

return DeviceInfo
