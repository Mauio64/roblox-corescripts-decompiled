local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local useRobloxPlusUpsellBannerViewModel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useRobloxPlusUpsellBannerViewModel")

local function RobloxPlusUpsellBanner(data)
	local v5 = useRobloxPlusUpsellBannerViewModel({
		subscribeText = data.subscribeText,
		freeTrialText = data.freeTrialText
	})

	return data.renderBanner({
		message = data.message,
		actionText = v5.actionText,
		onActivated = data.onActivated,
		showPlusIcon = data.showPlusIcon,
		LayoutOrder = data.LayoutOrder,
		testId = data.testId
	})
end

return React.memo(RobloxPlusUpsellBanner)
