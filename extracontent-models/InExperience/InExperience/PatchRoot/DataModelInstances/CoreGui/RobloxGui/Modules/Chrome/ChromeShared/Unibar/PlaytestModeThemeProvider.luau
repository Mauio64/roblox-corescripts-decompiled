local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Constants = UIBlox.App.Style.Constants
local Style = require(CorePackages.Workspace.Packages.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local AppearanceContext = Style.AppearanceContext
local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local useIsPlaytestMode = require(script.Parent.Parent.Hooks.useIsPlaytestMode)

local function ThemeSwitcher(p)
	local v = React.useContext(AppearanceContext)

	React.useLayoutEffect(function()
		v.setTheme(p.themeName)
	end, { p.themeName, v })

	return React.createElement(React.Fragment, nil, p.children)
end

local function PlaytestModeThemeProvider(p)
	local themeName

	if useIsPlaytestMode() then
		themeName = ColorMode.Light
	else
		themeName = ColorMode.Dark
	end

	return React.createElement(UiModeStyleProvider, {
		style = { themeName = themeName, fontName = Constants.FontName.Gotham }
	}, {
		ThemeSwitcher = React.createElement(ThemeSwitcher, { themeName = themeName }, p.children)
	})
end

return PlaytestModeThemeProvider
