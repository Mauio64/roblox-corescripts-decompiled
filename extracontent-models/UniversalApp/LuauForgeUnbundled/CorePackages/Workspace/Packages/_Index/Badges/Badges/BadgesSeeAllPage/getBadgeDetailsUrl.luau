local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Http").Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/badge-details-page/v1beta1"
})

local function getBadgeDetailsUrl(p2, userId)
	local v6 = { badgeId = p2 }

	if userId then
		v6.userId = userId
	end

	v6.PageEntryFormat = "Universal"
	return (urlBuilder.addQueryString(v5(), v6))
end

return getBadgeDetailsUrl
