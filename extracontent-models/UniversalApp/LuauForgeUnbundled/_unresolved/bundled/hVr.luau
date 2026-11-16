local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local uiModeStyleProvider = require("@game/CorePackages/Workspace/Packages/Style").UiModeStyleProvider

local Foundation = require(CorePackages.Packages.Foundation)

local Cryo = require(CorePackages.Packages.Cryo)

local themeName = Foundation.Enums.ThemeName

local module = require("@luauforge/bundled/fzW")

local module2 = require("@luauforge/bundled/hVs")

local module3 = require("@luauforge/bundled/hRj")

return function(p2)
	module2()

	local v5 = module()
	local v6 = v5 == themeName.Classic and "Classic" or p2.style.fontName
	local v7 = {
		foundationThemeName = v5 or Cryo.None,
		style = Cryo.Dictionary.join(p2.style, { fontName = v6 })
	}
	local v8

	if module3 then
		v8 = React.useMemo(function()
			return React.createElement(uiModeStyleProvider, Cryo.Dictionary.join(p2, v7))
		end, { p2, v5, v6 })
	else
		v8 = React.createElement(uiModeStyleProvider, Cryo.Dictionary.join(p2, v7))
	end

	return ReactRoblox.createPortal({ v8 }, CoreGui)
end
