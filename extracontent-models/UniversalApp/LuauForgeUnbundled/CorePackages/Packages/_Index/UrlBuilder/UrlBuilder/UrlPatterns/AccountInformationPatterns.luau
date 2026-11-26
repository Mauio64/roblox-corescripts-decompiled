local module = require("@luauforge/bundled/fzK")

return function(callback)
	return callback(module.fromString("accountinformation:phone")(), "GET")
end
