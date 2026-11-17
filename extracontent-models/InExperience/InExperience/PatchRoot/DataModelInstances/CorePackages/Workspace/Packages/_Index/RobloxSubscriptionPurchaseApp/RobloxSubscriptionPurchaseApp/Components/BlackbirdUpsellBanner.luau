local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagSupportNewBadgeRobloxPlus = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportNewBadgeRobloxPlus)
local useRobloxPlusUpsellBannerNewBadgeInteraction = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxPlusUpsellBannerNewBadgeInteraction)
local RobloxPlusUpsellBannerCTA = require(script.Parent.RobloxPlusUpsellBannerCTA)
local FFlagRobloxPlusUpsellBannerUseTryItForFree = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusUpsellBannerUseTryItForFree)
local defineFastFlag = game:DefineFastFlag("BoldBlackbirdUpsellBannerStroke", false)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase
local FFlagTTOnboardingSheet = require(RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet)

local function BlackbirdUpsellBanner(props)
	local v = useTokens()

	local v2 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Label.BlackbirdUpsellBanner",
			discountPercentage = props.productInfo.initialDiscountPercentage or 10
		},
		getFreeTrialText = FFlagRobloxPlusUpsellBannerUseTryItForFree and "Feature.RobloxSubscription.Action.TryItForFree" or "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe"
	})

	local v3 = React.useCallback(function()
		if props.productInfo.isFreeTrial then
			return v2.getFreeTrialText
		end

		return v2.subscribe
	end, { props.productInfo.isFreeTrial, v2.getFreeTrialText, v2.subscribe })
	local v4

	if FFlagSupportNewBadgeRobloxPlus then
		v4 = useRobloxPlusUpsellBannerNewBadgeInteraction(props.onActivated)
	end

	local createElement = React.createElement
	local onActivated

	if FFlagSupportNewBadgeRobloxPlus then
		onActivated = v4.onActivated
	else
		onActivated = props.onActivated
	end

	local v5 = {
		tag = "size-full-0 auto-y padding-medium",
		onActivated = onActivated,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement

	local v6 = {
		BlackbirdIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		Size = UDim2.new(0.7, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		tag = "text-body-small text-align-x-left content-emphasis",
		Text = 0,
		LayoutOrder = 2
	}
	local text

	if (FFlagLuaAppsEnablePromptVIPServerPurchase or FFlagTTOnboardingSheet) and props.bannerText then
		text = props.bannerText
	else
		text = v2.bannerText
	end

	v7.Text = text
	v6.BannerText = createElement3(Text, v7)
	local children = {
		ContentContainer = createElement2(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, v6),
		SubscribeText = 0,
		SubscribeCTA = 0,
		UIStroke = 0,
		UICorner = 0
	}
	local subscribeText

	if not FFlagSupportNewBadgeRobloxPlus then
		subscribeText = React.createElement(Text, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			tag = "auto-xy text-body-small content-default",
			Text = "<u>" .. v3() .. "</u>",
			RichText = true
		})
	end

	children.SubscribeText = subscribeText
	local subscribeCTA

	if FFlagSupportNewBadgeRobloxPlus then
		local createElement4 = React.createElement
		local v8 = {
			productInfo = props.productInfo,
			shouldShowNewBadge = v4.shouldShowNewBadge,
			ctaText = 0
		}
		local ctaText

		if FFlagTTOnboardingSheet then
			ctaText = props.ctaText
		end

		v8.ctaText = ctaText
		subscribeCTA = createElement4(RobloxPlusUpsellBannerCTA, v8)
	end

	children.SubscribeCTA = subscribeCTA

	local createElement4 = React.createElement
	local v8 = {
		Color = v.Color.Stroke.Default.Color3,
		Transparency = v.Color.Stroke.Default.Transparency,
		Thickness = 0
	}
	local thickness

	if defineFastFlag then
		thickness = v.Stroke.Thick
	else
		thickness = v.Stroke.Standard
	end

	v8.Thickness = thickness
	children.UIStroke = createElement4("UIStroke", v8)

	children.UICorner = React.createElement("UICorner", {
		CornerRadius = UDim.new(0, v.Radius.Medium)
	})
	return createElement(View, v5, children)
end

return BlackbirdUpsellBanner
