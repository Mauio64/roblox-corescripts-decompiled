local module = require("@luauforge/deferred/hFZ")

return function(callback)
	return {
		completeExternalNavigation = function(p2)
			callback(module(p2))
		end
	}
end
