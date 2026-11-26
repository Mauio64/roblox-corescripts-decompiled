local FIntSocalCarouselMaxNewRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FIntSocalCarouselMaxNewRequestsCount")

local function getBadgeAnalyticsFields(p2, p3)
	return {
		newRequestCount = p2,
		badgeEnabled = p3,
		badgeShown = p3 and p2 > 0,
		badgeCapped = FIntSocalCarouselMaxNewRequestsCount < p2
	}
end

return getBadgeAnalyticsFields
