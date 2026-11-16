local module = require("@luauforge/bundled/fsq")

return function(callback)
	return callback(module.usermoderation.accessDetail(), "GET")
end
