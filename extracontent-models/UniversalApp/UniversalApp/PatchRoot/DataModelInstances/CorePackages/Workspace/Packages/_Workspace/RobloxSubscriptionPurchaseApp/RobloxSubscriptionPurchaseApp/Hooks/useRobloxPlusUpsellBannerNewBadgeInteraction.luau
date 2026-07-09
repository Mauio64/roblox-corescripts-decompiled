local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local RobloxPlusUnifiedBuyModalBannerImpression = require(RobloxSubscriptionPurchaseApp.Storage.RobloxPlusUnifiedBuyModalBannerImpression)
local FIntNewBadgeMaximumImpressionCount = require(RobloxSubscriptionPurchaseApp.Flags.FIntNewBadgeMaximumImpressionCount)

local function useRobloxPlusUpsellBannerNewBadgeInteraction(p1: ((...any) -> ...any)) -- line: 24
	-- upvalues: React (copy), RobloxPlusUnifiedBuyModalBannerImpression (copy), FIntNewBadgeMaximumImpressionCount (copy)
	local v8 = React.useState(function() -- line: 27
		-- upvalues: RobloxPlusUnifiedBuyModalBannerImpression (copy)
		return RobloxPlusUnifiedBuyModalBannerImpression.getImpressionCount()
	end) < FIntNewBadgeMaximumImpressionCount
	local v9 = React.useCallback(function() -- line: 33
		-- upvalues: v8 (copy), RobloxPlusUnifiedBuyModalBannerImpression (copy), p1 (copy)
		if v8 then
			RobloxPlusUnifiedBuyModalBannerImpression.incrementImpressionCount()
		end

		p1()
	end, {
		v8,
		p1
	})

	return {
		shouldShowNewBadge = v8,
		onActivated = v9
	}
end

return useRobloxPlusUpsellBannerNewBadgeInteraction
