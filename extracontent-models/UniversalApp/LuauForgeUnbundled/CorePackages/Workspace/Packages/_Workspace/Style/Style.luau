local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/StyleProviderWithDefaultTheme")
local fFlagAppNavBarPerItemThemeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/SharedFlags").FFlagAppNavBarPerItemThemeOverride

local DesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/DesignTokens")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/UiModeStyleProvider")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/AppFoundationThemeName")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/FFlagAppClassicThemeGreenButtonColors")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/getClassicThemeTokenOverrides")

local v5 = {
	AppStyleProvider = UIBlox.App.Style.AppStyleProvider,
	Colors = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/Colors"),
	Constants = UIBlox.App.Style.Constants,
	Themes = {
		DarkTheme = UIBlox.App.Style.Themes.DarkTheme,
		LightTheme = UIBlox.App.Style.Themes.LightTheme
	},
	DesignTokenProvider = DesignTokens.DesignTokenProvider,
	UiModeStyleProvider = module4,
	useDesignTokens = DesignTokens.useDesignTokens,
	mapTypographyVariantToFontEnum = DesignTokens.mapTypographyVariantToFontEnum,
	GetTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/Utils/GetTextSize"),
	StyleProviderWithDefaultTheme = module2,
	AppFoundationThemeName = module5,
	FFlagAppClassicThemeGreenButtonColors = module6,
	getClassicThemeTokenOverrides = module7,
	AppFonts = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/AppFonts"),
	AppearanceContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/AppearanceContext"),
	UiModeBrandThemeContext = 0,
	getSceneOverridesStore = 0
}

local v6 = if fFlagAppNavBarPerItemThemeOverride then require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/UiModeBrandThemeContext") else nil
v5.UiModeBrandThemeContext = v6

v5.getSceneOverridesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/getSceneOverridesStore")
return v5
