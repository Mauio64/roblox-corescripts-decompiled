local url = require("@luauforge/deferred/hQu").Url
local urlBuilder = require("@luauforge/deferred/hQv").UrlBuilder

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/spotlight-collection"
})

local function getSduiLandingPageUrl(p2, p3)
	return urlBuilder.addQueryString(v5(), {
		spotlightCollectionId = p2,
		sessionId = p3
	})
end

return getSduiLandingPageUrl
