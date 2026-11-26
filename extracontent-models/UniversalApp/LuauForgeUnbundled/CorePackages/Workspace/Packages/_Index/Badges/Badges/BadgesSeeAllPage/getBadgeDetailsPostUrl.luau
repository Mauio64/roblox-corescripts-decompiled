local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Badges/Http").Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/badge-details-page/v1beta1"
})

local function getBadgeDetailsPostUrl()
	return v5()
end

return getBadgeDetailsPostUrl
