local urlBuilder = require("@luauforge/bundled/dsZ").UrlBuilder
local url = require("@luauforge/bundled/drq").Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "/charts-api/v1/get-sort-content"
})

return function(callback, p2)
	return callback(urlBuilder.addQueryString(v5(), p2), "GET")
end
