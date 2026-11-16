local parent = script:FindFirstAncestor("Charts").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

local v = urlBuilder.new({ base = Url.APIS_URL, path = "charts-api/v1/charts-page-stream" })

local function getChartsPageStreamUrl()
	return v()
end

return getChartsPageStreamUrl
