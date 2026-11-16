local parent = script.Parent
local RoactUtils = require(parent.RoactUtils)
local createLazyComponent = RoactUtils.Components.createLazyComponent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local FFlagEnableFlyoutNavRailBumperNavigation = SharedFlags.FFlagEnableFlyoutNavRailBumperNavigation
local FFlagFlyoutUseOpenHook = SharedFlags.FFlagFlyoutUseOpenHook
local FFlagSendLogOutClickTelemetry = SharedFlags.FFlagSendLogOutClickTelemetry
local FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local components = {
	FlyoutSidePanelComponent = createLazyComponent(function()
		return require(script.Components.FlyoutSidePanelComponent)
	end),
	FlyoutProfileCard = createLazyComponent(function()
		return require(script.Components.FlyoutProfileCard)
	end),
	FlyoutLeftHeader = require(script.Components.FlyoutLeftHeader),
	FlyoutStatusListener = 0,
	FlyoutHamburgerButton = 0
}
local flyoutStatusListener

if not FFlagEnableHomeRobloxLogo then
	flyoutStatusListener = require(script.Components.FlyoutStatusListener)
end

components.FlyoutStatusListener = flyoutStatusListener
local flyoutHamburgerButton

if FFlagEnableFlyoutOnNavRail then
	flyoutHamburgerButton = require(script.Components.FlyoutHamburgerButton)
end

components.FlyoutHamburgerButton = flyoutHamburgerButton

local utils = {
	shouldShowLeftHeader = require(script.Utils.shouldShowLeftHeader),
	sendMoreLegacyAndFlyoutItemClickEvent = 0,
	logCTAChangeMorePageFlyoutButtonTextExposure = 0
}
local sendMoreLegacyAndFlyoutItemClickEvent

if FFlagSendLogOutClickTelemetry then
	local FlyoutAnalytics = require(script.Analytics.FlyoutAnalytics)
	sendMoreLegacyAndFlyoutItemClickEvent = FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent
end

utils.sendMoreLegacyAndFlyoutItemClickEvent = sendMoreLegacyAndFlyoutItemClickEvent
local logCTAChangeMorePageFlyoutButtonTextExposure

if FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then
	logCTAChangeMorePageFlyoutButtonTextExposure = require(script.Utils.logCTAChangeMorePageFlyoutButtonTextExposure)
end

utils.logCTAChangeMorePageFlyoutButtonTextExposure = logCTAChangeMorePageFlyoutButtonTextExposure
local useOpenFlyoutSidePanel

if FFlagEnableFlyoutNavRailBumperNavigation or FFlagFlyoutUseOpenHook then
	useOpenFlyoutSidePanel = require(script.Hooks.useOpenFlyoutSidePanel)
end

return {
	Components = components,
	Utils = utils,
	Hooks = { useOpenFlyoutSidePanel = useOpenFlyoutSidePanel },
	FlyoutScrollAwayControl = require(script.FlyoutScrollAwayControl),
	["jest.config"] = script["jest.config"]
}
