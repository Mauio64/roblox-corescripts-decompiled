local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fsq")

return function(callback, p2, p3)
	local v5 = module.fromString("apis:sharelinks/v1/get-metadata")
	local jsonEncode = HttpService:JSONEncode({ linkId = p2, linkType = p3 })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
