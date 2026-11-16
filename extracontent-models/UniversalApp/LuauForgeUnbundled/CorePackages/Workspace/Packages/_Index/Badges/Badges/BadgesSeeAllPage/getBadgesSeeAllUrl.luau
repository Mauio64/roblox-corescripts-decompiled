local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Http").Url
local BadgesSeeAllPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/Badges/Badges/BadgesSeeAllPage/BadgesSeeAllPageConstants")

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/badges-see-all/v1beta1"
})

local function getBadgesSeeAllUrl(p2, p3)
	return (urlBuilder.addQueryString(v5(), {
		universeId = p2,
		pageSize = BadgesSeeAllPageConstants.RequestPageSize,
		cursor = p3,
		PageEntryFormat = "Universal"
	}))
end

return getBadgesSeeAllUrl
