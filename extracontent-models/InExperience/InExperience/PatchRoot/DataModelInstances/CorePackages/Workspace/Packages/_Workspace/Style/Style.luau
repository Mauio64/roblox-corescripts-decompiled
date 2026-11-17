local parent = script.Parent
local UIBlox = require(parent.UIBlox)
local StyleProviderWithDefaultTheme = require(script.StyleProviderWithDefaultTheme)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppNavBarPerItemThemeOverride = SharedFlags.FFlagAppNavBarPerItemThemeOverride

local DesignTokens = require(script.DesignTokens)
local UiModeStyleProvider = require(script.UiModeStyleProvider)
local AppFoundationThemeName = require(script.AppFoundationThemeName)
local FFlagAppClassicThemeGreenButtonColors = require(script.FFlagAppClassicThemeGreenButtonColors)
local getClassicThemeTokenOverrides = require(script.getClassicThemeTokenOverrides)

local Style = {
	["AppStyleProvider"] = nil,
	["AppStyleProvider"] = nil,
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
	AppFoundationThemeName = AppFoundationThemeName,
	FFlagAppClassicThemeGreenButtonColors = FFlagAppClassicThemeGreenButtonColors,
	getClassicThemeTokenOverrides = getClassicThemeTokenOverrides,
	AppFonts = require(script.AppFonts),
	AppearanceContext = require(script.AppearanceContext)
}
local uiModeBrandThemeContext

if FFlagAppNavBarPerItemThemeOverride then
	uiModeBrandThemeContext = require(script.UiModeBrandThemeContext)
end

Style.UiModeBrandThemeContext = uiModeBrandThemeContext

Style.getSceneOverridesStore = require(script.getSceneOverridesStore)
Style["jest.config"] = script["jest.config"]
return Style
