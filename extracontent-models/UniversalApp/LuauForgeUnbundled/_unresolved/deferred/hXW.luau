local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

return function(callback, value, value2)
	assert(type(value) == "string", "invalid current password")
	assert(type(value2) == "string", "invalid new password")

	return callback(string.format("%sv2/user/passwords/change", module.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			currentPassword = value,
			newPassword = value2
		})
	})
end
