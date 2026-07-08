local scriptParent = script.Parent
local createLazyComponent = require(scriptParent.RoactUtils).Components.createLazyComponent
local FFlagEnableHomeRobloxLogo = require(scriptParent.SharedFlags).FFlagEnableHomeRobloxLogo

return {
	Components = {
		FlyoutSidePanelComponent = createLazyComponent(function() -- line: 8
			return require(script.Components.FlyoutSidePanelComponent)
		end),
		FlyoutProfileCard = createLazyComponent(function() -- line: 11
			return require(script.Components.FlyoutProfileCard)
		end),
		FlyoutLeftHeader = require(script.Components.FlyoutLeftHeader),
		FlyoutStatusListener = if not FFlagEnableHomeRobloxLogo then require(script.Components.FlyoutStatusListener) else nil
	},
	Flags = {
		FFlagFlyoutTermsPrivacyFooter = require(script.Flags.FFlagFlyoutTermsPrivacyFooter)
	},
	Utils = {
		shouldShowLeftHeader = require(script.Utils.shouldShowLeftHeader)
	},
	FlyoutScrollAwayControl = require(script.FlyoutScrollAwayControl)
}
