local parent = script:FindFirstAncestor("Badges").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "landing-page-api/badge-details-page/v1beta1"
})

local function getBadgeDetailsPostUrl()
	return v()
end

return getBadgeDetailsPostUrl
