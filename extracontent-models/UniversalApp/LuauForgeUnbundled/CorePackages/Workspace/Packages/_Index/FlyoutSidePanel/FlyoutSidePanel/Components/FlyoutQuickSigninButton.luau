local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppNavigation").NavigationCommands else nil

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")

local fFlagCTAChangeMorePageFlyoutButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutQuickSigninButton(p2)
	local v5 = useDispatch()
	local v6 = useRoactService(appEventIngestService)

	local v7 = React.useCallback(function()
		p2.closeDrawer()
		local v8 = { name = appPage.CrossDeviceLogin }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v8))
		else
			v5(navigateDown(v8))
		end

		local quickSignin = FlyoutContentSettings.ItemType.QuickSignin
		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v6, quickSignin)
	end, { v6, p2.closeDrawer })

	local v8 = useLocalization({
		title = fFlagCTAChangeMorePageFlyoutButtonText and "Authentication.Login.Action.QuickSignIn" or "Authentication.CrossDevice.Heading.QuickLogin"
	})

	return React.createElement(button, {
		testId = "--core-ui-flyout-button-quick-signin",
		text = v8.title,
		variant = buttonVariant.Standard,
		LayoutOrder = p2.layoutOrder,
		onActivated = v7,
		isDisabled = false,
		size = buttonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutQuickSigninButton
