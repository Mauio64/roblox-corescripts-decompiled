local parent = script:FindFirstAncestor("RoactUtils").Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local RobloxAppEnums = require(parent.RobloxAppEnums)
local NotificationType = RobloxAppEnums.NotificationType

local React = require(parent.React)

local _ = { LIGHT = "lightcontent", DEFAULT = "default" }

local function fn(style: string)
	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({ style = style }),
			NotificationType.SET_STATUS_BAR_STYLE
		)
	end
end

local function useIOSStatusBarStyler(flag: boolean, callback)
	local v = callback or fn
	React.useEffect(function()
		v(flag and "lightcontent" or "default")
		return function()
			v("default")
		end
	end, { flag })
end

return useIOSStatusBarStyler
