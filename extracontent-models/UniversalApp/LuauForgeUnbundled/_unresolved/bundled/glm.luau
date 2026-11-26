local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gln")
local module3 = require("@luauforge/bundled/gjF")
local module4 = require("@luauforge/bundled/gjJ")
local module5 = require("@luauforge/bundled/gjI")
local useNavigation = require("@luauforge/bundled/glo").useNavigation
local useEffect = module.useEffect
local memoize = require("@luauforge/bundled/glp").memoize
local darkTheme = module3.App.Style.Themes.DarkTheme
local useStyle = module3.Core.Style.useStyle
local user = require("@luauforge/bundled/ggL").Thunks.User
local fFlagAccountSwitcherForceDarkAuthTheme = require("@luauforge/bundled/gjO").FFlagAccountSwitcherForceDarkAuthTheme

require("@luauforge/bundled/gjL")
local notificationType = require("@luauforge/bundled/ggZ").NotificationType

local module6 = require("@luauforge/bundled/glq")
local module7 = require("@luauforge/bundled/glT")

local v5 = { LIGHT = "lightcontent", DEFAULT = "default" }

local function fn(p2)
	if UserInputService:GetPlatform() == Enum.Platform.IOS then
		GuiService:BroadcastNotification(
			HttpService:JSONEncode({ style = p2 }),
			notificationType.SET_STATUS_BAR_STYLE
		)
	end
end

local v6 = memoize(function(p2)
	return module2.createAppContainer(p2)
end)

local v7 = {
	themeName = module4.Enums.ColorMode.Dark,
	fontName = module5.Constants.FontName.Gotham
}

local function isSignedIn(): boolean
	return user.fromLocalStorage().userId ~= -1
end

return function(p2)
	local v8 = useNavigation()
	local v9 = useStyle()
	local v10 = v6(module7)

	local v11 = if fFlagAccountSwitcherForceDarkAuthTheme then module.useState(isSignedIn) else false

	useEffect(function()
		fn((v11 or v9.Theme == darkTheme) and "lightcontent" or "default")
		return function()
			fn("default")
		end
	end, { v11 })
	local element = module.createElement(
		module6,
		{ parentNavigation = v8, monoDeps = p2.monoDeps, isVisible = p2.isVisible },
		{ NavigationAppContainer = module.createElement(v10) }
	)

	if v11 then
		return module.createElement(module5.UiModeStyleProvider, { style = v7 }, {
			LoginFlow = element
		})
	end

	return element
end
