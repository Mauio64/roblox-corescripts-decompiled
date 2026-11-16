local module = require("@luauforge/deferred/huS")

return function(callback)
	return {
		completeExternalNavigation = function(p2)
			callback(module(p2))
		end
	}
end
