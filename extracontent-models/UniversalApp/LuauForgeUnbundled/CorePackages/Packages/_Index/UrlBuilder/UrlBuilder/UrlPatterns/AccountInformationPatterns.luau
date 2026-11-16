local module = require("@luauforge/bundled/fsq")

return function(callback)
	return callback(module.fromString("accountinformation:phone")(), "GET")
end
