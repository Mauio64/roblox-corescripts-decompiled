local scriptParent = script.Parent
local createLazyComponent = require(scriptParent.RoactUtils).Components.createLazyComponent
local SharedFlags = require(scriptParent.SharedFlags)
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail

return {
	Components = {
		FlyoutSidePanelComponent = createLazyComponent(function() -- line: 9
			return require(script.Components.FlyoutSidePanelComponent)
		end),
		FlyoutProfileCard = createLazyComponent(function() -- line: 12
			return require(script.Components.FlyoutProfileCard)
		end),
		FlyoutLeftHeader = require(script.Components.FlyoutLeftHeader),
		FlyoutStatusListener = if not FFlagEnableHomeRobloxLogo then require(script.Components.FlyoutStatusListener) else nil,
		FlyoutHamburgerButton = if not FFlagEnableFlyoutOnNavRail then nil else require(script.Components.FlyoutHamburgerButton)
	},
	Flags = {
		FFlagFlyoutTermsPrivacyFooter = require(script.Flags.FFlagFlyoutTermsPrivacyFooter)
	},
	Utils = {
		shouldShowLeftHeader = require(script.Utils.shouldShowLeftHeader)
	},
	FlyoutScrollAwayControl = require(script.FlyoutScrollAwayControl),
	["jest.config"] = script["jest.config"]
}
