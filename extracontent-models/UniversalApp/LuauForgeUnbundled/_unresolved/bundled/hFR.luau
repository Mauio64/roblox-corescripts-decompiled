local module = require("@luauforge/bundled/fsq")

return function(callback)
	return callback(module.usermoderation.reminder(), "GET")
end
