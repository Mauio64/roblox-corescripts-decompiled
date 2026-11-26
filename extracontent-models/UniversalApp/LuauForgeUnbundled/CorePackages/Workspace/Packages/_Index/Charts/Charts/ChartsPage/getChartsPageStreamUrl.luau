local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/Http").Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "charts-api/v1/charts-page-stream"
})

local function getChartsPageStreamUrl()
	return v5()
end

return getChartsPageStreamUrl
