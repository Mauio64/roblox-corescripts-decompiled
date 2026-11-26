local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/dus").Url

return function(callback, p2)
	assert(callback, "requestImpl is required")
	assert(p2, "upsellCardType is required")

	local jsonEncode = HttpService:JSONEncode({ cardType = p2 })

	return callback(string.format("%supsellcard/dismiss", url.APIS_URL), "POST", {
		postBody = jsonEncode
	})
end
