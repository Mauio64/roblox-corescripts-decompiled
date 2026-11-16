local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fsq")

return function(callback, p2, p3)
	local v5 = module.fromString("apis:account-switcher/v1/getLoggedInUsersMetadata")
	local jsonEncode = HttpService:JSONEncode({
		encrypted_users_data_blob = p2,
		remove_invalid_active_user = p3
	})

	return callback(v5(), "POST", { postBody = jsonEncode })
end
