local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local view = Foundation.View
local text = Foundation.Text
local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local FFlagRobloxPlusUpsellBannerUseTryItForFree = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusUpsellBannerUseTryItForFree")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")

local function RobloxPlusUpsellBannerCTA(props)
	local v5 = useLocalization({
		getFreeTrialText = FFlagRobloxPlusUpsellBannerUseTryItForFree and "Feature.RobloxSubscription.Action.TryItForFree" or "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		newBadge = "Feature.Catalog.Label.New"
	})

	local v6 = React.useCallback(function()
		if FFlagTTOnboardingSheet and props.ctaText then
			return props.ctaText
		end

		if props.productInfo.isFreeTrial then
			return v5.getFreeTrialText
		end

		return v5.subscribe
	end, {
		props.productInfo.isFreeTrial,
		v5.getFreeTrialText,
		v5.subscribe,
		props.ctaText
	})

	if props.shouldShowNewBadge then
		return React.createElement(
			view,
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				tag = "row align-y-center gap-xsmall auto-xy"
			},
			{
				NewBadge = React.createElement(badge, {
					text = v5.newBadge,
					variant = badgeVariant.Contrast,
					LayoutOrder = 1
				})
			}
		)
	end

	return React.createElement(
		view,
		{
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			tag = "auto-xy"
		},
		{
			SubscribeText = React.createElement(text, {
				tag = "auto-xy text-body-small content-default",
				Text = "<u>" .. v6() .. "</u>",
				RichText = true
			})
		}
	)
end

return RobloxPlusUpsellBannerCTA
