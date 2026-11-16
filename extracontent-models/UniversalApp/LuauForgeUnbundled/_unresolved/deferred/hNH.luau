local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(
		Url.APIS_URL .. "identity-verification-service/v1/vietnam/start-verification-form",
		"GET"
	)
end
