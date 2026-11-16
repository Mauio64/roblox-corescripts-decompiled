local fFlagEnableClassicThemeHeaderBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SharedFlags").FFlagEnableClassicThemeHeaderBackground

local v5 = {
	AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Components/AppHeaderBarResponsive"),
	AppHeaderBarClassicThemeBackground = 0,
	useClassicThemeHeaderBackgroundConfig = 0,
	makeBackButton = 0,
	makeCloseButton = 0
}

local v6 = if fFlagEnableClassicThemeHeaderBackground then require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Components/AppHeaderBarClassicThemeBackground") else nil
v5.AppHeaderBarClassicThemeBackground = v6

local v7 = if fFlagEnableClassicThemeHeaderBackground then require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Hooks/useClassicThemeHeaderBackgroundConfig") else nil
v5.useClassicThemeHeaderBackgroundConfig = v7

v5.makeBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Utils").makeBackButton
v5.makeCloseButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Utils").makeCloseButton
return v5
