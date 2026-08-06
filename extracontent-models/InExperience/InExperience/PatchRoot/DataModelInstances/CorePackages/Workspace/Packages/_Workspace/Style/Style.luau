local scriptParent = script.Parent
local UIBlox = require(scriptParent.UIBlox)
local StyleProviderWithDefaultTheme = require(script.StyleProviderWithDefaultTheme)
local FFlagAppNavBarPerItemThemeOverride = require(scriptParent.SharedFlags).FFlagAppNavBarPerItemThemeOverride
local DesignTokens = require(script.DesignTokens)
local UiModeStyleProvider = require(script.UiModeStyleProvider)

return {
	AppStyleProvider = UIBlox.App.Style.AppStyleProvider,
	Colors = require(script.Colors),
	Constants = UIBlox.App.Style.Constants,
	Themes = {
		DarkTheme = UIBlox.App.Style.Themes.DarkTheme,
		LightTheme = UIBlox.App.Style.Themes.LightTheme
	},
	DesignTokenProvider = DesignTokens.DesignTokenProvider,
	UiModeStyleProvider = UiModeStyleProvider,
	useDesignTokens = DesignTokens.useDesignTokens,
	mapTypographyVariantToFontEnum = DesignTokens.mapTypographyVariantToFontEnum,
	GetTextSize = require(script.Utils.GetTextSize),
	StyleProviderWithDefaultTheme = StyleProviderWithDefaultTheme,
	AppFonts = require(script.AppFonts),
	ThemeContext = require(script.ThemeContext),
	UiModeTokenOverridesContext = if not FFlagAppNavBarPerItemThemeOverride then nil else require(script.UiModeTokenOverridesContext),
	getSceneOverridesStore = require(script.getSceneOverridesStore),
	["jest.config"] = script["jest.config"]
}
