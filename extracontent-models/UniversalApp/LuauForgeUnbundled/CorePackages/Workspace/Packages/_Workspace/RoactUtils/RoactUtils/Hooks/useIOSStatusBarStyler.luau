local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local notificationType = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RobloxAppEnums").NotificationType

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local v5 = { LIGHT = "lightcontent", DEFAULT = "default" }

local function fn(p2)
	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({ style = p2 }),
			notificationType.SET_STATUS_BAR_STYLE
		)
	end
end

local function useIOSStatusBarStyler(p2, p3)
	local v6 = p3 or fn
	React.useEffect(function()
		v6(p2 and "lightcontent" or "default")
		return function()
			v6("default")
		end
	end, { p2 })
end

return useIOSStatusBarStyler
