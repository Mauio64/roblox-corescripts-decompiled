local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/fzK")

return function(callback)
	return callback(module2.new({
		base = module.USERS_URL,
		path = "users/authenticated/roles"
	})(), "GET")
end
