local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(CorePackages.Packages.UIBlox).App.Style.Constants
local Style = require(CorePackages.Workspace.Packages.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local ThemeContext = Style.ThemeContext
local useIsPlaytestMode = require(script.Parent.Parent.Hooks.useIsPlaytestMode)

local function ThemeSwitcher(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), ThemeContext (copy)
	local v11 = React.useContext(ThemeContext)

	React.useLayoutEffect(function() -- line: 24
		-- upvalues: v11 (copy), t1 (copy)
		v11.setTheme(t1.themeName)
	end, {
		t1.themeName,
		v11
	})

	return React.createElement(React.Fragment, nil, t1.children)
end
local function PlaytestModeThemeProvider(t2: {[any]: any}) -- line: 31
	-- upvalues: useIsPlaytestMode (copy), Constants (copy), React (copy), UiModeStyleProvider (copy), ThemeSwitcher (copy)
	local v13 = if not useIsPlaytestMode() then Constants.ThemeName.Dark else Constants.ThemeName.Light

	return React.createElement(UiModeStyleProvider, {
		style = {
			themeName = v13,
			fontName = Constants.FontName.Gotham
		}
	}, {
		ThemeSwitcher = React.createElement(ThemeSwitcher, {
			themeName = v13
		}, t2.children)
	})
end

return PlaytestModeThemeProvider
