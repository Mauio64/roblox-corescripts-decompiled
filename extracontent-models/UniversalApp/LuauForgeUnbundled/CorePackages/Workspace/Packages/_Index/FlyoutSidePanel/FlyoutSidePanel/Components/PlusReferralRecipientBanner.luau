local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local fIntPlusReferralRewardRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FIntPlusReferralRewardRobux
local usePlusReferralFlyoutNewBadge = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/usePlusReferralFlyoutNewBadge")

local function PlusReferralRecipientBanner(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Heading.ReferralRecipientEntry",
			amount = tostring(fIntPlusReferralRewardRobux)
		},
		newBadgeText = "Feature.RobloxSubscription.Label.New"
	})

	local v7 = usePlusReferralFlyoutNewBadge(React.useCallback(function()
		props.closeDrawer()

		if props.onOpenReferralSheet then
			props.onOpenReferralSheet(props.referrerId)
		end

		FlyoutAnalytics.onFlyoutContentItemClicked({
			integrationId = "PlusReferralRecipient",
			source = "click"
		})
	end, { props.closeDrawer, props.referrerId, props.onOpenReferralSheet }), "RobloxPlusUpsellImpressionCount3")

	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-medium",
		onActivated = v7.onActivated,
		testId = "--core-ui-flyout-plus-referral-recipient",
		LayoutOrder = props.layoutOrder
	}
	local v9 = {
		PlusIcon = React.createElement(icon, {
			style = v5.Color.Content.Emphasis,
			name = iconName.RobloxPlus,
			size = iconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = React.createElement(text, {
			tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
			Text = v6.bannerText,
			LayoutOrder = 2
		}),
		NewBadge = 0
	}

	local v10 = if v7.shouldShowNewBadge then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-circle bg-system-contrast",
			LayoutOrder = 3
		},
		{
			Text = React.createElement(text, {
				Text = v6.newBadgeText,
				tag = "auto-xy text-title-small",
				textStyle = v5.Color.Surface.Surface_0
			})
		}
	) else nil
	v9.NewBadge = v10
	return createElement(view, v8, v9)
end

return PlusReferralRecipientBanner
