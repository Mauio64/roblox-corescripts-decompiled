local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local Style = require("@game/CorePackages/Workspace/Packages/Style")
local uiModeStyleProvider = Style.UiModeStyleProvider

local Foundation = require(CorePackages.Packages.Foundation)

local Cryo = require(CorePackages.Packages.Cryo)

local themeName = Foundation.Enums.ThemeName

local module2 = require("@luauforge/bundled/fHL")

local module3 = require("@luauforge/bundled/ifp")

local module4 = require("@luauforge/bundled/iaJ")

local fFlagSubscriptionPurchaseFollowsAppTheme = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSubscriptionPurchaseFollowsAppTheme

return function(p2)
	module3()

	local v5 = module2()

	if fFlagSubscriptionPurchaseFollowsAppTheme then
		React.useEffect(function()
			Style.AppFoundationThemeName.setAppFoundationThemeName(v5)
			return function()
				Style.AppFoundationThemeName.setAppFoundationThemeName(nil)
			end
		end, { v5 })
	end

	local v6 = v5 == themeName.Classic and "Classic" or p2.style.fontName
	local v7 = {
		foundationThemeName = v5 or Cryo.None,
		style = Cryo.Dictionary.join(p2.style, { fontName = v6 })
	}
	local v8

	if module4 then
		v8 = React.useMemo(function()
			return React.createElement(uiModeStyleProvider, Cryo.Dictionary.join(p2, v7))
		end, { p2, v5, v6 })
	else
		v8 = React.createElement(uiModeStyleProvider, Cryo.Dictionary.join(p2, v7))
	end

	return ReactRoblox.createPortal({ v8 }, CoreGui)
end
