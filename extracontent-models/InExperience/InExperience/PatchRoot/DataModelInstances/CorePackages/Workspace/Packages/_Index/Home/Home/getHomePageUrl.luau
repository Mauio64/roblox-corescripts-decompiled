local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local HomeConstants = require(Home.HomeConstants)

local v = urlBuilder.new({ base = Url.APIS_URL, path = HomeConstants.ApiName })

local function getHomePageUrl()
	return v()
end

return getHomePageUrl
