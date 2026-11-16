local HttpService = game:GetService("HttpService")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value)
	assert(type(value) == "string", "invalid delivery target")
	return callback(string.format("%sv1/verified-signup/challenge", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ deliveryMethod = 0, deliveryTarget = value })
	})
end
