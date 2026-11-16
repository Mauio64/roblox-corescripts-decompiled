local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value)
	assert(type(value) == "string", "invalid account PIN")

	return callback(string.format("%sv1/account/pin/unlock", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ pin = value })
	})
end
