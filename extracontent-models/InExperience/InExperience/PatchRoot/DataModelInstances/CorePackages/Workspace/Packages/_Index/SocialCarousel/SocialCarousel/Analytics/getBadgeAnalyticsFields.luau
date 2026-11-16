local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local FIntSocalCarouselMaxNewRequestsCount = require(SocialCarousel.Flags.FIntSocalCarouselMaxNewRequestsCount)

local function getBadgeAnalyticsFields(newRequestCount: number, badgeEnabled: boolean)
	return {
		newRequestCount = newRequestCount,
		badgeEnabled = badgeEnabled,
		badgeShown = badgeEnabled and newRequestCount > 0,
		badgeCapped = FIntSocalCarouselMaxNewRequestsCount < newRequestCount
	}
end

return getBadgeAnalyticsFields
