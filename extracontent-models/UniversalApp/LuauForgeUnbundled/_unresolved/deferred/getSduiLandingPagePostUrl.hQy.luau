local url = require("@luauforge/deferred/hQu").Url
local urlBuilder = require("@luauforge/deferred/hQv").UrlBuilder.new({
	base = url.APIS_URL,
	path = "landing-page-api/spotlight-collection"
})

local function getSduiLandingPagePostUrl()
	return urlBuilder()
end

return getSduiLandingPagePostUrl
