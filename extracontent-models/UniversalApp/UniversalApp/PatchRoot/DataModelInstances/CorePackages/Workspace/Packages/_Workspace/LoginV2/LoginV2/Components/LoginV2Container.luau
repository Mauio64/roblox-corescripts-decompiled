local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local React = require(LoginV2Parent.React)
local RoactNavigation = require(LoginV2Parent.RoactNavigation)
local UIBlox = require(LoginV2Parent.UIBlox)
local useNavigation = require(LoginV2Parent.Navigation).useNavigation
local useEffect = React.useEffect
local memoize = require(LoginV2Parent.AppCommonLib).memoize
local DarkTheme = UIBlox.App.Style.Themes.DarkTheme
local useStyle = UIBlox.Core.Style.useStyle

require(LoginV2.Components.Types)

local NotificationType = require(LoginV2Parent.RobloxAppEnums).NotificationType
local LoginContextProvider = require(LoginV2.Context.LoginContextProvider)
local LoginSwitchNavigator = require(LoginV2.Navigators.LoginSwitchNavigator)
local _ = {
	LIGHT = "lightcontent",
	DEFAULT = "default"
}

local function v18(s1: string) -- line: 33
	-- upvalues: UserInputService (copy), GuiService (copy), HttpService (copy), NotificationType (copy)
	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		GuiService:BroadcastNotification(HttpService:JSONEncode({
			style = s1
		}), NotificationType.SET_STATUS_BAR_STYLE)
	end
end

local v19 = memoize(function(p1) -- line: 45
	-- upvalues: RoactNavigation (copy)
	return RoactNavigation.createAppContainer(p1)
end)

return function(t1: {[any]: any}) -- line: 49
	-- upvalues: useNavigation (copy), useStyle (copy), v19 (copy), LoginSwitchNavigator (copy), useEffect (copy), DarkTheme (copy), v18 (copy), React (copy), LoginContextProvider (copy)
	local v23 = useNavigation()
	local v24 = useStyle()
	local v25 = v19(LoginSwitchNavigator)

	useEffect(function() -- line: 56
		-- upvalues: v24 (copy), DarkTheme (copy), v18 (copy)
		local v26 = v24.Theme ~= DarkTheme and "default" or "lightcontent"

		v18(v26)

		return function() -- line: 60
			-- upvalues: v18 (copy)
			v18("default")
		end
	end, {})

	return React.createElement(LoginContextProvider, {
		parentNavigation = v23,
		monoDeps = t1.monoDeps
	}, {
		NavigationAppContainer = React.createElement(v25)
	})
end
