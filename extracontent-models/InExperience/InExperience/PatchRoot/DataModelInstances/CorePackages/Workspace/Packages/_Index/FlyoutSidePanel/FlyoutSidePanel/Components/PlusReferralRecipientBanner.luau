local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FIntPlusReferralRewardRobux = SharedFlags.FIntPlusReferralRewardRobux
local usePlusReferralFlyoutNewBadge = require(FlyoutSidePanel.Hooks.usePlusReferralFlyoutNewBadge)

local function PlusReferralRecipientBanner(props)
	local v = useTokens()
	local v2 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Heading.ReferralRecipientEntry",
			amount = tostring(FIntPlusReferralRewardRobux)
		},
		newBadgeText = "Feature.RobloxSubscription.Label.New"
	})

	local v3 = usePlusReferralFlyoutNewBadge(React.useCallback(function()
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
	local v4 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-medium",
		onActivated = v3.onActivated,
		testId = "--core-ui-flyout-plus-referral-recipient",
		LayoutOrder = props.layoutOrder
	}
	local v5 = {
		PlusIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = React.createElement(Text, {
			tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
			Text = v2.bannerText,
			LayoutOrder = 2
		}),
		NewBadge = 0
	}
	local newBadge

	if v3.shouldShowNewBadge then
		newBadge = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-circle bg-system-contrast",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(Text, {
					Text = v2.newBadgeText,
					tag = "auto-xy text-title-small",
					textStyle = v.Color.Surface.Surface_0
				})
			}
		)
	end

	v5.NewBadge = newBadge
	return createElement(view, v4, v5)
end

return PlusReferralRecipientBanner
