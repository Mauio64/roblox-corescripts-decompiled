local url = require("@luauforge/bundled/dus").Url

return function(callback)
	return callback(string.format("%supsellcard/type", url.APIS_URL), "GET")
end
