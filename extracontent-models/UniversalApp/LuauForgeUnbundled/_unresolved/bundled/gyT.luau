local module = require("@luauforge/bundled/dVn")
local v5 = require("@luauforge/bundled/fzK").new({
	base = module.USERS_URL,
	path = "display-names/validate",
	query = "displayname={displayname}&birthdate={birthday}"
})

return function(callback, p2, p3)
	return callback(v5({ ["displayname"] = p2, birthday = p3 }), "GET", {
		maxRetryCount = 0
	})
end
