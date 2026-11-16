local url = require("@luauforge/deferred/hFt").Url
local urlBuilder = require("@luauforge/deferred/hFu").UrlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/spotlight-collection"
})

local function getSduiLandingPagePostUrl()
	return urlBuilder()
end

return getSduiLandingPagePostUrl
