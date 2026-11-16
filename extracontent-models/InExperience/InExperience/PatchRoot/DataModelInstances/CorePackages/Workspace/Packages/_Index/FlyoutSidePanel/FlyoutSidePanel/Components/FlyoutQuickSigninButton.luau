local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagCTAChangeMorePageFlyoutButtonText = SharedFlags2.FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutQuickSigninButton(p)
	local v = useDispatch()
	local v2 = useRoactService(AppEventIngestService)

	local onActivated = React.useCallback(function()
		p.closeDrawer()
		local v3 = { name = AppPage.CrossDeviceLogin }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3))
		else
			v(NavigateDown(v3))
		end

		local quickSignin = FlyoutContentSettings.ItemType.QuickSignin
		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v2, quickSignin)
	end, { v2, p.closeDrawer })

	local v3 = useLocalization({
		title = FFlagCTAChangeMorePageFlyoutButtonText and "Authentication.Login.Action.QuickSignIn" or "Authentication.CrossDevice.Heading.QuickLogin"
	})

	return React.createElement(Button, {
		testId = "--core-ui-flyout-button-quick-signin",
		text = v3.title,
		variant = ButtonVariant.Standard,
		LayoutOrder = p.layoutOrder,
		onActivated = onActivated,
		isDisabled = false,
		size = ButtonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutQuickSigninButton
