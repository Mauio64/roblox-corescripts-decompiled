local module = require("@luauforge/bundled/dVn")
local v5 = require("@luauforge/bundled/fzK").new({
	base = module.AUTH_URL,
	path = "v3/signup/bundles"
})

return function(callback)
	return callback(v5(), "GET")
end
