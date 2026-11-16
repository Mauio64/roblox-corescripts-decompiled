local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/fsq")

return function(callback, p2, p3, p4)
	local v5 = module.fromString("apis:account-switcher/v1/switch")
	local jsonEncode = HttpService:JSONEncode({
		switched_to_user_id = p2,
		switched_from_user_id = p4,
		encrypted_users_data_blob = p3
	})

	return callback(v5(), "POST", { postBody = jsonEncode })
end
