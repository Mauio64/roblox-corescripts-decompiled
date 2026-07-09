local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local FFlagSupportNewBadgeRobloxPlus = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportNewBadgeRobloxPlus)
local useRobloxPlusUpsellBannerNewBadgeInteraction = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxPlusUpsellBannerNewBadgeInteraction)
local RobloxPlusUpsellBannerCTA = require(script.Parent.RobloxPlusUpsellBannerCTA)
local v15 = game:DefineFastFlag("BoldBlackbirdUpsellBannerStroke", false)

local function BlackbirdUpsellBanner(t1: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), FFlagSupportNewBadgeRobloxPlus (copy), useRobloxPlusUpsellBannerNewBadgeInteraction (copy), View (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy), RobloxPlusUpsellBannerCTA (copy), v15 (copy)
	local v18 = useTokens()
	local v19 = useLocalization({
		getFreeTrialText = "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		bannerText = {
			"Feature.RobloxSubscription.Label.BlackbirdUpsellBanner",
			discountPercentage = t1.productInfo.initialDiscountPercentage or 10
		}
	})
	local v20 = React.useCallback(function() -- line: 47
		-- upvalues: t1 (copy), v19 (copy)
		if t1.productInfo.isFreeTrial then
			return v19.getFreeTrialText
		end

		return v19.subscribe
	end, {
		t1.productInfo.isFreeTrial,
		v19.getFreeTrialText,
		v19.subscribe
	})
	local v21 = nil

	if FFlagSupportNewBadgeRobloxPlus then
		v21 = useRobloxPlusUpsellBannerNewBadgeInteraction(t1.onActivated)
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-medium",
		onActivated = if not FFlagSupportNewBadgeRobloxPlus then t1.onActivated else v21.onActivated,
		LayoutOrder = t1.LayoutOrder
	}, {
		ContentContainer = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, {
			BlackbirdIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				style = v18.Color.Content.Emphasis,
				name = IconName.RobloxPlus,
				size = IconSize.Medium
			}),
			BannerText = React.createElement(FoundationText, {
				TextWrapped = true,
				tag = "text-body-small text-align-x-left content-emphasis",
				LayoutOrder = 2,
				Size = UDim2.new(0.7, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v19.bannerText
			})
		}),
		SubscribeText = if FFlagSupportNewBadgeRobloxPlus then nil else React.createElement(FoundationText, {
			tag = "auto-xy text-body-small content-default",
			RichText = true,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Text = "<u>" .. v20() .. "</u>"
		}),
		SubscribeCTA = if not FFlagSupportNewBadgeRobloxPlus then nil else React.createElement(RobloxPlusUpsellBannerCTA, {
			productInfo = t1.productInfo,
			shouldShowNewBadge = v21.shouldShowNewBadge
		}),
		UIStroke = React.createElement("UIStroke", {
			Color = v18.Color.Stroke.Default.Color3,
			Transparency = v18.Color.Stroke.Default.Transparency,
			Thickness = if not v15 then v18.Stroke.Standard else v18.Stroke.Thick
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v18.Radius.Medium)
		})
	})
end

return BlackbirdUpsellBanner
