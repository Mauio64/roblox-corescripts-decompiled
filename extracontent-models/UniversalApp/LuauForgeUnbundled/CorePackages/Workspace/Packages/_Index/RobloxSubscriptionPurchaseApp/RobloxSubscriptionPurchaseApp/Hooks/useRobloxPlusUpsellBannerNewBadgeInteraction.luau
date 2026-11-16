local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local RobloxPlusUnifiedBuyModalBannerImpression = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Storage/RobloxPlusUnifiedBuyModalBannerImpression")
local FIntNewBadgeMaximumImpressionCount = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FIntNewBadgeMaximumImpressionCount")

local function useRobloxPlusUpsellBannerNewBadgeInteraction(callback)
	local v5 = React.useState(function()
		return RobloxPlusUnifiedBuyModalBannerImpression.getImpressionCount()
	end) < FIntNewBadgeMaximumImpressionCount

	return {
		shouldShowNewBadge = v5,
		onActivated = React.useCallback(function()
			if v5 then
				RobloxPlusUnifiedBuyModalBannerImpression.incrementImpressionCount()
			end

			callback()
		end, { v5, callback })
	}
end

return useRobloxPlusUpsellBannerNewBadgeInteraction
