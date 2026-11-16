local url = require("@luauforge/bundled/dBo").Url
local urlBuilder = require("@luauforge/bundled/dBp").UrlBuilder.new({
	base = url.APIS_URL,
	path = "community-links/v1/universes/{universeId}/community"
})

return function(callback, p2)
	return callback(urlBuilder({ universeId = p2 }), "GET")
end
