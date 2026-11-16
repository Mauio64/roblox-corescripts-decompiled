local UserInputService = game:GetService("UserInputService")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/AppCommonLib").isTenFootInterface

return {
	isDesktopDevice = function(): boolean
		local v5 = Enum.Platform.None
		pcall(function()
			v5 = UserInputService:GetPlatform()
		end)
		return v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX or v5 == Enum.Platform.UWP
	end,
	isConsole = function()
		return isTenFootInterface()
	end
}
