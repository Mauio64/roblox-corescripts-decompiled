local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Http").Url
local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = HomeConstants.ApiName })

local function getHomePageUrl()
	return v5()
end

return getHomePageUrl
