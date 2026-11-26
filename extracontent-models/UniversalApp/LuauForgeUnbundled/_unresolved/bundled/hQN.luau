local module = require("@luauforge/bundled/fzK")

return function(callback)
	return callback(module.usermoderation.reminder(), "GET")
end
