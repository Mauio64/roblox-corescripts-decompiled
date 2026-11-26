local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/dVn")

return function(callback, p2)
	return callback(
		module.APIS_URL .. "parental-controls-api/v1/parental-controls/add-temporary-screentime",
		"POST",
		{
			postBody = HttpService:JSONEncode({ minutes = p2 })
		}
	)
end
