local HttpService = game:GetService("HttpService")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(
		Url.APIS_URL .. "parental-controls-api/v1/parental-controls/add-temporary-screentime",
		"POST",
		{
			postBody = HttpService:JSONEncode({ minutes = p2 })
		}
	)
end
