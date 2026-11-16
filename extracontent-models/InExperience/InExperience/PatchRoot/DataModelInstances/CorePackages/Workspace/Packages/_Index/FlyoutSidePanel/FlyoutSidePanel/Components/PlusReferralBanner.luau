local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FIntPlusReferralRewardRobux = SharedFlags.FIntPlusReferralRewardRobux
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local usePlusReferralFlyoutNewBadge = require(FlyoutSidePanel.Hooks.usePlusReferralFlyoutNewBadge)

local function PlusReferralBanner(p)
	local v = useTokens()
	local v2 = useDispatch()
	local v3 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Heading.ReferralEntry",
			amount = FIntPlusReferralRewardRobux
		},
		newBadgeText = "Feature.RobloxSubscription.Label.New"
	})

	local v4 = usePlusReferralFlyoutNewBadge(React.useCallback(function()
		p.closeDrawer()
		local v4 = { name = AppPage.PlusReferralDashboard }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v2(NavigateDown(v4))
		end

		FlyoutAnalytics.onFlyoutContentItemClicked({
			integrationId = "PlusReferral",
			source = "click"
		})
	end, { p.closeDrawer, v2 }), "RobloxPlusUpsellImpressionCount1")

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-medium",
		onActivated = v4.onActivated,
		testId = "--core-ui-flyout-plus-referral",
		LayoutOrder = p.layoutOrder
	}
	local v6 = {
		PlusIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = React.createElement(Text, {
			tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
			Text = v3.bannerText,
			LayoutOrder = 2
		}),
		NewBadge = 0
	}
	local newBadge

	if v4.shouldShowNewBadge then
		newBadge = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-circle bg-system-contrast",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(Text, {
					Text = v3.newBadgeText,
					tag = "auto-xy text-title-small",
					textStyle = v.Color.Surface.Surface_0
				})
			}
		)
	end

	v6.NewBadge = newBadge
	return createElement(view, v5, v6)
end

return PlusReferralBanner
