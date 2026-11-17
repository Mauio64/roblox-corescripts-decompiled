local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FFlagRobloxPlusUpsellBannerUseTryItForFree = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusUpsellBannerUseTryItForFree)
local FFlagTTOnboardingSheet = require(RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet)

local function RobloxPlusUpsellBannerCTA(props)
	local v = useLocalization({
		getFreeTrialText = FFlagRobloxPlusUpsellBannerUseTryItForFree and "Feature.RobloxSubscription.Action.TryItForFree" or "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		newBadge = "Feature.Catalog.Label.New"
	})

	local v2 = React.useCallback(function()
		if FFlagTTOnboardingSheet and props.ctaText then
			return props.ctaText
		end

		if props.productInfo.isFreeTrial then
			return v.getFreeTrialText
		end

		return v.subscribe
	end, { props.productInfo.isFreeTrial, v.getFreeTrialText, v.subscribe, props.ctaText })

	if props.shouldShowNewBadge then
		return React.createElement(
			View,
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				tag = "row align-y-center gap-xsmall auto-xy"
			},
			{
				NewBadge = React.createElement(Badge, {
					text = v.newBadge,
					variant = BadgeVariant.Contrast,
					LayoutOrder = 1
				})
			}
		)
	end

	return React.createElement(
		View,
		{ AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), tag = "auto-xy" },
		{
			SubscribeText = React.createElement(Text, {
				tag = "auto-xy text-body-small content-default",
				Text = "<u>" .. v2() .. "</u>",
				RichText = true
			})
		}
	)
end

return RobloxPlusUpsellBannerCTA
