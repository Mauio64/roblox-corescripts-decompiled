local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/frI").Url

return function(callback, p2, p3)
	return callback(
		string.format("%saccount-security-service/v1/prompt-assignments", url.APIS_URL),
		"POST",
		{
			postBody = HttpService:JSONEncode({ promptType = p2, action = p3 })
		}
	)
end
