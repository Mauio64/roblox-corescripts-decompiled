local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fIntPlusReferralRewardRobux = SharedFlags.FIntPlusReferralRewardRobux

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppNavigation").NavigationCommands else nil

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local usePlusReferralFlyoutNewBadge = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/usePlusReferralFlyoutNewBadge")

local function PlusReferralBanner(p2)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Heading.ReferralEntry",
			amount = fIntPlusReferralRewardRobux
		},
		newBadgeText = "Feature.RobloxSubscription.Label.New"
	})

	local v9 = usePlusReferralFlyoutNewBadge(React.useCallback(function()
		p2.closeDrawer()
		local v9 = { name = appPage.PlusReferralDashboard }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v6(navigateDown(v9))
		end

		FlyoutAnalytics.onFlyoutContentItemClicked({
			integrationId = "PlusReferral",
			source = "click"
		})
	end, { p2.closeDrawer, v6 }), "RobloxPlusUpsellImpressionCount1")

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-medium",
		onActivated = v9.onActivated,
		testId = "--core-ui-flyout-plus-referral",
		LayoutOrder = p2.layoutOrder
	}
	local v11 = {
		PlusIcon = React.createElement(icon, {
			style = v5.Color.Content.Emphasis,
			name = iconName.RobloxPlus,
			size = iconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = React.createElement(text, {
			tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
			Text = v7.bannerText,
			LayoutOrder = 2
		}),
		NewBadge = 0
	}

	local v12 = if v9.shouldShowNewBadge then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-circle bg-system-contrast",
			LayoutOrder = 3
		},
		{
			Text = React.createElement(text, {
				Text = v7.newBadgeText,
				tag = "auto-xy text-title-small",
				textStyle = v5.Color.Surface.Surface_0
			})
		}
	) else nil
	v11.NewBadge = v12
	return createElement(view, v10, v11)
end

return PlusReferralBanner
