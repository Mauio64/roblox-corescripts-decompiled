local parent = script.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground

local AppHeaderBar = {}
AppHeaderBar.AppHeaderBar = require(script.Components.AppHeaderBarResponsive)
local appHeaderBarClassicThemeBackground

if FFlagEnableClassicThemeHeaderBackground then
	appHeaderBarClassicThemeBackground = require(script.Components.AppHeaderBarClassicThemeBackground)
end

AppHeaderBar.AppHeaderBarClassicThemeBackground = appHeaderBarClassicThemeBackground
local useClassicThemeHeaderBackgroundConfig

if FFlagEnableClassicThemeHeaderBackground then
	useClassicThemeHeaderBackgroundConfig = require(script.Hooks.useClassicThemeHeaderBackgroundConfig)
end

AppHeaderBar.useClassicThemeHeaderBackgroundConfig = useClassicThemeHeaderBackgroundConfig

local Utils = require(script.Utils)
AppHeaderBar.makeBackButton = Utils.makeBackButton
local Utils2 = require(script.Utils)
AppHeaderBar.makeCloseButton = Utils2.makeCloseButton
AppHeaderBar["jest.config"] = script["jest.config"]
return AppHeaderBar
