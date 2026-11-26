local url = require("@luauforge/bundled/dEt").Url
local urlBuilder = require("@luauforge/bundled/dEu").UrlBuilder.new({
	base = url.APIS_URL,
	path = "community-links/v1/guilded/{communityId}/join",
	query = { a = "red", skipRedirect = "true" }
})

return function(callback, p2)
	return callback(urlBuilder({ communityId = p2 }), "GET")
end
