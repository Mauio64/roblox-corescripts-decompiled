local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

return function(callback, p2, p3)
	local APIS_URL = module.APIS_URL

	local urlEncode = HttpService:UrlEncode(p2)
	return callback(
		string.format("%sgames-autocomplete/v1/get-suggestion/%s", APIS_URL, urlEncode),
		"GET",
		{ timeout = 5000 }
	)
end
