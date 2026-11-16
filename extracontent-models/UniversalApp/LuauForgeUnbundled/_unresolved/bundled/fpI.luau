local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2, p3)
	local APIS_URL = Url.APIS_URL

	local urlEncode = HttpService:UrlEncode(p2)
	return callback(
		string.format("%sgames-autocomplete/v1/get-suggestion/%s", APIS_URL, urlEncode),
		"GET",
		{ timeout = 5000 }
	)
end
