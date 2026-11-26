local urlBuilder = require("@luauforge/bundled/dwb").UrlBuilder
local url = require("@luauforge/bundled/dus").Url

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "/charts-api/v1/get-sort-content"
})

return function(callback, p2)
	return callback(urlBuilder.addQueryString(v5(), p2), "GET")
end
