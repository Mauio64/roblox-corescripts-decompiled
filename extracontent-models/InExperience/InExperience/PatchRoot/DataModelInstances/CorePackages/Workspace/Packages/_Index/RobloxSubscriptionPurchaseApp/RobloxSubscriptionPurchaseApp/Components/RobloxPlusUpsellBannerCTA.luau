local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function RobloxPlusUpsellBannerCTA(t1: {[any]: any}) -- line: 25
	-- upvalues: useLocalization (copy), React (copy), View (copy), Badge (copy), BadgeVariant (copy), FoundationText (copy)
	local v11 = useLocalization({
		getFreeTrialText = "Feature.RobloxSubscription.Label.FreeTrialText",
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		newBadge = "Feature.Catalog.Label.New"
	})
	local v12 = React.useCallback(function() -- line: 32
		-- upvalues: t1 (copy), v11 (copy)
		if t1.productInfo.isFreeTrial then
			return v11.getFreeTrialText
		end

		return v11.subscribe
	end, {
		t1.productInfo.isFreeTrial,
		v11.getFreeTrialText,
		v11.subscribe
	})

	if t1.shouldShowNewBadge then
		return React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0)
		}, {
			NewBadge = React.createElement(Badge, {
				LayoutOrder = 1,
				text = v11.newBadge,
				variant = BadgeVariant.Contrast
			})
		})
	end

	return React.createElement(View, {
		tag = "auto-xy",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0)
	}, {
		SubscribeText = React.createElement(FoundationText, {
			tag = "auto-xy text-body-small content-default",
			RichText = true,
			Text = "<u>" .. v12() .. "</u>"
		})
	})
end

return RobloxPlusUpsellBannerCTA
