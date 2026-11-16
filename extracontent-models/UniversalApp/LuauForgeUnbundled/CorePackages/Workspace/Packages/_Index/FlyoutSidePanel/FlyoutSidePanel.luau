local createLazyComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Components.createLazyComponent
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local fFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local fFlagEnableFlyoutNavRailBumperNavigation = SharedFlags.FFlagEnableFlyoutNavRailBumperNavigation
local fFlagFlyoutUseOpenHook = SharedFlags.FFlagFlyoutUseOpenHook
local fFlagSendLogOutClickTelemetry = SharedFlags.FFlagSendLogOutClickTelemetry
local fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local v6 = {
	FlyoutSidePanelComponent = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutSidePanelComponent")
	end),
	FlyoutProfileCard = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutProfileCard")
	end),
	FlyoutLeftHeader = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutLeftHeader"),
	FlyoutStatusListener = 0,
	FlyoutHamburgerButton = 0
}
local v7 = if not fFlagEnableHomeRobloxLogo then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutStatusListener") else nil
v6.FlyoutStatusListener = v7

local v8 = if fFlagEnableFlyoutOnNavRail then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutHamburgerButton") else nil
v6.FlyoutHamburgerButton = v8

local v9 = {
	shouldShowLeftHeader = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Utils/shouldShowLeftHeader"),
	sendMoreLegacyAndFlyoutItemClickEvent = 0,
	logCTAChangeMorePageFlyoutButtonTextExposure = 0
}

local v10 = if fFlagSendLogOutClickTelemetry then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics").sendMoreLegacyAndFlyoutItemClickEvent else nil
v9.sendMoreLegacyAndFlyoutItemClickEvent = v10

local v11 = if fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Utils/logCTAChangeMorePageFlyoutButtonTextExposure") else nil
v9.logCTAChangeMorePageFlyoutButtonTextExposure = v11

local v13 = if fFlagEnableFlyoutNavRailBumperNavigation or fFlagFlyoutUseOpenHook then require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useOpenFlyoutSidePanel") else nil
return {
	Components = v6,
	Utils = v9,
	Hooks = { useOpenFlyoutSidePanel = v13 },
	FlyoutScrollAwayControl = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/FlyoutScrollAwayControl")
}
