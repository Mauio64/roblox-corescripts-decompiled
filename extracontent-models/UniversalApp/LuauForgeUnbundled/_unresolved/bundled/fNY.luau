local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback, p2, p3)
	return callback(
		string.format(
			"%s/v1/%s/token-authentication?apiKey=%s",
			url.AUTH_URL,
			p2,
			"d631f3d9-fce0-4711-8cf4-6f9a9756638b"
		),
		"POST",
		{ postBody = HttpService:JSONEncode(p3) }
	)
end
