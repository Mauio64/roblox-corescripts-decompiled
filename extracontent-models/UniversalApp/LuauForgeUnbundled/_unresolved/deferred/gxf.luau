local url = require("@luauforge/deferred/gxg").Url

local HttpService = game:GetService("HttpService")

return function(callback)
	return callback(url.APIS_URL .. "account-unlock-api/v1/unlock", "POST", {
		postBody = HttpService:JSONEncode({})
	})
end
