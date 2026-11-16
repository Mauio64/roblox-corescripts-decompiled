local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization

local FFlagSupportNewBadgeRobloxPlus = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagSupportNewBadgeRobloxPlus")
local useRobloxPlusUpsellBannerNewBadgeInteraction = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useRobloxPlusUpsellBannerNewBadgeInteraction")
local RobloxPlusUpsellBannerCTA = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxPlusUpsellBannerCTA")
local FFlagRobloxPlusUpsellBannerUseTryItForFree = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusUpsellBannerUseTryItForFree")
local defineFastFlag = game:DefineFastFlag("BoldBlackbirdUpsellBannerStroke", false)

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function BlackbirdUpsellBanner(props)
	local v5 = useTokens()

	local v6 = useLocalization({
		bannerText = {
			"Feature.RobloxSubscription.Label.BlackbirdUpsellBanner",
			discountPercentage = props.productInfo.initialDiscountPercentage or 10
		},
		getFreeTrialText = FFlagRobloxPlusUpsellBannerUseTryItForFree and "Feature.RobloxSubscription.Action.TryItForFree" or "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe"
	})

	local v7 = React.useCallback(function()
		if props.productInfo.isFreeTrial then
			return v6.getFreeTrialText
		end

		return v6.subscribe
	end, { props.productInfo.isFreeTrial, v6.getFreeTrialText, v6.subscribe })

	local v8 = if FFlagSupportNewBadgeRobloxPlus then useRobloxPlusUpsellBannerNewBadgeInteraction(props.onActivated) else nil

	local createElement = React.createElement

	local v11 = if FFlagSupportNewBadgeRobloxPlus then v8.onActivated else props.onActivated
	local v10 = {
		tag = "size-full-0 auto-y padding-medium",
		onActivated = v11,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement

	local v14 = {
		BlackbirdIcon = React.createElement(icon, {
			style = v5.Color.Content.Emphasis,
			name = iconName.RobloxPlus,
			size = iconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		Size = UDim2.new(0.7, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		tag = "text-body-small text-align-x-left content-emphasis",
		Text = 0,
		LayoutOrder = 2
	}

	local v17 = if fFlagLuaAppsEnablePromptVIPServerPurchase and props.bannerText then props.bannerText else v6.bannerText
	v16.Text = v17
	v14.BannerText = createElement3(text, v16)
	local children = {
		ContentContainer = createElement2(
			view,
			{ tag = "row align-y-center gap-small size-full-0 auto-y" },
			v14
		),
		SubscribeText = 0,
		SubscribeCTA = 0,
		UIStroke = 0,
		UICorner = 0
	}

	local v18 = if not FFlagSupportNewBadgeRobloxPlus then React.createElement(text, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		tag = "auto-xy text-body-small content-default",
		Text = "<u>" .. v7() .. "</u>",
		RichText = true
	}) else nil
	children.SubscribeText = v18

	local v19 = if FFlagSupportNewBadgeRobloxPlus then React.createElement(RobloxPlusUpsellBannerCTA, {
		productInfo = props.productInfo,
		shouldShowNewBadge = v8.shouldShowNewBadge
	}) else nil
	children.SubscribeCTA = v19

	local createElement4 = React.createElement
	local v21 = {
		Color = v5.Color.Stroke.Default.Color3,
		Transparency = v5.Color.Stroke.Default.Transparency,
		Thickness = 0
	}
	local v22 = if defineFastFlag then v5.Stroke.Thick else v5.Stroke.Standard
	v21.Thickness = v22
	children.UIStroke = createElement4("UIStroke", v21)

	children.UICorner = React.createElement("UICorner", {
		CornerRadius = UDim.new(0, v5.Radius.Medium)
	})
	return createElement(view, v10, children)
end

return BlackbirdUpsellBanner
