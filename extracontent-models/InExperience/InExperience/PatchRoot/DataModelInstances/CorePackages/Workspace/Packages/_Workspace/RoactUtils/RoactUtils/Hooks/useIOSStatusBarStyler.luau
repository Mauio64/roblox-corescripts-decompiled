local Parent = script:FindFirstAncestor("RoactUtils").Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local NotificationType = require(Parent.RobloxAppEnums).NotificationType
local React = require(Parent.React)
local _ = {
	LIGHT = "lightcontent",
	DEFAULT = "default"
}

local function v8(s1: string) -- line: 19
	-- upvalues: UserInputService (copy), GuiService (copy), HttpService (copy), NotificationType (copy)
	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		GuiService:BroadcastNotification(HttpService:JSONEncode({
			style = s1
		}), NotificationType.SET_STATUS_BAR_STYLE)
	end
end
local function useIOSStatusBarStyler(b1: boolean, p1: ((...any) -> ...any)?) -- line: 31
	-- upvalues: v8 (copy), React (copy)
	local v13 = p1 or v8

	React.useEffect(function() -- line: 34
		-- upvalues: b1 (copy), v13 (copy)
		local v14 = not b1 and "default" or "lightcontent"

		v13(v14)

		return function() -- line: 37
			-- upvalues: v13 (copy)
			v13("default")
		end
	end, { b1 })
end

return useIOSStatusBarStyler
