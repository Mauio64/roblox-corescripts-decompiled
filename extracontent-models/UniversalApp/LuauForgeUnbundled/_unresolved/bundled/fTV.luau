local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local v5 = require("@luauforge/bundled/fsq").new({
	base = Url.USERS_URL,
	path = "display-names/validate",
	query = "displayname={displayname}&birthdate={birthday}"
})

return function(callback, p2, p3)
	return callback(v5({ ["displayname"] = p2, birthday = p3 }), "GET", {
		maxRetryCount = 0
	})
end
