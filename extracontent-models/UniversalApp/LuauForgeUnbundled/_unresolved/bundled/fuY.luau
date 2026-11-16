local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value)
	assert(type(value) == "string", "EconomyGetCurrency request expects userId to be a string")

	return callback(string.format("%s/v1/users/%s/currency", Url.ECONOMY_URL, value), "GET")
end
