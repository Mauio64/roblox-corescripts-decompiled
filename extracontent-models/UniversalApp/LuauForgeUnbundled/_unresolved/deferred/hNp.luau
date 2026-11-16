local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value, value2)
	assert(type(value) == "string", "invalid current password")
	assert(type(value2) == "string", "invalid new password")

	return callback(string.format("%sv2/user/passwords/change", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			currentPassword = value,
			newPassword = value2
		})
	})
end
