local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)

local RobloxPlusUnifiedBuyModalBannerImpression = require(RobloxSubscriptionPurchaseApp.Storage.RobloxPlusUnifiedBuyModalBannerImpression)
local FIntNewBadgeMaximumImpressionCount = require(RobloxSubscriptionPurchaseApp.Flags.FIntNewBadgeMaximumImpressionCount)

local function useRobloxPlusUpsellBannerNewBadgeInteraction(callback)
	local shouldShowNewBadge = React.useState(function()
		return RobloxPlusUnifiedBuyModalBannerImpression.getImpressionCount()
	end) < FIntNewBadgeMaximumImpressionCount

	return {
		shouldShowNewBadge = shouldShowNewBadge,
		onActivated = React.useCallback(function()
			if shouldShowNewBadge then
				RobloxPlusUnifiedBuyModalBannerImpression.incrementImpressionCount()
			end

			callback()
		end, { shouldShowNewBadge, callback })
	}
end

return useRobloxPlusUpsellBannerNewBadgeInteraction
