local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)

local useRobloxPlusUpsellBannerViewModel = require(RobloxSubscriptionPurchaseApp.Hooks.useRobloxPlusUpsellBannerViewModel)

local function RobloxPlusUpsellBanner(data)
	local v = useRobloxPlusUpsellBannerViewModel({
		subscribeText = data.subscribeText,
		freeTrialText = data.freeTrialText
	})

	return data.renderBanner({
		message = data.message,
		actionText = v.actionText,
		onActivated = data.onActivated,
		showPlusIcon = data.showPlusIcon,
		LayoutOrder = data.LayoutOrder,
		testId = data.testId
	})
end

return React.memo(RobloxPlusUpsellBanner)
