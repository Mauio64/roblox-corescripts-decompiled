local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/dJl").Url

return function(callback, p2, p3)
	return callback(string.format("%schallenge-dialog-service/v1/dialogs", url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ dialog = p2, action = p3 })
	})
end
